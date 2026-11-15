//
//  WeekdayPicker.swift
//  eunomia
//
//  Created by Matteo Merz on 15.11.26.
//

import SwiftUI

struct WeekdayPicker: View {
  @Binding var days: Weekdays

  var body: some View {
    HStack {
      ForEach(Weekday.allCases, id: \.self) { day in
        let isSelected = days.contains(Weekdays(day))

        Text("\(day)".first?.uppercased() ?? "")
          .fontWeight(.semibold)
          .padding(12)
          .foregroundStyle(isSelected ? Color.accentColor : .primary)
          .frame(maxWidth: .infinity)
          .background(isSelected ? Color.accentColor.opacity(0.15) : .clear, in: .circle)
          .contentShape(.circle)
          .onTapGesture {
            days.formSymmetricDifference(Weekdays(day))
          }
      }
    }
  }
}

#Preview {
  @Previewable @State var days: Weekdays = []
  WeekdayPicker(days: $days)
}
