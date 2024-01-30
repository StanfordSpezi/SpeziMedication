//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import Foundation
import SpeziMedication
import SwiftUI


@Observable
final class MedicationLogRowModel<MI: MedicationInstance>: Comparable, Identifiable {
    let date: Date?
    private(set) var medications: [Binding<MI>]
    
    
    var id: Date? {
        date
    }
    
    
    init(date: Date?, medications: [Binding<MI>]) {
        self.date = date
        self.medications = medications
    }
    
    
    static func == (lhs: MedicationLogRowModel<MI>, rhs: MedicationLogRowModel<MI>) -> Bool {
        lhs.date == rhs.date
    }
    
    static func < (lhs: MedicationLogRowModel<MI>, rhs: MedicationLogRowModel<MI>) -> Bool {
        (lhs.date ?? .distantPast) < (rhs.date ?? .distantPast)
    }
    
    static func allLoggedTimes(
        basedOn medicationInstances: Binding<[MI]>,
        on date: Date
    ) -> [MedicationLogRowModel<MI>] {
        mapToGroupedMedicationLogRowModel(basedOn: medicationInstances) { medicationInstanceBinding in
            medicationInstanceBinding.wrappedValue.logEntries
                .filter {
                    Calendar.current.startOfDay(for: $0.date) == Calendar.current.startOfDay(for: date)
                }
                .map {
                    // var date = Calendar.current.date(bySetting: .nanosecond, value: 0, of: $0.date)
                    // date = Calendar.current.date(bySetting: .second, value: 0, of: date ?? $0.date)
                    return ($0.date, medicationInstanceBinding)
                }
        }
    }
    
    static func allScheduledTimes(
        basedOn medicationInstances: Binding<[MI]>,
        on date: Date
    ) -> [MedicationLogRowModel<MI>] {
        mapToGroupedMedicationLogRowModel(basedOn: medicationInstances) { medicationInstanceBinding in
            medicationInstanceBinding.wrappedValue.schedule.timesScheduled(onDay: date)
                .map {
                    ($0, medicationInstanceBinding)
                }
        }
    }
    
    private static func mapToGroupedMedicationLogRowModel(
        basedOn medicationInstances: Binding<[MI]>,
        mapMedicationInstances: (Binding<MI>) -> [(Date, Binding<MI>)]
    ) -> [MedicationLogRowModel<MI>] {
        Dictionary(
            grouping: medicationInstances
                .flatMap { medicationInstance -> [(Date, Binding<MI>)] in
                    mapMedicationInstances(medicationInstance)
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
    
    
    func filter(basedOn medicationInstances: Binding<[MI]>, logEntryEvents: [LogEntryEvent]?) -> MedicationLogRowModel {
        guard let date else {
            return MedicationLogRowModel(
                date: nil,
                medications: Array(medicationInstances)
            )
        }
        
        let dateComponents = Calendar.current.dateComponents([.hour, .minute], from: date)
        
        switch logEntryEvents {
        case let .some(logEntryEvents):
            return MedicationLogRowModel(
                date: date,
                medications: medicationInstances.filter {
                    $0.wrappedValue.schedule.times.contains { $0.time.hour == dateComponents.hour && $0.time.minute == dateComponents.minute }
                        && $0.wrappedValue.logEntries.contains(
                            where: { logEntry in
                                logEntry.scheduledTime == date && logEntryEvents.contains { $0 == logEntry.event }
                            }
                        )
                }
            )
        case .none:
            return MedicationLogRowModel(
                date: date,
                medications: medicationInstances.filter {
                    $0.wrappedValue.schedule.times.contains { $0.time.hour == dateComponents.hour && $0.time.minute == dateComponents.minute }
                        && !$0.wrappedValue.logEntries.contains(where: { $0.scheduledTime == date })
                }
            )
        }
    }
}
