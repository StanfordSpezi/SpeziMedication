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
    @Environment(InternalMedicationSettingsViewModel<MI>.self) private var viewModel
    
    @State private var dosage: MI.InstanceDosage
    
    private let medicationInstanceId: MI.ID
    
    private var medicationInstance: MI? {
        viewModel.medicationInstances.first(where: { $0.id == medicationInstanceId })
    }
    
    
    var body: some View {
        if let medicationInstance {
            VStack {
                Form {
                    Section {
                        Picker(String(localized: "EDIT_DOSAGE_DESCRIPTION \(medicationInstance.localizedDescription)", bundle: .module), selection: $dosage) {
                            ForEach(medicationInstance.type.dosages, id: \.self) { dosage in
                                if viewModel.duplicateOf(medication: medicationInstance.type, dosage: dosage) && medicationInstance.dosage != dosage {
                                    HStack {
                                        VStack(alignment: .leading) {
                                            Text(dosage.localizedDescription)
                                            Text("EDIT_MEDICATION_DUPLICATE", bundle: .module)
                                                .multilineTextAlignment(.leading)
                                                .font(.caption)
                                        }
                                            .foregroundStyle(Color.secondary)
                                            .disabled(true)
                                        Spacer()
                                    }
                                        .padding(.vertical, 11) // Unfortunate workaround as we can not disable touch in Pickers.
                                        .padding(.horizontal, 100)
                                        .contentShape(Rectangle())
                                        .onTapGesture {}
                                        .padding(.vertical, -11)
                                        .padding(.horizontal, -100)
                                } else {
                                    Text(dosage.localizedDescription)
                                        .tag(dosage)
                                }
                            }
                        }
                        .pickerStyle(.inline)
                        .accessibilityIdentifier(String(localized: "EDIT_DOSAGE_PICKER", bundle: .module))
                    }
                    Section {
                        Button(String(localized: "DELETE_MEDICATION", bundle: .module), role: .destructive) {
                            viewModel.medicationInstances.remove(medicationInstance)
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
                    
                    viewModel.medicationInstances.remove(medicationInstance)
                    
                    var modifiedMedication = medicationInstance
                    modifiedMedication.dosage = dosage
                    
                    viewModel.medicationInstances.insert(modifiedMedication)
                }
        } else {
            ProgressView()
        }
    }
    
    
    init(
        medicationInstance medicationInstanceId: MI.ID,
        initialDosage: MI.InstanceDosage
    ) {
        self.medicationInstanceId = medicationInstanceId
        self._dosage = State(initialValue: initialDosage)
    }
}
