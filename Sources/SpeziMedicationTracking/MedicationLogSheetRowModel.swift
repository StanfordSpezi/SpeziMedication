//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import Foundation
import SpeziMedication
import SwiftUI


@Observable
class MedicationLogSheetRowModel<MI: MedicationInstance>: Identifiable {
    let date: Date?
    let medication: Binding<MI>
    var logEntry: LogEntry?
    
    
    var id: Date? {
        date
    }
    
    
    init(date: Date?, medication: Binding<MI>) {
        self.date = date
        self.medication = medication
        if let date {
            self.logEntry = medication.wrappedValue.logEntries.first(where: { $0.date == date })
        }
    }
}
