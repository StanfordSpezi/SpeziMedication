//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import SwiftUI


/// Weekday picker.
///
/// A picker to pick a set of weekdays (e.g., to define the recurrence of a schedule).
///
/// ```swift
/// @State var weekdays: Set<Locale.Weekday> = []
///
/// var body: some View {
///     List {
///         WeekdaysPicker(selection: $weekdays)
///     }
/// }
/// ```
public struct WeekdaysPicker: View { // TODO: could also be SpeziViews?
    @Binding private var weekdays: Set<Locale.Weekday>

    public var body: some View {
        HStack(spacing: 5) {
            ForEach(Locale.Weekday.allCases, id: \.self) { weekday in
                WeekdayButton(weekday: weekday, selected: weekdays.contains(weekday)) {
                    if weekdays.contains(weekday) {
                        weekdays.remove(weekday)
                    } else {
                        weekdays.insert(weekday)
                    }
                }

                if Locale.Weekday.allCases.last != weekday {
                    Spacer()
                }
            }
        }
            .frame(maxWidth: .infinity)
    }

    
    /// Create a new weekday picker.
    /// - Parameter weekdays: The weekday selection.
    public init(selection weekdays: Binding<Set<Locale.Weekday>>) {
        self._weekdays = weekdays
    }
}


#if DEBUG
#Preview {
    @Previewable @State var weekdays: Set<Locale.Weekday> = [.monday, .tuesday]

    List {
        Section("Weekdays") {
            WeekdaysPicker(selection: $weekdays)
        }
    }
}
#endif
