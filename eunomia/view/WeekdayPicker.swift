//
//  WeekdayPicker.swift
//  eunomia
//
//  Created by Matteo Merz on 15.11.26.
//

import SwiftUI

struct WeekdayPicker: View {
  @Binding var days: Weekdays
  private let weekdays: [Weekdays] = Weekday.allCases.map { Weekdays($0) }

  var body: some View {
    HStack {
      ForEach(Weekday.allCases, id: \.self) { day in
        let isSelected = days.contains(weekdays[day.rawValue - 1])

        Text("\(day)".first?.uppercased() ?? "")
          .fontWeight(.semibold)
          .padding(12)
          .foregroundStyle(isSelected ? Color.accentColor : .primary)
          .frame(maxWidth: .infinity)
          .background(
            isSelected ? Color.accentColor.opacity(0.15) : Color.clear,
            in: .rect(cornerRadius: 10, style: .continuous)
          )
          .clipShape(.circle)
          .onTapGesture {
            days.formSymmetricDifference(weekdays[day.rawValue - 1])
          }
      }
    }
  }
}

#Preview {
  @Previewable @State var days: Weekdays = []
  WeekdayPicker(days: $days)
}
