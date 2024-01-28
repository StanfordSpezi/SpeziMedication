//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import SpeziMedication
import SwiftUI


struct LogEntryChangedKey: PreferenceKey {
    static var defaultValue = false

    static func reduce(value: inout Bool, nextValue: () -> Bool) {
        value = value || nextValue()
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
    
    
    private var logEntryChanged: Bool {
        guard let logEntryEvent else {
            return existingLogEntry == nil
        }
        
        return LogEntry(scheduledTime: date, event: logEntryEvent, date: logEntryDate, dosage: logEntryDosage) == existingLogEntry
    }
    
    
    var body: some View {
        VStack {
            HStack {
                Image(systemName: "pills.circle.fill")
                    .symbolRenderingMode(.monochrome)
                    .accessibilityHidden(true)
                    .frame(width: 100, height: 100)
                VStack {
                    Text(medication.type.localizedDescription)
                        .font(.title3.bold())
                    Text(medication.dosage.localizedDescription)
                        .foregroundStyle(.secondary)
                    dosageAndTimeSelector
                    HStack {
                        if !asNeeded {
                            LogEntryEventButton(role: .skipped, logEntryEvent: $logEntryEvent)
                        }
                        LogEntryEventButton(role: .taken, logEntryEvent: $logEntryEvent)
                    }
                }
            }
        }
            .preference(key: LogEntryChangedKey.self, value: logEntryChanged)
    }
    
    private var dosageAndTimeSelector: some View {
        HStack {
            Text("\(logEntryDosage) at \(Text(logEntryDate, style: .time))")
                .bold()
                .foregroundColor(.accentColor)
            Image(systemName: "chevron.right")
                .accessibilityHidden(true)
                .foregroundStyle(.secondary)
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
        let existingLogEntry = medication.wrappedValue.logEntries.first {
            if asNeeded {
                $0.scheduledTime == nil && $0.date == date
            } else {
                $0.scheduledTime == date
            }
        }
        self.existingLogEntry = existingLogEntry
        self._logEntryEvent = State(wrappedValue: existingLogEntry?.event)
        self._logEntryDosage = State(wrappedValue: existingLogEntry?.dosage ?? 1)
        self._logEntryDate = State(wrappedValue: existingLogEntry?.date ?? .now)
    }
}
