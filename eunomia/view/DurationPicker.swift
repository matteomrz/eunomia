//
//  DurationPicker.swift
//  eunomia
//
//  Created by Matteo Merz on 15.11.26.
//

import SwiftUI

struct DurationPicker: View {
    @Binding var seconds: Int
    let maxHours: Int

    private var hours: Binding<Int> {
        .init(
            get: { seconds / 3600 },
            set: { seconds = $0 * 3600 + seconds % 3600 }
        )
    }

    private var minutes: Binding<Int> {
        .init(
            get: { seconds % 3600 / 60 },
            set: { seconds = seconds - seconds % 3600 + $0 * 60 }
        )

    }

    var body: some View {
        HStack(spacing: 0) {
            Picker("Hours", selection: hours) {
                ForEach(0..<maxHours, id: \.self) { Text("\($0) h") }
            }
            Picker("Minutes", selection: minutes) {
                ForEach(0..<60, id: \.self) { Text("\($0) min") }
            }
        }
        .pickerStyle(.wheel)
        .labelsHidden()
    }
}

#Preview {
    @Previewable @State var sec: Int = 0

    DurationPicker(seconds: $sec, maxHours: 5)
}
