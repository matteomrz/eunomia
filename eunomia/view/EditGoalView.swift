//
//  EditGoalView.swift
//  eunomia
//
//  Created by Matteo Merz on 14.11.26.
//

import SwiftData
import SwiftUI

enum EditGoalMode {
  case create, edit
}

struct EditGoalView: View {
  private let mode: EditGoalMode
  @State private var goal: Goal
  @Environment(GoalController.self) private var controller: GoalController

  @State private var selColor: Color
  @State private var isPickingIcon = false

  init(mode: EditGoalMode, goal: Goal) {
    self.mode = mode
    self.goal = goal
    self.selColor = Color(rgba: goal.color)
  }

  var body: some View {
    Form {
      HStack {
        Spacer()
        ZStack(alignment: .bottomTrailing) {
          Text(goal.icon)
            .font(.system(size: 48))
            .aspectRatio(1, contentMode: .fit)
            .padding(16)
            .background(selColor)
            .clipShape(.circle)
            .glassEffect(in: .circle)
            .padding(10)
          Image(systemName: "paintpalette")
            .resizable()
            .aspectRatio(1, contentMode: .fit)
            .frame(width: 12, height: 12)
            .padding(6)
            .background(Color.clear)
            .clipShape(.circle)
            .glassEffect(in: .circle)
            .padding(10)
        }
        Spacer()
      }
      .onTapGesture { isPickingIcon = true }
      .emojiKeyboard(
        isPresented: $isPickingIcon,
        onSelect: { goal.icon = $0 }
      )
      .padding(10)
      .listRowInsets(.none)
      .listRowBackground(Color.clear)

      Section {
        TextField(
          "New Goal",
          text: $goal.title
        )
        .disableAutocorrection(true)
        .textInputAutocapitalization(.never)
        ColorPicker(
          "Accent Color",
          selection: $selColor
        )
        .onSubmit { goal.color = selColor.toRGBA() }
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
          .pickerStyle(.menu)
        }
      }
    }
    .listSectionSpacing(.compact)
  }
}

#Preview {
  let container = try! ModelContainer(
    for: Goal.self,
    configurations: ModelConfiguration(isStoredInMemoryOnly: true)
  )
  EditGoalView(mode: .create, goal: Goal())
    .modelContainer(container)
    .environment(GoalController(context: container.mainContext))
}
