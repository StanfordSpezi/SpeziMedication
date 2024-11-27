//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import SpeziMedication
import SwiftUI


public struct WeekdayPicker: View { // TODO: could also be SpeziViews?
    @Binding private var weekdays: Set<Locale.Weekday>

    public var body: some View {
        HStack(spacing: 5) {
            ForEach(Locale.Weekday.allCases, id: \.self) { weekday in
                let selected = weekdays.contains(weekday)

                Button {
                    if weekdays.contains(weekday) {
                        weekdays.remove(weekday)
                    } else {
                        weekdays.insert(weekday)
                    }
                } label: {
                    Text(Calendar.current.veryShortWeekdaySymbols[weekday.portedOrdinal - 1])
                        .foregroundStyle(selected ? .white : .primary)
                        .fontWeight(.semibold)
                        .background {
                            Group {
                                if selected {
                                    Circle()
                                        .fill(.tint) // allows to customize via the native .tint modifier
                                } else {
                                    Circle()
                                        .foregroundStyle(.clear)
                                }
                            }
                                .frame(width: 30, height: 30)
                        }
                }
                    .buttonStyle(.borderless)
                    .dynamicTypeSize(.large) // do not allow dynamic type size for this view

                if Locale.Weekday.allCases.last != weekday {
                    Spacer()
                }
            }
        }
            .frame(maxWidth: .infinity)
    }


    init(selection weekdays: Binding<Set<Locale.Weekday>>) {
        self._weekdays = weekdays
    }
}


#if DEBUG
#Preview {
    @Previewable @State var weekdays: Set<Locale.Weekday> = [.monday, .tuesday]

    List {
        Section("Weekdays") {
            WeekdayPicker(selection: $weekdays)
        }
    }
}
#endif
