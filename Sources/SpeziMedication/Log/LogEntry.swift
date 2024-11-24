//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import Foundation

// TODO: where do we store everything?
//  => should we maintain a custom storage databse, or do we store it alongisde the Task and Outcome?


public struct LogEntry: Codable, Equatable, Sendable {
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
