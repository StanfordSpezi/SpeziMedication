//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import SpeziViews
import Foundation
import SpeziScheduler

// TODO: Frequencies:
//  - EveryDay, EveryFewDays (2x=every other day, 3x, 4x ...),
//  - AsNeeded,
//  - Specific Days of the Week, Cyclical Schedule(used for x days/weeks, pause for y days/weeks)

public enum MedicationScheduleSelection: String, PickerValue {
    case daily
    case weekdayBased
    case interval // TODO: every x days
    case asNeeded

    public var localizedStringResource: LocalizedStringResource {
        switch self {
        case .daily:
            .init("Every Day", bundle: .atURL(from: .module))
        case .weekdayBased:
            .init("On Specific Days of the Week", bundle: .atURL(from: .module))
        case .interval:
            .init("Every Few Days", bundle: .atURL(from: .module))
        case .asNeeded:
            .init("As Needed", bundle: .atURL(from: .module))
        }
    }

    public var explanation: LocalizedStringResource? {
        switch self {
        case .daily:
            nil
        case .weekdayBased:
            .init("On Mondays, On Weekdays", bundle: .atURL(from: .module))
        case .interval:
            .init("Every other day, Every 3 days", bundle: .atURL(from: .module))
        case .asNeeded:
            nil
        }
    }
}

extension Locale.Weekday { // TODO: combine and move to Scheduler!
    public init?(ordinal: Int) {
        switch ordinal {
        case 1:
            self = .sunday
        case 2:
            self = .monday
        case 3:
            self = .tuesday
        case 4:
            self = .wednesday
        case 5:
            self = .thursday
        case 6:
            self = .friday
        case 7:
            self = .saturday
        default:
            return nil
        }
    }

    public var portedOrdinal: Int { // TODO: package public in scheduler!
        switch self {
        case .sunday:
            1
        case .monday:
            2
        case .tuesday:
            3
        case .wednesday:
            4
        case .thursday:
            5
        case .friday:
            6
        case .saturday:
            7
        @unknown default:
            preconditionFailure("A new weekday appeared we don't know about: \(self)")
        }
    }

    public init(from date: Date) {
        let weekdayOrdinal = Calendar.current.component(.weekday, from: date)
        guard let weekday = Locale.Weekday(ordinal: weekdayOrdinal) else {
            preconditionFailure("Failed to derive weekday from ordinal \(weekdayOrdinal)")
        }
        self = weekday
    }
}


extension Locale.Weekday: CaseIterable {
    // TODO: locale, based order?
    public static let allCases: [Locale.Weekday] = [.monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday]
}


public struct CreateScheduleViewModel {
    // TODO: rename
    public var selection: MedicationScheduleSelection
    /// The day interval.
    ///
    /// This value only applies if ``selection`` has a value of ``MedicationScheduleSelection/interval``.
    public var dayInterval: Int
    public var times: [Date] = []

    public var weekdays: Set<Locale.Weekday> = []

    public var start: Date
    public var end: Date?

    public var schedule: SpeziScheduler.Schedule? {
        if case .asNeeded = selection {
            return nil // no recurrence or scheduled tasks at all
        }

        let end = end.map {
            Calendar.RecurrenceRule.End.afterDate($0)
        } ?? .never



        let (hours, minutes) = times.reduce(into: ([Int](), [Int]())) { partialResult, date in
            partialResult.0.append(Calendar.current.component(.hour, from: date))
            partialResult.1.append(Calendar.current.component(.minute, from: date))
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


        // TODO: days and minutes doesn't work right?
        let recurrence = Calendar.RecurrenceRule.daily(
            calendar: .current,
            interval: interval,
            end: end,
            weekdays: weekdays,
            hours: hours,
            minutes: minutes
        )

        // TODO: do we care about event duration?
        return SpeziScheduler.Schedule(startingAt: start, recurrence: recurrence)
    }

    public init(
        selection: MedicationScheduleSelection = .daily,
        dayInterval: Int = 2,
        start: Date = .today, // TODO: start of day?
        end: Date? = nil
    ) {
        let now = Date.now
        let todayWeekday = Locale.Weekday(from: now)

        self.selection = selection
        self.dayInterval = dayInterval
        self.times = [now] // default selected time is now
        self.weekdays = [todayWeekday] // default selected weekday is today
        self.start = start
        self.end = end
    }
}


/// Defines the frequency of a schedule.
public enum Frequency: Codable, CustomStringConvertible, Equatable, Hashable, Sendable {
    case regularDayIntervals(Int)
    case specificDaysOfWeek(Weekdays)
    case asNeeded
    
    
    enum CodingKeys: CodingKey {
        case regularDayIntervals
        case specificDaysOfWeek
        case asNeeded
    }
    
    
    public var description: String {
        switch self {
        case let .regularDayIntervals(dayInterval):
            switch dayInterval {
            case 1:
                String(localized: "Every Day", bundle: .module)
            case 2:
                String(localized: "Every other Day", bundle: .module)
            default:
                String(localized: "Every \(dayInterval) days", bundle: .module)
            }
        case let .specificDaysOfWeek(weekdays):
            weekdays.localizedShortDescription
        case .asNeeded:
            String(localized: "As Needed", bundle: .module)
        }
    }
    
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        var allKeys = ArraySlice(container.allKeys)
        
        guard let onlyKey = allKeys.popFirst(), allKeys.isEmpty else {
            throw DecodingError.typeMismatch(
                Frequency.self,
                DecodingError.Context.init(
                    codingPath: container.codingPath,
                    debugDescription: "Invalid number of keys found, expected one.",
                    underlyingError: nil
                )
            )
        }
        
        switch onlyKey {
        case .regularDayIntervals:
            self = Frequency.regularDayIntervals(try container.decode(Int.self, forKey: CodingKeys.regularDayIntervals))
        case .specificDaysOfWeek:
            self = Frequency.specificDaysOfWeek(try container.decode(Weekdays.self, forKey: CodingKeys.specificDaysOfWeek))
        case .asNeeded:
            self = Frequency.asNeeded
        }
    }
    
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        switch self {
        case let .regularDayIntervals(dayInterval):
            try container.encode(dayInterval, forKey: .regularDayIntervals)
        case let .specificDaysOfWeek(weekdays):
            try container.encode(weekdays, forKey: .specificDaysOfWeek)
        case .asNeeded:
            try container.encode(true, forKey: .asNeeded)
        }
    }
}
