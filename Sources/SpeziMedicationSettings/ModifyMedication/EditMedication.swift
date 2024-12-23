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


struct EditMedication<MI: MedicationInstance>: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(InternalMedicationSettingsViewModel<MI>.self) private var viewModel
    
    @Binding private var medicationInstance: MI

    // TODO: (e.g., $medicationInstance.schedule.frequency)
    @State var model = CreateScheduleViewModel() // TODO: these needs to come from somewhere! and update it back

    
    var body: some View {
        VStack {
            Form {
                Section(String(localized: "Dosage", bundle: .module)) {
                    // TODO: EditDosage(dosage: $medicationInstance.dosage, medication: medicationInstance.type, initialDosage: medicationInstance.dosage)
                        // TODO: .labelsHidden()
                }
                Section(String(localized: "Schedule", bundle: .module)) { // TODO: e.g., double section!
                    EditFrequency(model: $model)
                }
                Section(String(localized: "Schedule Times", bundle: .module)) {
                    EditScheduleTime(times: $medicationInstance.schedule.times, model: $model)
                }
                Section {
                    Button(String(localized: "Delete", bundle: .module), role: .destructive) {
                        let id = medicationInstance.id
                        viewModel.medicationInstances.removeAll(where: { $0.id == id })
                        dismiss()
                    }
                }
            }
        }
            .navigationTitle(medicationInstance.type.localizedDescription)
    }
    
    
    init(medicationInstance: Binding<MI>) {
        self._medicationInstance = medicationInstance
    }
}
