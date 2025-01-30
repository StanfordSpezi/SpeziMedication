//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import Foundation
import SpeziMedication


@available(*, deprecated, message: "Unavailable")
public struct MockMedicationInstance: LegacyMedicationInstance, LegacyMedicationInstanceInitializable, Sendable {
    public let id: UUID
    public let type: MockMedication
    public var dosage: MockDosage
    public var schedule: Schedule
    public var logEntries: [LogEntry]
    
    
    public init(type: MockMedication, dosage: MockDosage, schedule: SpeziMedication.Schedule) {
        self.init(type: type, dosage: dosage, schedule: schedule, logEntries: [])
    }
    
    public init(type: MockMedication, dosage: MockDosage, schedule: Schedule, logEntries: [LogEntry]) {
        self.id = UUID()
        self.type = type
        self.dosage = dosage
        self.schedule = schedule
        self.logEntries = logEntries
    }
}
