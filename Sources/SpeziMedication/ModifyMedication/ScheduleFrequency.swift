//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import SwiftUI


struct ScheduleFrequencyView: View {
    @Environment(\.dismiss) private var dismiss
    
    @Binding var outsideSchedule: Schedule
    @State private var schedule: Schedule
    @State private var regularInterval: Int = 1
    @State private var daysOfTheWeek: Weekdays = .all
    @State private var startDate: Date = .now
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    Picker("Frequency", selection: $schedule) {
                        Text("At Regular Intervals", bundle: .module)
                            .tag(Schedule.regularDayIntervals(regularInterval))
                        Text("On Specific Days of the Week", bundle: .module)
                            .tag(Schedule.specificDaysOfWeek(daysOfTheWeek))
                        Text("As Needed", bundle: .module)
                            .tag(Schedule.asNeeded)
                    }
                        .pickerStyle(.inline)
                        .labelsHidden()
                }
                if case .regularDayIntervals = schedule {
                    regularDayIntervalsSection
                }
                if case .specificDaysOfWeek = schedule {
                    specificDaysOfWeekSection
                }
                Section {
                    startDateSection
                }
            }
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(String(localized: "Cancel", bundle: .module)) {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .primaryAction) {
                    Button(String(localized: "Done", bundle: .module)) {
                        outsideSchedule = schedule
                        dismiss()
                    }
                        .bold()
                }
            }
        }
    }
    
    @ViewBuilder private var regularDayIntervalsSection: some View {
        Section(String(localized: "Choose Interval", bundle: .module)) {
            Picker("Every", selection: $regularInterval) {
                ForEach(1..<366) { day in
                    Text(Schedule.regularDayIntervals(day).description)
                        .tag(day)
                }
            }
                .pickerStyle(.wheel)
                .onChange(of: regularInterval) {
                    updateSchedule()
                }
        }
    }
    
    @ViewBuilder private var specificDaysOfWeekSection: some View {
        Section(String(localized: "Choose Days", bundle: .module)) {
            ForEach(Weekdays.allCases) { weekday in
                if daysOfTheWeek.contains(weekday) {
                    HStack {
                        Button(weekday.localizedDescription) {
                            insert(dayOfTheWeek: weekday)
                        }
                            .foregroundStyle(Color.primary)
                        Spacer()
                        Image(systemName: "checkmark")
                            .foregroundStyle(Color.accentColor)
                    }
                } else {
                    Button(weekday.localizedDescription) {
                        remove(dayOfTheWeek: weekday)
                    }
                        .foregroundStyle(Color.primary)
                }
            }
        }
    }
    
    @ViewBuilder private var startDateSection: some View {
        DatePicker(
            selection: $startDate,
            in: Date.distantPast...Date.now,
            displayedComponents: .date
        ) {
            Text("Start Date", bundle: .module)
        }
    }
    
    
    
    init(schedule: Binding<Schedule>) {
        self._outsideSchedule = schedule
        self._schedule = State(wrappedValue: schedule.wrappedValue)
        
        switch schedule.wrappedValue {
        case let .specificDaysOfWeek(daysOfTheWeek):
            self._daysOfTheWeek = State(wrappedValue: daysOfTheWeek)
        case let .regularDayIntervals(regularDayIntervals):
            self._regularInterval = State(wrappedValue: regularDayIntervals)
        case .asNeeded:
            break
        }
    }
    
    
    private func insert(dayOfTheWeek: Weekdays) {
        daysOfTheWeek.subtract(dayOfTheWeek)
        updateSchedule()
    }
    
    private func remove(dayOfTheWeek: Weekdays) {
        daysOfTheWeek.insert(dayOfTheWeek)
        updateSchedule()
    }
    
    private func updateSchedule() {
        switch schedule {
        case .regularDayIntervals:
            self.schedule = .regularDayIntervals(regularInterval)
        case .specificDaysOfWeek:
            self.schedule = .specificDaysOfWeek(daysOfTheWeek)
        case .asNeeded:
            return
        }
    }
}

#Preview {
    @State var schedule: Schedule = .specificDaysOfWeek(.all)
    
    return ScheduleFrequencyView(schedule: $schedule)
}
