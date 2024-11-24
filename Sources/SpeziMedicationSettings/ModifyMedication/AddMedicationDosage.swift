//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import SpeziMedication
import SpeziViews
import SwiftUI


struct AddMedicationDosage: View {
    private let option: MedicationOption

    @State private var dosage: Dosage?
    
    
    private var isDuplicate: Bool {
        false // TODO: viewModel.duplicateOf(medication: medicationOption, dosage: dosage)
    }
    
    var body: some View {
        VStack(spacing: 0) {
            Form {
                EditDosage(selection: $dosage, medication: option)
            }
            actionSection
        }
            .navigationTitle(Text(option.label))
            .onAppear {
                /*
                 TODO: duplicate check?
                if let nonUsedDosage = medicationOption.dosages.first(where: {
                    !viewModel.duplicateOf(medication: medicationOption, dosage: $0)
                }) {
                    self.dosage = nonUsedDosage
                }*/
            }
    }
    
    @MainActor @ViewBuilder private var actionSection: some View {
        VStack(alignment: .center) {
            if isDuplicate {
                Text("Medication with this dosage already exists.", bundle: .module)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.secondary)
            }
            addMedicationSaveDosageButton
        }
            .disabled(isDuplicate || dosage == nil)
            .padding()
            .background {
                Color(uiColor: .systemGroupedBackground)
                    .edgesIgnoringSafeArea(.bottom)
            }
            .navigationTitle(Text(option.label))
    }
    
    private var addMedicationSaveDosageButton: some View {
        NavigationLink(
            destination: {
                Text("Not implmented ") // TODO: implement
                /*
                AddMedicationSchedule<MI>(
                    medicationOption: medicationOption,
                    dosage: dosage
                )*/
            },
            label: {
                Text("Save Dosage", bundle: .module)
                    .frame(maxWidth: .infinity, minHeight: 38)
            }
        )
        .buttonStyle(.borderedProminent)
    }
    
    
    init(_ option: MedicationOption) {
        self.option = option
        self.dosage = nil

        /*
        guard let initialDosage = medicationOption.dosages.first else {
            fatalError("No dosage options for the medication: \(medicationOption)")
        }
        self._dosage = State(initialValue: initialDosage)
         */
    }
}


#if DEBUG
#Preview {
    let option = MedicationOption(id: "1", label: "Test Medication", dosageOptions: [
        Dosage(strength: 2, unit: .gramUnit(with: .milli), form: .capsule),
        Dosage(strength: 5, unit: .gramUnit(with: .milli), form: .capsule)
        // TODO: strength should be a decimal?
    ])
    NavigationStack {
        AddMedicationDosage(option)
    }
}
#endif
