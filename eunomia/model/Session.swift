//
//  Session.swift
//  eunomia
//
//  Created by Matteo Merz on 14.11.26.
//

import Foundation
import SwiftData

@Model
final class Session {
    #Unique<Session>([\.uuid])
    var uuid: UUID = UUID()

    @Relationship(inverse: \Goal.sessions) var goal: Goal
    var start: Date
    var end: Date?

    init(goal: Goal, start: Date, end: Date? = nil) {
        self.goal = goal
        self.start = start
        self.end = end
    }
}
