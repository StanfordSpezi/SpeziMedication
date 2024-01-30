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


struct MedicationLogSheet<MI: MedicationInstance>: View {
    private let medicationLogRowModel: MedicationLogRowModel<MI>
    
    @Environment(\.dismiss) private var dismiss
    @State private var logEntryChanges: [LogEntryPersistor] = []
    
    
    var body: some View {
        NavigationStack {
            VStack {
                ScrollView {
                    VStack(alignment: .center, spacing: 8) {
                        header
                        ForEach(medicationLogRowModel.medications) { medicationInstance in
                            MedicationLogSheetRow(
                                asNeeded: medicationLogRowModel.date == nil,
                                date: medicationLogRowModel.date ?? .now,
                                medication: medicationInstance
                            )
                                .padding(.horizontal)
                        }
                    }
                        .toolbar {
                            ToolbarItem(placement: .cancellationAction) {
                                Button("Cancel") {
                                    dismiss()
                                }
                            }
                        }
                        .onPreferenceChange(LogEntryChangedKey.self) { changedLogEntries in
                            logEntryChanges = changedLogEntries
                        }
                }
                    .background {
                        Color(UIColor.systemGroupedBackground)
                            .edgesIgnoringSafeArea(.all)
                    }
                doneButton
            }
        }
    }
    
    @ViewBuilder private var header: some View {
        Text(medicationLogRowModel.date ?? .now, style: .date)
            .foregroundStyle(.secondary)
        Group {
            if let date = medicationLogRowModel.date {
                Text("\(Text(date, style: .time)) Medications")
            } else {
                Text("All Medications")
            }
        }
            .font(.title2.bold())
        Text("\(medicationLogRowModel.medications.count) Medications")
//        if medicationLogRowModel.medications.contains(where: { medication in
//            medication.wrappedValue.logEntry(
//                date: medicationLogRowModel.date ?? .now,
//                asNeeded: medicationLogRowModel.date == nil
//            ) == nil
//        }) {
//            Button(
//                action: {
//                    #warning("Enabled persisting all elements")
//                },
//                label: {
//                    Text("Log All as Taken")
//                        .bold()
//                }
//            )
//                .padding(.horizontal)
//                .padding(.vertical, 6)
//                .background {
//                    Color(UIColor.systemBackground)
//                }
//                .clipShape(Capsule())
//                .padding()
//        }
    }
    
    @ViewBuilder private var doneButton: some View {
        Button(
            action: {
                for change in logEntryChanges {
                    print("Change detected ...")
                    guard let medication = change.medication as? Binding<MI> else {
                        print("Could not parse")
                        continue
                    }
                    
                    if let existingLogEntry = medication.wrappedValue.logEntry(
                        date: medicationLogRowModel.date ?? .now,
                        asNeeded: medicationLogRowModel.date == nil
                    ) {
                        medication.logEntries.wrappedValue.removeAll(where: { $0 == existingLogEntry })
                        print("Removed ...")
                    }
                    
                    if let logEntry = change.logEntry {
                        medication.logEntries.wrappedValue.append(logEntry)
                        print("Append ...")
                    }
                }
                
                dismiss()
            },
            label: {
                Text("Done")
                    .padding(8)
                    .frame(maxWidth: .infinity)
            }
        )
            .buttonStyle(.borderedProminent)
            .padding([.horizontal, .bottom])
            .disabled(logEntryChanges.isEmpty)
            .background {
                Color(UIColor.systemGroupedBackground)
                    .edgesIgnoringSafeArea(.all)
            }
    }
    
    
    init(medicationLogRowModel: MedicationLogRowModel<MI>) {
        self.medicationLogRowModel = medicationLogRowModel
    }
}


struct MedicationLogSheet_Previews: PreviewProvider {
    static var previews: some View {
        MedicationLogSheet(
            medicationLogRowModel: MedicationLogRowModel(
                date: Calendar.current.date(bySettingHour: 6, minute: 0, second: 0, of: .now) ?? .now,
                medications: Mock.medicationInstances
                    .filter { medicationInstance in
                        medicationInstance.schedule.times.contains { $0.time.hour == 6 }
                    }
                    .map {
                        Binding.constant($0)
                    }
            )
        )
            .previewDisplayName("One Medications Tracked")
        MedicationLogSheet(
            medicationLogRowModel: MedicationLogRowModel(
                date: Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: .now) ?? .now,
                medications: Mock.medicationInstances
                    .filter { medicationInstance in
                        medicationInstance.schedule.times.contains { $0.time.hour == 12 }
                    }
                    .map {
                        Binding.constant($0)
                    }
            )
        )
            .previewDisplayName("Two Medications Tracked")
        MedicationLogSheet(
            medicationLogRowModel: MedicationLogRowModel(
                date: Calendar.current.date(bySettingHour: 20, minute: 0, second: 0, of: .now) ?? .now,
                medications: Mock.medicationInstances
                    .filter { medicationInstance in
                        medicationInstance.schedule.times.contains { $0.time.hour == 20 }
                    }
                    .map {
                        Binding.constant($0)
                    }
            )
        )
            .previewDisplayName("Two Medications Not Tracked")
        MedicationLogSheet(
            medicationLogRowModel: MedicationLogRowModel(
                date: Calendar.current.date(bySettingHour: 22, minute: 0, second: 0, of: .now) ?? .now,
                medications: Mock.medicationInstances
                    .filter { medicationInstance in
                        medicationInstance.schedule.times.contains { $0.time.hour == 22 }
                    }
                    .map {
                        Binding.constant($0)
                    }
            )
        )
            .previewDisplayName("One Medication Not Tacked")
    }
}
