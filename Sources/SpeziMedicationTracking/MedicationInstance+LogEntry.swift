//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import Foundation
import SpeziMedication


extension MedicationInstance {
    func logEntry(date: Date, asNeeded: Bool = false) -> LogEntry? {
        logEntries.first {
            if asNeeded {
                $0.scheduledTime == nil && $0.date == date
            } else {
                $0.scheduledTime == date
            }
        } ?? logEntries.first(where: { $0.date == date })
    }
}
