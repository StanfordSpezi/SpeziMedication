//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import Foundation
import SwiftUI


public struct ScheduledTime { // TODO: move to UI? also rename? "ScheduledDosage"
    /// A stable identifier for this entry.
    public let id: UUID
    /// The time this dosage is scheduled for.
    public var time: DateComponents
    /// The dosage amount.
    public var dosage: Double


    /// Converted to a date representation for today.
    public var date: Date {
        get {
            Calendar.current.date(bySettingHour: self.time.hour ?? 0, minute: self.time.minute ?? 0, second: 0, of: .now) ?? .now
        }
        set {
            self.time = Calendar.current.dateComponents([.hour, .minute], from: newValue)
        }
    }


    public init(time: DateComponents, dosage: Double = 1.0) {
        precondition(time.hour != nil && time.minute != nil)
        
        self.id = UUID()
        self.time = time
        self.dosage = dosage
    }
    
    public init(date: Date, dosage: Double = 1.0) {
        self.init(time: Calendar.current.dateComponents([.hour, .minute], from: date), dosage: dosage)
    }
}


extension ScheduledTime: Identifiable, Sendable {}


extension ScheduledTime: Codable {
    private enum CodingKeys: CodingKey {
        case time
        case dosage
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = UUID()
        self.time = try container.decode(DateComponents.self, forKey: .time)
        self.dosage = try container.decode(Double.self, forKey: .dosage)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.time, forKey: .time)
        try container.encode(self.dosage, forKey: .dosage)
    }
}


extension ScheduledTime: Equatable {
    public static func == (lhs: ScheduledTime, rhs: ScheduledTime) -> Bool {
        lhs.time.hour == rhs.time.hour && lhs.time.minute == rhs.time.minute && lhs.dosage == rhs.dosage
    }
}


extension ScheduledTime: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}


extension ScheduledTime: Comparable {
    public static func < (lhs: ScheduledTime, rhs: ScheduledTime) -> Bool {
        if lhs.time.hour == rhs.time.hour {
            return lhs.time.minute ?? 0 < rhs.time.minute ?? 0
        }

        return lhs.time.hour ?? 0 < rhs.time.hour ?? 0
    }
}

