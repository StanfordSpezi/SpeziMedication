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


#warning("Remove Any once we move to a concrete medication type ...")
class LogEntryPersistor: Equatable {
    let medication: AnyObject
    let logEntry: LogEntry?
    
    
    init<MI: MedicationInstance>(medication: Binding<MI>, logEntry: LogEntry?) {
        self.medication = medication as AnyObject
        self.logEntry = logEntry
    }
    
    
    static func == (lhs: LogEntryPersistor, rhs: LogEntryPersistor) -> Bool {
        lhs.logEntry == rhs.logEntry
    }
}

struct LogEntryChangedKey: PreferenceKey {
    static var defaultValue: [LogEntryPersistor] = []
    
    
    static func reduce(value: inout [LogEntryPersistor], nextValue: () -> [LogEntryPersistor]) {
        value.append(contentsOf: nextValue())
    }
}


struct MedicationLogSheetRow<MI: MedicationInstance>: View {
    private let asNeeded: Bool
    private let date: Date
    private let existingLogEntry: LogEntry?
    
    @Binding private var medication: MI
    
    @State private var logEntryEvent: LogEntryEvent?
    @State private var logEntryDosage: Double
    @State private var logEntryDate: Date
    @State private var showDosageAndDateSheet = false
    
    
    private var changedLogEntry: [LogEntryPersistor] {
        let changed: Bool
        if logEntryEvent != existingLogEntry?.event {
            changed = true
        } else if let existingLogEntry, (logEntryDosage != existingLogEntry.dosage || logEntryDate != existingLogEntry.date) && logEntryEvent != nil {
            changed = true
        } else {
            changed = false
        }
        
        guard changed else {
            return []
        }
        
        var logEntryDate = Calendar.current.date(bySetting: .nanosecond, value: 0, of: logEntryDate)
        logEntryDate = Calendar.current.date(bySetting: .second, value: 0, of: logEntryDate ?? self.logEntryDate)
        
        return [
            LogEntryPersistor(
                medication: $medication,
                logEntry: logEntryEvent.map {
                    LogEntry(
                        scheduledTime: date,
                        event: $0,
                        date: logEntryDate ?? self.logEntryDate,
                        dosage: logEntryDosage
                    )
                }
            )
        ]
    }
    
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(alignment: .center) {
                Image(systemName: "pills.circle.fill")
                    .resizable()
                    .aspectRatio(1.0, contentMode: .fit)
                    .symbolRenderingMode(.monochrome)
                    .accessibilityHidden(true)
                    .frame(width: 60)
                    .foregroundColor(Color(UIColor.systemGray3))
                    .padding(8)
                VStack(alignment: .leading) {
                    Text(medication.type.localizedDescription)
                        .font(.title3.bold())
                    Text(medication.dosage.localizedDescription)
                        .foregroundStyle(.secondary)
                    dosageAndTimeSelector
                }
                Spacer()
            }
                .padding([.top, .horizontal])
            HStack {
                if !asNeeded {
                    LogEntryEventButton(role: .skipped, logEntryEvent: $logEntryEvent)
                }
                LogEntryEventButton(role: .taken, logEntryEvent: $logEntryEvent)
            }
                .padding()
        }
            .background {
                RoundedRectangle(cornerRadius: 10)
                    .foregroundStyle(.background)
            }
            .preference(key: LogEntryChangedKey.self, value: changedLogEntry)
    }
    
    private var dosageAndTimeSelector: some View {
        HStack(spacing: 4) {
            Text("\(logEntryDosage, format: .number) pill at \(Text(logEntryDate, style: .time))")
                .bold()
                .foregroundColor(.accentColor)
            Image(systemName: "chevron.right")
                .font(.caption)
                .accessibilityHidden(true)
                .foregroundStyle(.secondary.opacity(0.6))
        }
            .contentShape(Rectangle())
            .onTapGesture {
                showDosageAndDateSheet.toggle()
            }
            .sheet(isPresented: $showDosageAndDateSheet) {
                MedicationDosageAndDateSheet(
                    medicationInstance: medication,
                    logEntryDosage: $logEntryDosage,
                    logEntryDate: $logEntryDate
                )
            }
    }
    
    
    init(asNeeded: Bool, date: Date, medication: Binding<MI>) {
        self.asNeeded = asNeeded
        self.date = date
        self._medication = medication
        let existingLogEntry = medication.wrappedValue.logEntry(date: date, asNeeded: asNeeded)
        self.existingLogEntry = existingLogEntry
        self._logEntryEvent = State(wrappedValue: existingLogEntry?.event)
        self._logEntryDosage = State(wrappedValue: existingLogEntry?.dosage ?? 1)
        self._logEntryDate = State(wrappedValue: existingLogEntry?.date ?? .now)
    }
}


#Preview {
    ScrollView {
        VStack {
            MedicationLogSheetRow( // Scheduled & taken
                asNeeded: false,
                date: Calendar.current.date(bySettingHour: 8, minute: 0, second: 0, of: .now) ?? .now,
                medication: .constant(Mock.medicationInstances.sorted()[0])
            )
            MedicationLogSheetRow( // Scheduled & not taken
                asNeeded: false,
                date: Calendar.current.date(bySettingHour: 9, minute: 0, second: 0, of: .now) ?? .now,
                medication: .constant(Mock.medicationInstances.sorted()[0])
            )
            MedicationLogSheetRow( // Scheduled & skipped
                asNeeded: false,
                date: Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: .now) ?? .now,
                medication: .constant(Mock.medicationInstances.sorted()[0])
            )
            MedicationLogSheetRow( // As needed & taken
                asNeeded: true,
                date: Calendar.current.date(bySettingHour: 10, minute: 0, second: 0, of: .now) ?? .now,
                medication: .constant(Mock.medicationInstances.sorted()[0])
            )
            MedicationLogSheetRow( // As needed & not taken
                asNeeded: true,
                date: Calendar.current.date(bySettingHour: 11, minute: 0, second: 0, of: .now) ?? .now,
                medication: .constant(Mock.medicationInstances.sorted()[0])
            )
        }
            .padding()
    }
        .background {
            Color(UIColor.systemGroupedBackground)
                .edgesIgnoringSafeArea(.all)
        }
}
