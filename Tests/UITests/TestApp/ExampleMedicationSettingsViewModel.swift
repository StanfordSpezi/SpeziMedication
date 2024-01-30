//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import Spezi
import SpeziMedication
import SpeziMedicationSettings
import SwiftUI
import XCTSpeziMedication


@Observable
class ExampleMedicationSettingsViewModel: Module, MedicationSettingsViewModel, CustomStringConvertible {
    var medicationInstances: Set<MockMedicationInstance> = []
    let medicationOptions: Set<MockMedication>
    
    
    var description: String {
        guard !medicationInstances.isEmpty else {
            return "No Medications"
        }
        
        return medicationInstances
            .map { medicationInstance in
                let scheduleDescription: String
                switch medicationInstance.schedule.frequency {
                case let .regularDayIntervals(dayInterval):
                    scheduleDescription = "RegularDayIntervals: \(dayInterval)"
                case let .specificDaysOfWeek(weekdays):
                    scheduleDescription = "SpecificDaysOfWeek: \(weekdays)"
                case .asNeeded:
                    scheduleDescription = "AsNeeded"
                }
                
                return "\(medicationInstance.type.localizedDescription) - \(medicationInstance.dosage.localizedDescription) - \(scheduleDescription)"
            }
            .joined(separator: ", ")
    }
    
    
    init() {
        self.medicationOptions = Set(Mock.medications)
    }
    
    
    func persist(medicationInstances: Set<MockMedicationInstance>) async throws {
        try await Task.sleep(for: .seconds(2))
        self.medicationInstances = medicationInstances
    }
}
