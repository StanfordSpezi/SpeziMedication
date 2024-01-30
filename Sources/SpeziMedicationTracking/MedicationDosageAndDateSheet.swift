//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import SpeziMedication
import SwiftUI
@_implementationOnly import XCTSpeziMedication


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
            VStack {
                Form {
                    titleSection
                    dosageSection
                    timeSection
                }
                    .listSectionSpacing(20)
            }
                .toolbar {
                    ToolbarItem(placement: .primaryAction) {
                        Button("Done") {
                            dismiss()
                        }
                    }
                }
                .navigationBarTitleDisplayMode(.inline)
                .navigationTitle("Log Details")
        }
    }
    
    private var titleSection: some View {
        Section {
            VStack(alignment: .leading, spacing: 8) {
                Text(medicationInstance.type.localizedDescription)
                    .font(.title3)
                    .bold()
                Text(medicationInstance.dosage.localizedDescription)
                    .foregroundStyle(.secondary)
            }
        }
            .listRowBackground(Color.clear)
            .listRowSeparator(.hidden)
            .listRowInsets(
                EdgeInsets(
                    top: 0,
                    leading: 0,
                    bottom: 0,
                    trailing: 0
                )
            )
    }
    
    private var dosageSection: some View {
        Section {
            HStack {
                Text("Dosage")
                Spacer()
                TextField(
                    "Dosage",
                    value: $logEntryDosage,
                    formatter: numberOfDosageFormatter
                )
                    .multilineTextAlignment(.trailing)
                    .foregroundColor(.accentColor)
            }
        }
    }
    
    private var timeSection: some View {
        Section {
            DatePicker(
                "Time",
                selection: $logEntryDate,
                displayedComponents: .hourAndMinute
            )
                .datePickerStyle(.wheel)
        }
    }
    
    
    init(medicationInstance: MI, logEntryDosage: Binding<Double>, logEntryDate: Binding<Date>) {
        self.medicationInstance = medicationInstance
        self._logEntryDosage = logEntryDosage
        self._logEntryDate = logEntryDate
    }
}


#Preview {
    @State var logEntryDosage = 1.0
    @State var logEntryDate = Date.now
    
    return MedicationDosageAndDateSheet(
        medicationInstance: Mock.medicationInstances.sorted()[0],
        logEntryDosage: $logEntryDosage,
        logEntryDate: $logEntryDate
    )
}
