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


private let dateFormatter: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.timeStyle = .none
    dateFormatter.dateStyle = .full
    return dateFormatter
}()


struct MedicationTrackingView<MI: MedicationInstance>: View {
    @Binding private var medicationInstances: [MI]
    @State private var selectedDate: Date = .now
    
    
    var body: some View {
        VStack {
            Text(selectedDate, formatter: dateFormatter)
            Divider()
            Text("Log")
                .font(.title2)
            ForEach(allScheduledTimes) { medicationLogRowModel in
                let medicationLogRowModel = medicationLogRowModel.filter(basedOn: $medicationInstances, logEntryEvent: nil)
                if !medicationLogRowModel.medications.isEmpty {
                    MedicationLogRow(medicationLogRowModel: medicationLogRowModel)
                }
            }
            MedicationLogRow(medicationLogRowModel: MedicationLogRowModel<MI>(date: nil, medications: $medicationInstances.compactMap { $0 }))
        }
    }
    
    
    private var allScheduledTimes: [MedicationLogRowModel<MI>] {
        Dictionary(
            grouping: $medicationInstances
                .flatMap { medicationInstance -> [(Date, Binding<MI>)] in
                    medicationInstance.wrappedValue.schedule.timesScheduled(onDay: selectedDate)
                        .map {
                            ($0, medicationInstance)
                        }
                },
            by: {
                $0.0
            }
        )
            .mapValues {
                $0.map { $0.1 }
            }
            .sorted {
                $0.key < $1.key
            }
            .map {
                MedicationLogRowModel(date: $0.0, medications: $0.1)
            }
    }
    
    
    init(medicationInstances: Binding<[MI]>) {
        self._medicationInstances = medicationInstances
    }
}
