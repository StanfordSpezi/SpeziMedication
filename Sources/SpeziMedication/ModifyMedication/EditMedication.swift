//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import SpeziViews
import SwiftUI


struct EditMedication<MI: MedicationInstance>: View {
    @Environment(\.dismiss) private var dismiss
    
    @Binding private var medicationInstances: Set<MI>
    @State private var dosage: MI.InstanceDosage
    
    private let medicationInstance: MI
    private let medicationOptions: Set<MI.InstanceType>
    
    
    var body: some View {
        VStack {
            Form {
                Section {
                    Picker(String(localized: "EDIT_DOSAGE_DESCRIPTION \(medicationInstance.localizedDescription)", bundle: .module), selection: $dosage) {
                        ForEach(medicationInstance.type.dosages, id: \.self) { dosage in
                            Text(dosage.localizedDescription)
                                .tag(dosage)
                        }
                    }
                        .pickerStyle(.inline)
                        .accessibilityIdentifier(String(localized: "EDIT_DOSAGE_PICKER", bundle: .module))
                }
                Section {
                    Button(String(localized: "DELETE_MEDICATION", bundle: .module), role: .destructive) {
                        medicationInstances.remove(medicationInstance)
                        dismiss()
                    }
                }
            }
        }
            .navigationTitle(medicationInstance.localizedDescription)
            .onChange(of: dosage) {
                guard medicationInstance.dosage != dosage else {
                    return
                }
                
                medicationInstances.remove(medicationInstance)
                
                var modifiedMedication = medicationInstance
                modifiedMedication.dosage = dosage
                
                medicationInstances.insert(modifiedMedication)
            }
    }
    
    
    init(medicationInstance medicationInstanceId: MI.ID, medicationInstances: Binding<Set<MI>>, medicationOptions: Set<MI.InstanceType>) {
        guard let medicationInstance = medicationInstances.wrappedValue.first(where: { $0.id == medicationInstanceId }) else {
            fatalError("Could not find medication instance in defined set of medication instances.")
        }
        
        self.medicationInstance = medicationInstance
        self._medicationInstances = medicationInstances
        self.medicationOptions = medicationOptions
        
        self._dosage = State(wrappedValue: medicationInstance.dosage)
    }
}
