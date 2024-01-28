//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import SpeziMedication
import SwiftUI


struct MedicationLogSheet<MI: MedicationInstance>: View {
    private let medicationLogRowModel: MedicationLogRowModel<MI>
    
    @Environment(\.dismiss) var dismiss
    
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .center) {
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
                ForEach(medicationLogRowModel.medications) { medicationInstance in
                    MedicationLogSheetRow(
                        asNeeded: medicationLogRowModel.date == nil,
                        date: medicationLogRowModel.date ?? .now,
                        medication: medicationInstance
                    )
                }
            }
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Canel") {
                            dismiss()
                        }
                    }
                }
        }
    }
    
    
    init(medicationLogRowModel: MedicationLogRowModel<MI>) {
        self.medicationLogRowModel = medicationLogRowModel
    }
}
