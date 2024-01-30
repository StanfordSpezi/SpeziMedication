//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import Foundation
import SpeziMedication


public enum Mock {
    public static let medications: [MockMedication] = [
        MockMedication(
            localizedDescription: "Medication 1",
            dosages: [
                MockDosage(localizedDescription: "Dosage 1.1"),
                MockDosage(localizedDescription: "Dosage 1.2"),
                MockDosage(localizedDescription: "Dosage 1.3")
            ]
        ),
        MockMedication(
            localizedDescription: "Medication 2",
            dosages: [
                MockDosage(localizedDescription: "Dosage 2.1")
            ]
        ),
        MockMedication(
            localizedDescription: "Medication 3",
            dosages: [
                MockDosage(localizedDescription: "Dosage 3.1"),
                MockDosage(localizedDescription: "Dosage 3.2")
            ]
        )
    ]
    
    public static let medicationInstances: [MockMedicationInstance] = [
        MockMedicationInstance(
            type: medications.sorted()[0],
            dosage: medications.sorted()[0].dosages[0],
            schedule: Schedule(
                frequency: .specificDaysOfWeek(.all),
                times: [
                    ScheduledTime(time: DateComponents(hour: 8, minute: 0), dosage: 1.0),
                    ScheduledTime(time: DateComponents(hour: 12, minute: 0), dosage: 1.0),
                    ScheduledTime(time: DateComponents(hour: 15, minute: 0), dosage: 2.0),
                    ScheduledTime(time: DateComponents(hour: 18, minute: 0), dosage: 1.0),
                    ScheduledTime(time: DateComponents(hour: 20, minute: 0), dosage: 1.0),
                    ScheduledTime(time: DateComponents(hour: 22, minute: 0), dosage: 1.0)
                ],
                startDate: .now
            ),
            logEntries: [
                LogEntry( // Associated with scheduled time; taken at the scheduled time + 2 minutes.
                    scheduledTime: Calendar.current.date(bySettingHour: 8, minute: 0, second: 0, of: .now) ?? .now,
                    event: .taken,
                    date: Calendar.current.date(bySettingHour: 8, minute: 0, second: 0, of: .now)?.addingTimeInterval(120) ?? .now,
                    dosage: 1.0
                ),
                LogEntry( // As needed entry
                    scheduledTime: nil,
                    event: .taken,
                    date: Calendar.current.date(bySettingHour: 10, minute: 0, second: 0, of: .now) ?? .now,
                    dosage: 1.0
                ),
                LogEntry( // Skipped; skipped entry right on the scheduled time.
                    scheduledTime: Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: .now) ?? .now,
                    event: .skipped,
                    date: Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: .now) ?? .now,
                    dosage: 1.0
                ),
                LogEntry( // Other as needed entry
                    scheduledTime: nil,
                    event: .taken,
                    date: Calendar.current.date(bySettingHour: 14, minute: 0, second: 0, of: .now) ?? .now,
                    dosage: 1.0
                ),
                LogEntry( // Associated with scheduled time; taken right on time the scheduled time + 2 minutes, but not right dosage
                    scheduledTime: Calendar.current.date(bySettingHour: 15, minute: 0, second: 0, of: .now) ?? .now,
                    event: .taken,
                    date: Calendar.current.date(bySettingHour: 15, minute: 0, second: 0, of: .now) ?? .now,
                    dosage: 1.0
                ),
                LogEntry( // Associated with scheduled time; finally taken correctly ...
                    scheduledTime: Calendar.current.date(bySettingHour: 18, minute: 0, second: 0, of: .now) ?? .now,
                    event: .taken,
                    date: Calendar.current.date(bySettingHour: 18, minute: 0, second: 0, of: .now) ?? .now,
                    dosage: 1.0
                )
                // 20:00 medication not taken yet ...
                // 22:00 medication not taken yet ...
            ]
        ),
        MockMedicationInstance(
            type: medications.sorted()[1],
            dosage: medications.sorted()[1].dosages[0],
            schedule: Schedule(
                frequency: .regularDayIntervals(2),
                times: [
                    ScheduledTime(time: DateComponents(hour: 6, minute: 0), dosage: 1.0),
                    ScheduledTime(time: DateComponents(hour: 8, minute: 0), dosage: 2.0),
                    ScheduledTime(time: DateComponents(hour: 12, minute: 42), dosage: 4.0),
                    ScheduledTime(time: DateComponents(hour: 18, minute: 30), dosage: 1.0),
                    ScheduledTime(time: DateComponents(hour: 20, minute: 0), dosage: 2.0),
                    ScheduledTime(time: DateComponents(hour: 23, minute: 59), dosage: 1.0)
                ],
                startDate: .now
            ),
            logEntries: [
                LogEntry( // Skipped; skipped entry right on the scheduled time.
                    scheduledTime: Calendar.current.date(bySettingHour: 6, minute: 0, second: 0, of: .now) ?? .now,
                    event: .skipped,
                    date: Calendar.current.date(bySettingHour: 6, minute: 0, second: 0, of: .now) ?? .now,
                    dosage: 1.0
                ),
                LogEntry( // Associated with scheduled time; taken at the scheduled time.
                    scheduledTime: Calendar.current.date(bySettingHour: 8, minute: 0, second: 0, of: .now) ?? .now,
                    event: .taken,
                    date: Calendar.current.date(bySettingHour: 8, minute: 0, second: 0, of: .now) ?? .now,
                    dosage: 2.0
                ),
                LogEntry( // As needed entry
                    scheduledTime: nil,
                    event: .taken,
                    date: Calendar.current.date(bySettingHour: 10, minute: 0, second: 0, of: .now) ?? .now,
                    dosage: 1.0
                ),
                LogEntry( // Taken before the time ...
                    scheduledTime: Calendar.current.date(bySettingHour: 12, minute: 42, second: 0, of: .now) ?? .now,
                    event: .taken,
                    date: Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: .now) ?? .now,
                    dosage: 4.0
                ),
                LogEntry( // Other as needed entry
                    scheduledTime: nil,
                    event: .taken,
                    date: Calendar.current.date(bySettingHour: 14, minute: 0, second: 0, of: .now) ?? .now,
                    dosage: 1.0
                )
                // 18:30 medication not taken yet ..
                // 20:00 medication not taken yet ...
                // 23:59 medication not taken yet ...
            ]
        )
    ]
}
