//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import Foundation


public struct LogEntry: Codable, Equatable {
    public let scheduledTime: Date?
    public var event: LogEntryEvent
    public var date: Date
    public var dosage: Double
    
    
    public init(
        scheduledTime: Date?,
        event: LogEntryEvent,
        date: Date,
        dosage: Double
    ) {
        self.scheduledTime = scheduledTime
        self.event = event
        self.date = date
        self.dosage = dosage
    }
}
