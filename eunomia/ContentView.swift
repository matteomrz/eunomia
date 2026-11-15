//
//  ContentView.swift
//  eunomia
//
//  Created by Matteo Merz on 14.11.26.
//

import OSLog
import SwiftData
import SwiftUI

struct ContentView: View {
  @Environment(\.modelContext) private var modelContext
  @Environment(GoalController.self) private var controller: GoalController
  @Query private var goals: [Goal]
  @State private var isCreatingGoal = false

  private let logger = Logger()

  var body: some View {
    NavigationSplitView {
      List {
        ForEach(goals) { goal in
          NavigationLink {
            Text("Item at \(goal.title)")
          } label: {
            HStack {
              Text(goal.icon)
              Text(goal.title)
              Spacer()
              Circle()
                .fill(Color(rgba: goal.color))
                .frame(width: 12, height: 12)
            }
          }
        }
        .onDelete(perform: deleteItems)
      }
      .toolbar {
        ToolbarItem(placement: .navigationBarTrailing) {
          EditButton()
        }
        ToolbarItem {
          Button {
            isCreatingGoal = true
          } label: {
            Label("New Goal", systemImage: "plus")
          }
        }
      }
      .sheet(isPresented: $isCreatingGoal) {
        EditGoalView(mode: .create, goal: Goal())
      }
    } detail: {
      Text("Select an item")
    }
  }

  private func deleteItems(offsets: IndexSet) {
    withAnimation {
      Logger.visual.error("Not implemented")
    }
  }
}

#Preview {
  let container = try! ModelContainer(
    for: Goal.self,
    configurations: ModelConfiguration(isStoredInMemoryOnly: true)
  )
  ContentView()
    .modelContainer(container)
    .environment(GoalController(context: container.mainContext))
}
