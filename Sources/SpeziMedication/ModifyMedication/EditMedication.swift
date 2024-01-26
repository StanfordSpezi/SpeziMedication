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
    
    private let medicationInstanceId: MI.ID
    
    @State private var dosage: MI.InstanceDosage
    @State private var schedule: Schedule
    
    
    private var medicationInstance: MI? {
        viewModel.medicationInstances.first(where: { $0.id == medicationInstanceId })
    }
    
    var body: some View {
        if let medicationInstance {
            VStack {
                Form {
                    Section(String(localized: "Dosage", bundle: .module)) {
                        EditDosage<MI>(dosage: $dosage, medication: medicationInstance.type, initialDosage: medicationInstance.dosage)
                            .labelsHidden()
                    }
                    Section(String(localized: "Schedule", bundle: .module)) {
                        EditFrequency(frequency: $schedule.frequency, startDate: $schedule.startDate)
                    }
                    Section(String(localized: "Schedule Times", bundle: .module)) {
                        EditScheduleTime(times: $schedule.times)
                    }
                    Section {
                        Button(String(localized: "Delete", bundle: .module), role: .destructive) {
                            viewModel.remove(medicationInstance: medicationInstance)
                            dismiss()
                        }
                    }
                }
            }
                .navigationTitle(medicationInstance.localizedDescription)
                .onChange(of: schedule) {
                    viewModel.edit(schedule: schedule, of: medicationInstance)
                }
                .onChange(of: dosage) {
                    guard dosage != medicationInstance.dosage else {
                        return
                    }
                    
                    viewModel.edit(dosage: dosage, of: medicationInstance)
                }
        } else {
            ZStack {
                Color(.systemGroupedBackground).ignoresSafeArea()
                ProgressView()
            }
        }
    }
    
    
    init(
        medicationInstance medicationInstanceId: MI.ID,
        initialDosage: MI.InstanceDosage,
        schedule: Schedule
    ) {
        self.medicationInstanceId = medicationInstanceId
        self._dosage = State(initialValue: initialDosage)
        self._schedule = State(initialValue: schedule)
    }
}
