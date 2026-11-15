//
//  Weekday.swift
//  eunomia
//
//  Created by Matteo Merz on 14.11.26.
//

import Foundation

// ISO 8601 weekday format
enum Weekday: Int, CaseIterable, Codable {
    case monday = 1
    case tuesday, wednesday, thursday, friday, saturday, sunday
}

struct Weekdays: OptionSet, Codable {
    let rawValue: Int

    init(rawValue: Int) { self.rawValue = rawValue }
    init(_ day: Weekday) { self.init(rawValue: 1 << (day.rawValue - 1)) }
    init(_ days: some Sequence<Weekday>) {
        self = []
        for d in days { insert(Weekdays(d)) }
    }

    static let none = Weekdays([])
    static let all = Weekdays(Weekday.allCases)
    static let workdays = Weekdays(Weekday.allCases.dropLast(2))
}
