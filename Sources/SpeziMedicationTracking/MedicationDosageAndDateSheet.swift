//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import SpeziMedication
import SwiftUI


private let numberOfDosageFormatter: NumberFormatter = {
    let formatter = NumberFormatter()
    formatter.numberStyle = .decimal
    return formatter
}()


struct MedicationDosageAndDateSheet<MI: MedicationInstance>: View {
    let medicationInstance: MI
    
    @Environment(\.dismiss) var dismiss
    
    @Binding private var logEntryDosage: Double
    @Binding private var logEntryDate: Date
    
    
    var body: some View {
        NavigationStack {
            HStack {
                Text(medicationInstance.type.localizedDescription)
                    .bold()
                Text(medicationInstance.dosage.localizedDescription)
                    .foregroundStyle(.secondary)
                Form {
                    Section {
                        TextField(
                            "Dosage",
                            value: $logEntryDosage,
                            formatter: numberOfDosageFormatter
                        )
                    }
                    Section {
                        DatePicker(
                            "Time",
                            selection: $logEntryDate,
                            displayedComponents: .hourAndMinute
                        )
                    }
                }
            }
                .toolbar {
                    ToolbarItem(placement: .primaryAction) {
                        Button("Done") {
                            dismiss()
                        }
                    }
                }
                .navigationTitle("Log Details")
        }
    }
    
    
    init(medicationInstance: MI, logEntryDosage: Binding<Double>, logEntryDate: Binding<Date>) {
        self.medicationInstance = medicationInstance
        self._logEntryDosage = logEntryDosage
        self._logEntryDate = logEntryDate
    }
}
