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
public struct WeekdaysPicker: View {
    private let disabledWeekdays: Set<Locale.Weekday>
    private let allowEmptySelection: Bool

    @Binding private var weekdays: Set<Locale.Weekday>

    public var body: some View {
        HStack(spacing: 5) {
            ForEach(Locale.Weekday.allCases, id: \.self) { weekday in
                WeekdayButton(weekday: weekday, selected: weekdays.contains(weekday)) {
                    if weekdays.contains(weekday) {
                        if weekdays.count > 1 || allowEmptySelection {
                            weekdays.remove(weekday)
                        }
                    } else {
                        weekdays.insert(weekday)
                    }
                }
                    .disabled(disabledWeekdays.contains(weekday))

                if Locale.Weekday.allCases.last != weekday {
                    Spacer()
                }
            }
        }
            .frame(maxWidth: .infinity)
            .onChange(of: disabledWeekdays, initial: true) {
                weekdays.subtract(disabledWeekdays)
            }
    }

    
    /// Create a new weekday picker.
    /// - Parameter weekdays: The weekday selection.
    /// - Parameter disabledWeekdays: The set of weekdays for which selection should be disabled.
    /// - Parameter allowEmptySelection: If `true` user will be able to de-select the last weekday.
    public init(
        selection weekdays: Binding<Set<Locale.Weekday>>,
        disabled disabledWeekdays: Set<Locale.Weekday> = [],
        allowEmptySelection: Bool = false
    ) {
        self._weekdays = weekdays
        self.disabledWeekdays = disabledWeekdays
        self.allowEmptySelection = allowEmptySelection
    }
}


#if DEBUG
#Preview {
    @Previewable @State var weekdays: Set<Locale.Weekday> = [.monday, .tuesday, .friday]

    List {
        Section("Weekdays") {
            WeekdaysPicker(selection: $weekdays, disabled: [.friday, .saturday])
        }
    }
}
#endif
