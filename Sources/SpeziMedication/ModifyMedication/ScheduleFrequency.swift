//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import SwiftUI


struct ScheduleFrequencyView: View {
    @Binding var schedule: Schedule
    @State var regularInterval: Int = 1
    @State var daysOfTheWeek: [Weekdays] = [.all]
    @State var startDate: Date = .now
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    Picker("Frequency", selection: $schedule) {
                        Text("At Regular Intervals")
                            .tag(Schedule.regularDayIntervals(regularInterval))
                        Text("On Specific Days of the Week")
                            .tag(Schedule.specificDaysOfWeek(Weekdays(daysOfTheWeek)))
                        Text("As Needed")
                            .tag(Schedule.asNeeded)
                    }
                        .pickerStyle(.inline)
                }
                if case .regularDayIntervals = schedule {
                    Section {
                        Picker("Every", selection: $regularInterval) {
                            Text("Day")
                                .tag(1)
                            Text("Other Day")
                                .tag(2)
                            ForEach(3..<366) { day in
                                Text("\(day) Days")
                                    .tag(day)
                            }
                        }
                            .pickerStyle(.wheel)
                    }
                }
                if case .specificDaysOfWeek = schedule {
                    Section {
                        ForEach(Weekdays.allCases) { weekday in
                            if daysOfTheWeek.contains(weekday) {
                                HStack {
                                    Button(weekday.localizedDescription) {
                                        daysOfTheWeek.removeAll(where: { $0 == weekday })
                                    }
                                        .foregroundStyle(Color.primary)
                                    Spacer()
                                    Image(systemName: "checkmark")
                                        .foregroundStyle(Color.accentColor)
                                }
                            } else {
                                Button(weekday.localizedDescription) {
                                    daysOfTheWeek.insert(weekday, at: 0)
                                }
                                    .foregroundStyle(Color.primary)
                            }
                        }
                    }
                }
                #warning("Do Start Date ...")
            }
        }
    }
}

#Preview {
    @State var schedule: Schedule = .asNeeded
    
    return ScheduleFrequencyView(schedule: $schedule)
}
