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


/// The schedule frequency selected in UI.
///  
/// This enum can be used to present the schedule frequency in UI when creating a new schedule.
public enum ScheduleFrequencySelection: String, PickerValue {
    /// A daily schedule.
    case daily
    /// A schedule with weekday-based recurrence.
    case weekdayBased
    /// A schedule that is repeated every x days.
    case interval
    /// A schedule that is fully manual.
    case asNeeded
    
    /// The localized label of the selection.
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
    
    /// An optional localized explanation for certain selection types.
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
