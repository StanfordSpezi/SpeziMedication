//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import Foundation
import SpeziScheduler
import SpeziViews


/// A view model to create a new `Schedule`.
///
/// You can use this view model when creating a new ``Schedule``.
public struct CreateScheduleViewModel {
    /// The current frequency selection.
    public var selection: ScheduleFrequencySelection
    /// The day interval.
    ///
    /// This value only applies if ``selection`` is equal to ``MedicationScheduleSelection/interval``.
    public var dayInterval: Int
    /// The selected weekdays.
    ///
    /// This value only applies if ``selection`` is equal to ``ScheduleFrequencySelection/weekdayBased``.
    public var weekdays: Set<Locale.Weekday> = []
    /// The timestamps that are selected.
    public var times: [ScheduledTime] = []

    /// The start date of the schedule.
    public var start: Date
    /// The optional end of the schedule.
    public var end: Date?

    /// Create a schedule from the current settings.
    ///
    /// Returns `nil` if the current properties do not describe a recurring schedule (e.g., ``selection`` equals to ``ScheduleFrequencySelection/asNeeded``.
    ///
    /// - Note: The `Schedule/duration` is not set by this property and receives the default value. You can modify this property afterwards as well if you need to modify it.
    public var schedule: SpeziScheduler.Schedule? {
        if case .asNeeded = selection {
            return nil // no recurrence or scheduled tasks at all
        }

        let end = end.map {
            Calendar.RecurrenceRule.End.afterDate($0)
        } ?? .never


        let (hours, minutes) = times.reduce(into: ([Int](), [Int]())) { partialResult, scheduledTime in
            partialResult.0.append(Calendar.current.component(.hour, from: scheduledTime.date))
            partialResult.1.append(Calendar.current.component(.minute, from: scheduledTime.date))
        }

        let interval = if case .interval = selection {
            dayInterval
        } else {
            1
        }

        let weekdays: [Calendar.RecurrenceRule.Weekday] = if case .weekdayBased = selection {
            self.weekdays.map { .every($0) }
        } else {
            []
        }


        // TODO: unit tests the setPositions!
        let recurrence = Calendar.RecurrenceRule.daily(
            calendar: .current,
            interval: interval,
            end: end,
            weekdays: weekdays,
            hours: hours, // e.g., 13, 15, 16
            minutes: minutes, // e.g., 30, 40, 50
            // Without set positions we get 13:30, 13:40, 13:50, 15:30, 15:40, 15:50, 16:30, 16:40 and 16:50 (all permutations)
            // We would specify setPositions [1, 5, 9] to take the first, fifth and 9th element of all occurrences: 13:30, 15:40, 16:50.
            setPositions: (0..<times.count).map {
                ($0 * times.count) + $0 + 1
            }
        )

        return SpeziScheduler.Schedule(startingAt: start, recurrence: recurrence)
    }
    
    /// Create a new view model to create a schedule.
    /// - Parameters:
    ///   - selection: The initial frequency selection.
    ///   - dayInterval: The default interval for ``ScheduleFrequencySelection/interval`` selection.
    ///   - start: The start of the schedule.
    ///   - end: The optional end of the schedule.
    public init(
        selection: ScheduleFrequencySelection = .daily,
        dayInterval: Int = 2,
        start: Date = .today,
        end: Date? = nil
    ) {
        let now = Date.now
        let todayWeekday = Locale.Weekday(from: now)

        self.selection = selection
        self.dayInterval = dayInterval
        self.times = [ScheduledTime(date: now, dosage: 1)] // default selected time is now
        self.weekdays = [todayWeekday] // default selected weekday is today
        self.start = start
        self.end = end
    }
}
