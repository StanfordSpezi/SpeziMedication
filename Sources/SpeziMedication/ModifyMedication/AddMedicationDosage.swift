//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import SpeziViews
import SwiftUI


struct AddMedicationDosage<MI: MedicationInstance>: View {
    @Environment(InternalMedicationSettingsViewModel<MI>.self) private var viewModel
    
    @State private var dosage: MI.InstanceDosage
    @Binding private var isPresented: Bool
    
    private let medicationOption: MI.InstanceType
    
    
    private var isDuplicate: Bool {
        viewModel.medicationInstances.contains(viewModel.createMedicationInstance(medicationOption, dosage))
    }
    
    var body: some View {
        VStack(spacing: 0) {
            dosageForm
            actionSection
        }
            .navigationTitle(medicationOption.localizedDescription)
    }
    
    @MainActor @ViewBuilder private var dosageForm: some View {
        Form {
            Section {
                Picker(String(localized: "EDIT_DOSAGE_DESCRIPTION \(medicationOption.localizedDescription)", bundle: .module), selection: $dosage) {
                    ForEach(medicationOption.dosages, id: \.self) { dosage in
                        Text(dosage.localizedDescription)
                            .tag(dosage)
                    }
                }
                    .pickerStyle(.inline)
                    .accessibilityIdentifier(String(localized: "EDIT_DOSAGE_PICKER", bundle: .module))
            }
        }
    }
    
    @MainActor @ViewBuilder private var actionSection: some View {
        VStack(alignment: .center) {
            if isDuplicate {
                Text("EDIT_DOSAGE_PUBLICET", bundle: .module)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.secondary)
            }
            AsyncButton(
                action: {
                    viewModel.medicationInstances.insert(viewModel.createMedicationInstance(medicationOption, dosage))
                    isPresented = false
                },
                label: {
                    Text("ADD_MEDICATION_TITLE", bundle: .module)
                        .frame(maxWidth: .infinity, minHeight: 38)
                }
            )
                .buttonStyle(.borderedProminent)
        }
            .disabled(isDuplicate)
            .padding()
            .background {
                Color(uiColor: .systemGroupedBackground)
                    .edgesIgnoringSafeArea(.bottom)
            }
    }
    
    init(medicationOption: MI.InstanceType, isPresented: Binding<Bool>) {
        self.medicationOption = medicationOption
        self._isPresented = isPresented
        
        guard let initialDosage = medicationOption.dosages.first else {
            fatalError("No dosage options for the medication: \(medicationOption)")
        }
        self._dosage = State(initialValue: initialDosage)
    }
}
