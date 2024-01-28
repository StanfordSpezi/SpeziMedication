//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import SpeziMedication
import SwiftUI


struct MedicationLogRow<MI: MedicationInstance>: View {
    private let medicationLogRowModel: MedicationLogRowModel<MI>
    
    @State var presentMedicationLogSheet = false
    
    
    var body: some View {
        VStack {
            HStack {
                if let date = medicationLogRowModel.date {
                    Text(date, style: .time)
                } else {
                    Text("As Needed Medications")
                }
                Spacer()
                Image(systemName: "plus")
                    .accessibilityHidden(true)
                    .foregroundColor(.accentColor)
            }
            if medicationLogRowModel.date != nil {
                ForEach(medicationLogRowModel.medications) { medicationInstance in
                    HStack {
                        Image(systemName: "pills.circle.fill")
                            .symbolRenderingMode(.hierarchical)
                            .accessibilityHidden(true)
                        Text(medicationInstance.wrappedValue.type.localizedDescription)
                    }
                }
            }
        }
            .background {
                RoundedRectangle(cornerRadius: 5.0)
                    .foregroundColor(.accentColor.opacity(0.2))
            }
            .contentShape(Rectangle())
            .onTapGesture {
                presentMedicationLogSheet.toggle()
            }
            .sheet(isPresented: $presentMedicationLogSheet) {
                MedicationLogSheet(medicationLogRowModel: medicationLogRowModel)
            }
    }
    
    
    init(medicationLogRowModel: MedicationLogRowModel<MI>) {
        self.medicationLogRowModel = medicationLogRowModel
    }
}
