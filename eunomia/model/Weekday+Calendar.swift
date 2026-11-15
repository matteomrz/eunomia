//
//  Weekday+Calendar.swift
//  eunomia
//
//  Created by Matteo Merz on 14.11.26.
//

import Foundation

// Calendar expects weekdays to start on Sunday (= 1)
extension Weekday {
    var calendarWeekday: Int { rawValue % 7 + 1 }

    init(calendarWeekday: Int) {
        self.init(rawValue: (calendarWeekday + 5) % 7 + 1)!
    }
}
