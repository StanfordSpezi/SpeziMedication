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
    
    private let medicationInstanceId: MI.ID
    private let medicationOptions: Set<MI.InstanceType>
    
    
    private var medicationInstance: MI? {
        medicationInstances.first(where: { $0.id == medicationInstanceId })
    }
    
    private var medicationOption: MI.InstanceType? {
        guard let medicationInstance else {
            return nil
        }
        
        return medicationOptions.first(where: { $0 == medicationInstance.type })
    }
    
    
    var body: some View {
        if let medicationInstance {
            VStack {
                Form {
                    Section {
                        if let medicationOption {
                            Picker(String(localized: "EDIT_DOSAGE_DESCRIPTION \(medicationInstance.localizedDescription)", bundle: .module), selection: $dosage) {
                                ForEach(medicationOption.dosages, id: \.self) { dosage in
                                    Text(dosage.localizedDescription)
                                        .tag(dosage)
                                }
                            }
                                .pickerStyle(.inline)
                                .accessibilityIdentifier(String(localized: "EDIT_DOSAGE_PICKER", bundle: .module))
                        }
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
                .onDisappear {
                    guard medicationInstance.dosage != dosage else {
                        return
                    }
                    
                    medicationInstances.remove(medicationInstance)
                    
                    var modifiedMedication = medicationInstance
                    modifiedMedication.dosage = dosage
                    
                    medicationInstances.insert(modifiedMedication)
                }
        } else {
            ZStack {
                Color(.systemGroupedBackground).ignoresSafeArea()
                ProgressView()
            }
        }
    }
    
    
    init(medication medicationId: MI.ID, medicationInstances: Binding<Set<MI>>, medicationOptions: Set<MI.InstanceType>) {
        self.medicationInstanceId = medicationId
        self._medicationInstances = medicationInstances
        self.medicationOptions = medicationOptions
        
        guard let medicationInstance = medicationInstances.wrappedValue.first(where: { $0.id == medicationId }) else {
            fatalError("Could not find a medication with the medication id \(medicationInstanceId)")
        }
        
        self._dosage = State(wrappedValue: medicationInstance.dosage)
    }
}
