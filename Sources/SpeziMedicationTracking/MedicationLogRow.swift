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


struct MedicationLogRow<MI: MedicationInstance>: View {
    private let medicationLogRowModel: MedicationLogRowModel<MI>
    
    @State var presentMedicationLogSheet = false
    
    
    var body: some View {
        VStack(spacing: 8) {
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
                .bold()
                .padding([.horizontal, .top])
            if medicationLogRowModel.date != nil {
                ForEach(medicationLogRowModel.medications) { medicationInstance in
                    HStack {
                        Image(systemName: "pills.circle.fill")
                            .symbolRenderingMode(.monochrome)
                            .foregroundStyle(Color(.systemGray3))
                            .accessibilityHidden(true)
                            .font(.largeTitle)
                        Text(medicationInstance.wrappedValue.type.localizedDescription)
                        Spacer()
                    }
                        .padding(.horizontal)
                }
            }
        }
            .padding(.bottom)
            .background {
                RoundedRectangle(cornerRadius: 5.0)
                    .foregroundColor(.accentColor.opacity(0.1))
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


#Preview {
    ScrollView {
        MedicationLogRow(
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
        MedicationLogRow(
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
    }
        .padding()
}
