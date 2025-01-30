//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import OrderedCollections
import SpeziMedication
import SwiftUI


// TODO: its a dosage picker effectivley!
struct EditDosage: View {
    private let medication: MedicationOption

    @Binding private var selection: Dosage?

    // TODO: make custom picker with multiple sections?
    private var dosageGroups: OrderedDictionary<MedicationForm?, [Dosage]> {
        OrderedDictionary(grouping: medication.dosageOptions) { dosage in
            dosage.form?.form // TODO: weird lookup
        }
    }

    var pickerLabel: some View {
        // TODO: allow to select custom??? => generaly have a "custom input" UI => different behaviors
        ForEach(medication.dosageOptions, id: \.self) { dosage in
            LabeledContent {
                EmptyView()
            } label: {
                Text("\(dosage.strength) \(dosage.unit.unitString)")
                if let form = dosage.form?.form {
                    Text(form.description)
                }
            }
                .tag(dosage)
        }
        /*
        ForEach(dosageGroups, id: \.key) { (type, dosages) in
            Section {
                ForEach(dosages, id: \.self) { dosage in
                    Text("\(dosage.strength) \(dosage.unit.unitString)")
                        .tag(dosage)
                }
            } header: {
                if let type {
                    Text(type.description)
                }
            }
        }*/
    }

    
    var body: some View {
        // TODO: bundle
        Picker("Dosage", selection: $selection) {
            pickerLabel
        }
            .pickerStyle(.inline)
            .accessibilityIdentifier(String(localized: "Dosage Picker", bundle: .module))
        /*
        Picker(String(localized: "Dosage: \(medication.localizedDescription)", bundle: .module), selection: $dosage) {
            ForEach(medication.dosages, id: \.self) { dosage in
                if viewModel.duplicateOf(medication: medication, dosage: dosage) && initialDosage != dosage {
                    HStack {
                        VStack(alignment: .leading) {
                            Text(dosage.localizedDescription)
                            Text("Medication with this dosage already exists.", bundle: .module)
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
            .onChange(of: dosage) {
                viewModel.medicationInstances.sort()
            }*/
    }
    

    init(selection: Binding<Dosage?>, medication: MedicationOption) {
        self._selection = selection
        self.medication = medication
    }
}


#if DEBUG
#Preview {
    @Previewable @State var dosage: Dosage?
    let option = MedicationOption(id: "1", label: "Test Medication", dosageOptions: [
        Dosage(strength: 2, unit: .gramUnit(with: .milli), form: .capsule),
        Dosage(strength: 5, unit: .gramUnit(with: .milli), form: .capsule)
        // TODO: strength should be a decimal?
    ])

    List {
        EditDosage(selection: $dosage, medication: option)
    }
}
#endif
