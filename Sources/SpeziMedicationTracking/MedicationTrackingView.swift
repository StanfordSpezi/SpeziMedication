//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import SpeziFoundation
import SpeziMedication
import SwiftUI
@_implementationOnly import XCTSpeziMedication


private let dateFormatter: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.timeStyle = .none
    dateFormatter.dateStyle = .full
    return dateFormatter
}()


public struct MedicationTrackingView<MI: MedicationInstance>: View {
    @Binding private var medicationInstances: [MI]
    @State private var selectedDate: Date = .now
    
    
    public var body: some View {
        VStack {
            Text(selectedDate, formatter: dateFormatter)
                .font(.title2.bold())
                .multilineTextAlignment(.center)
            Divider()
            HStack {
                Text("Log")
                    .font(.title2.bold())
                Spacer()
            }
            ForEach(medicationLogRowModels) { medicationLogRowModel in
                let medicationLogRowModel = medicationLogRowModel.filter(basedOn: $medicationInstances, logEntryEvents: nil)
                if !medicationLogRowModel.medications.isEmpty {
                    MedicationLogRow(medicationLogRowModel: medicationLogRowModel)
                }
            }
            MedicationLogRow(medicationLogRowModel: MedicationLogRowModel<MI>(date: nil, medications: $medicationInstances.compactMap { $0 }))
            MedicationLogLogged(
                medicationInstances: $medicationInstances,
                selectedDate: selectedDate
            )
        }
            .padding(.horizontal)
    }
    
    private var medicationLogRowModels: [MedicationLogRowModel<MI>] {
        MedicationLogRowModel.allScheduledTimes(basedOn: $medicationInstances, on: selectedDate)
    }
    
    
    public init(medicationInstances: Binding<[MI]>) {
        self._medicationInstances = medicationInstances
    }
}


#Preview {
    @State var medicationInstances = Mock.medicationInstances
    
    return ScrollView {
        MedicationTrackingView(medicationInstances: $medicationInstances)
    }
}
