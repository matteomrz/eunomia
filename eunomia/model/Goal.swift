//
//  Goal.swift
//  eunomia
//
//  Created by Matteo Merz on 14.11.26.
//

import Foundation
import SwiftData

@Model
final class Goal {
  #Unique<Goal>([\.uuid])
  var uuid: UUID = UUID()

  var title: String
  var icon: String
  var color: UInt32
  var goalS: Int
  var goalType: GoalType
  var days: Weekdays
  var weekStart: Weekday

  var sessions: [Session] = []

  init(
    title: String = "",
    icon: String = "🗒️",
    color: UInt32 = 0xffff_ffff,
    goalS: Int = 0,
    goalType: GoalType = .daily,
    days: Weekdays = .all,
    weekStart: Weekday = .monday
  ) {
    self.title = title
    self.icon = icon
    self.color = color
    self.goalS = goalS
    self.goalType = goalType
    self.days = days
    self.weekStart = weekStart
  }
}

enum GoalType: String, Codable, CaseIterable {
  case daily, weekly
}
