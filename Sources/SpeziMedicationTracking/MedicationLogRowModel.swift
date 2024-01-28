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
final class MedicationLogRowModel<MI: MedicationInstance>: Comparable, Identifiable {
    let date: Date?
    private(set) var medications: [Binding<MI>]
    
    
    var id: Date? {
        date
    }
    
    
    init(date: Date?, medications: [Binding<MI>]) {
        self.date = date
        self.medications = medications
    }
    
    
    static func == (lhs: MedicationLogRowModel<MI>, rhs: MedicationLogRowModel<MI>) -> Bool {
        lhs.date == rhs.date
    }
    
    static func < (lhs: MedicationLogRowModel<MI>, rhs: MedicationLogRowModel<MI>) -> Bool {
        (lhs.date ?? .distantPast) < (rhs.date ?? .distantPast)
    }
    
    
    func filter(basedOn medicationInstances: Binding<[MI]>, logEntryEvent: LogEntryEvent?) -> MedicationLogRowModel {
        switch logEntryEvent {
        case let .some(logEntryEvent):
            return MedicationLogRowModel(
                date: date,
                medications: medicationInstances.filter {
                    $0.wrappedValue.logEntries.contains(where: { $0.scheduledTime == date && $0.event == logEntryEvent })
                }
            )
        case .none:
            return MedicationLogRowModel(
                date: date,
                medications: medicationInstances.filter {
                    !$0.wrappedValue.logEntries.contains(where: { $0.scheduledTime == date })
                }
            )
        }
    }
}
