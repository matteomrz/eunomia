//
//  EunomiaApp.swift
//  eunomia
//
//  Created by Matteo Merz on 14.11.26.
//

import SwiftData
import SwiftUI

@main
struct EunomiaApp: App {
    let container: ModelContainer
    @State private var goalController: GoalController

    init() {
         let schema = Schema([
            Goal.self, Session.self,
        ])
        let modelConfiguration = ModelConfiguration(
            schema: schema,
            isStoredInMemoryOnly: false
        )

        do {
            container = try ModelContainer(
                for: schema,
                configurations: [modelConfiguration]
            )
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }

        _goalController = State(
            initialValue: GoalController(context: container.mainContext)
        )
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(container)
        .environment(goalController)
    }
}
