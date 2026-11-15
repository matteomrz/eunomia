//
//  EditGoalView.swift
//  eunomia
//
//  Created by Matteo Merz on 14.11.26.
//

import OSLog
import SwiftData
import SwiftUI

enum EditGoalMode {
  case create, edit
}

struct EditGoalView: View {
  @Binding private var showView: Bool

  private let mode: EditGoalMode
  @State private var goal: Goal
  @Environment(GoalController.self) private var controller: GoalController

  @State private var selColor: Color
  @State private var isPickingIcon = false

  init(show: Binding<Bool>, mode: EditGoalMode, goal: Goal) {
    self._showView = show
    self.mode = mode
    self.goal = goal
    self.selColor = Color(rgba: goal.color)
  }

  var body: some View {
    NavigationStack {
      Form {
        ZStack(alignment: .bottomTrailing) {
          Text(goal.icon)
            .font(.system(size: 64))
            .aspectRatio(1, contentMode: .fit)
            .padding(16)
            .background(selColor, in: .circle)
            .glassEffect(in: .circle)
          Image(systemName: "paintpalette")
            .resizable()
            .scaledToFit()
            .frame(width: 18, height: 18)
            .padding(6)
            .glassEffect(in: .circle)
        }
        .frame(maxWidth: .infinity)
        .onTapGesture { isPickingIcon = true }
        .emojiKeyboard(
          isPresented: $isPickingIcon,
          onSelect: { goal.icon = $0 }
        )
        .padding(.bottom, 26)
        .listRowInsets(.all, 0)
        .listRowBackground(Color.clear)

        Section {
          TextField(
            "New Goal",
            text: $goal.title
          )
          .autocorrectionDisabled()
          .textInputAutocapitalization(.never)
          ColorPicker(
            "Accent Color",
            selection: $selColor
          )
          .onChange(of: selColor) { goal.color = selColor.toRGBA() }
        }

        Section {
          VStack {
            Picker("Type", selection: $goal.goalType) {
              ForEach(GoalType.allCases, id: \.self) { goalType in
                Text(goalType.rawValue.capitalized)
              }
            }
            .pickerStyle(.segmented)
            DurationPicker(
              seconds: $goal.goalS,
              maxHours: goal.goalType == .daily ? 24 : 100
            )
            .frame(maxHeight: 200)
          }
        }

        Section {
          if goal.goalType == .daily {
            WeekdayPicker(days: $goal.days)
          } else {
            Picker("Week starts on", selection: $goal.weekStart) {
              ForEach(Weekday.allCases, id: \.self) {
                Text("\($0)".capitalized)
              }
            }
          }
        } footer: {
          if goal.goalType == .daily {
            Text("Goal is applied only on the selected weekdays.")
          }
        }
      }
      .listSectionSpacing(.compact)
      .contentMargins(.top, 0, for: .scrollContent)
      .toolbar {
        ToolbarItem(placement: .topBarLeading) {
          Button(role: .close) { showView = false }
        }
        ToolbarItem(placement: .topBarTrailing) {
          Button("Done") {
            do {
              if mode == .create {
                try controller.addGoal(goal: goal)
              } else {
                try controller.context.save()
              }
            } catch {
              Logger.logical.error("Failed to save goal: \(error)")
              return
            }

            self.showView = false
          }
          .buttonStyle(.glassProminent)
          .disabled(
            goal.goalS == 0 || goal.title.isEmpty
              || (goal.goalType == .daily && goal.days.isEmpty)
          )
        }
      }
    }
  }
}

#Preview {
  let container = try! ModelContainer(
    for: Goal.self,
    configurations: ModelConfiguration(isStoredInMemoryOnly: true)
  )
  EditGoalView(show: .constant(true), mode: .create, goal: Goal())
    .modelContainer(container)
    .environment(GoalController(context: container.mainContext))
}
