//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import Foundation


public enum Schedule: Codable, CustomStringConvertible, Equatable, Hashable {
    case regularDayIntervals(Int)
    case specificDaysOfWeek(Weekdays)
    case asNeeded
    
    
    public var description: String {
        switch self {
        case let .regularDayIntervals(dayInterval):
            String(localized: "Every \(dayInterval)", bundle: .module)
        case let .specificDaysOfWeek(weekdays):
            weekdays.localizedShortDescription
        case .asNeeded:
            String(localized: "As Needed", bundle: .module)
        }
    }
}
