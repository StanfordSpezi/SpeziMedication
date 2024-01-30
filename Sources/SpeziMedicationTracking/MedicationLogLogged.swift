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


struct MedicationLogLogged<MI: MedicationInstance>: View {
    @Binding private var medicationInstances: [MI]
    private let selectedDate: Date
    
    
    var body: some View {
        VStack(spacing: 8) {
            HStack {
                Text("Logged")
                    .bold()
                    .padding([.horizontal, .top])
                Spacer()
            }
            ForEach(MedicationLogRowModel.allLoggedTimes(basedOn: $medicationInstances, on: selectedDate)) { medicationLogRowModel in
                Divider()
                    .padding(.leading)
                MedicationLogLoggedRow(medicationLogRowModel: medicationLogRowModel)
            }
        }
            .background {
                RoundedRectangle(cornerRadius: 5.0)
                    .foregroundColor(Color(.systemGroupedBackground))
            }
    }
    
    
    init(
        medicationInstances: Binding<[MI]>,
        selectedDate: Date
    ) {
        self._medicationInstances = medicationInstances
        self.selectedDate = selectedDate
    }
}

struct MedicationLogLoggedRow<MI: MedicationInstance>: View {
    private let medicationLogRowModel: MedicationLogRowModel<MI>
    
    @State var presentMedicationLogSheet = false
    
    
    var body: some View {
        VStack(spacing: 8) {
            HStack {
                Text(medicationLogRowModel.date ?? .now, style: .time)
                Spacer()
                Image(systemName: "chevron.right")
                    .accessibilityHidden(true)
                    .foregroundColor(.gray)
            }
                .bold()
                .padding(.horizontal)
            ForEach(medicationLogRowModel.medications) { medicationInstance in
                logEntryView(medicationInstance: medicationInstance.wrappedValue)
                    .padding(.horizontal)
            }
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
    
    
    private func logEntryEvent(medicationInstance: MI) -> LogEntryEvent {
        medicationInstance.logEntries
            .filter { $0.date == medicationLogRowModel.date }
            .reduce(LogEntryEvent.skipped) { result, logEntry in
                if logEntry.event == .skipped && result == .skipped {
                    return .skipped
                } else {
                    return .taken
                }
            }
    }
    
    private func logEntryView(medicationInstance: MI) -> some View {
        let event = logEntryEvent(medicationInstance: medicationInstance)
        let title = if event == .skipped {
            Text("\(medicationInstance.type.localizedDescription) (Skipped)")
        } else {
            Text(medicationInstance.type.localizedDescription)
        }
        
        return HStack {
            event.icon
                .foregroundStyle(event == .taken ? Color.accentColor : Color.gray)
                .accessibilityHidden(true)
            title
            Spacer()
        }
    }
}


#Preview {
    @State var medicationInstances = Mock.medicationInstances
    
    return ScrollView {
        MedicationLogLogged(
            medicationInstances: $medicationInstances,
            selectedDate: .now
        )
            .padding()
    }
}
