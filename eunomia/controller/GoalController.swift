//
//  GoalController.swift
//  eunomia
//
//  Created by Matteo Merz on 14.11.26.
//

import Foundation
import SwiftData

@MainActor @Observable
final class GoalController {
  var context: ModelContext

  init(context: ModelContext) {
    self.context = context
  }

  func addGoal(goal: Goal) throws {
    context.insert(goal)
    try context.save()
  }
}
