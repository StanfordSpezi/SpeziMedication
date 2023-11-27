//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import SpeziViews
import SwiftUI


struct ScheduleTime: Identifiable, Hashable, Equatable, Comparable {
    let uuid: UUID
    let time: DateComponents
    
    
    var id: String {
        "\(time.hour ?? 0):\(time.minute ?? 0)"
    }
    
    var date: Date {
        Calendar.current.date(bySettingHour: self.time.hour ?? 0, minute: self.time.minute ?? 0, second: 0, of: .now) ?? .now
    }
    
    
    init(time: DateComponents) {
        precondition(time.hour != nil && time.minute != nil)
        
        self.uuid = UUID()
        self.time = time
    }
    
    init(date: Date) {
        self.init(time: Calendar.current.dateComponents([.hour, .minute], from: date))
    }
    
    
    static func == (lhs: ScheduleTime, rhs: ScheduleTime) -> Bool {
        lhs.time.hour == rhs.time.hour && lhs.time.minute == rhs.time.minute
    }
    
    static func < (lhs: ScheduleTime, rhs: ScheduleTime) -> Bool {
        guard lhs.time.hour == rhs.time.hour else {
            return lhs.time.hour ?? 0 < rhs.time.hour ?? 0
        }
        
        return lhs.time.minute ?? 0 < rhs.time.minute ?? 0
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}



struct AddMedicationSchedule<MI: MedicationInstance>: View {
    @Environment(InternalMedicationSettingsViewModel<MI>.self) private var viewModel
    @Binding private var isPresented: Bool
    
    @State private var schedule: Schedule = .regularDayIntervals(1)
    @State private var times: [ScheduleTime] = []
    @State private var showFrequencySheet: Bool = false
    
    private let medicationOption: MI.InstanceType
    private let dosage: MI.InstanceDosage
    
    
    var body: some View {
        VStack(spacing: 0) {
            Form {
                titleSection
                frequencySection
                timesSection
            }
            VStack(alignment: .center) {
                AsyncButton(
                    action: {
                        viewModel.medicationInstances.insert(viewModel.createMedicationInstance(medicationOption, dosage, schedule))
                        isPresented = false
                    },
                    label: {
                        Text("Add Medication", bundle: .module)
                            .frame(maxWidth: .infinity, minHeight: 38)
                    }
                )
                    .buttonStyle(.borderedProminent)
            }
                .padding()
                .background {
                    Color(uiColor: .systemGroupedBackground)
                        .edgesIgnoringSafeArea(.bottom)
                }
        }
            .navigationTitle("Medication Schedule")
    }
    
    private var titleSection: some View {
        Section {
            HStack {
                Spacer()
                VStack(alignment: .center) {
                    Image(systemName: "calendar")
                        .resizable()
                        .accessibilityHidden(true)
                        .foregroundColor(.accentColor)
                        .scaledToFit()
                        .frame(width: 70, height: 100)
                    Text("When will you take \(medicationOption.localizedDescription) (\(dosage.localizedDescription))?", bundle: .module)
                        .multilineTextAlignment(.center)
                        .font(.title2)
                }
                Spacer()
            }
        }
    }
    
    private var frequencySection: some View {
        Section {
            Button(
                action: {
                    showFrequencySheet.toggle()
                },
                label: {
                    HStack {
                        Text("Frequency")
                            .foregroundStyle(Color.primary)
                        Spacer()
                        Text(schedule.description)
                            .foregroundStyle(Color.accentColor)
                    }
                }
            )
        }
            .sheet(isPresented: $showFrequencySheet) {
                ScheduleFrequencyView(schedule: $schedule)
            }
    }
    
    private var timesSection: some View {
        Section {
            List {
                ForEach(times.sorted()) { time in
                    HStack {
                        Button(
                            action: {
                                times.removeAll(where: { $0 == time })
                            },
                            label: {
                                Image(systemName: "minus.circle.fill")
                                    .foregroundStyle(Color.red)
                            }
                        )
                        DatePicker(
                            "Time",
                            selection: Binding(
                                get: {
                                    time.date
                                },
                                set: { newValue in
                                    times.removeAll(where: { $0 == time })
                                    let newScheduleTime = ScheduleTime(date: newValue)
                                    
                                    guard !times.contains(newScheduleTime) else {
                                        return
                                    }
                                    
                                    times.append(newScheduleTime)
                                }
                            ),
                            displayedComponents: .hourAndMinute
                        )
                            .labelsHidden()
                    }
                }
            }
            Button(
                action: {
                    addNewTime()
                },
                label: {
                    HStack {
                        Image(systemName: "plus.circle.fill")
                            .foregroundStyle(Color.green)
                        Text("Add a time")
                    }
                }
            )
        }
    }
    
    
    init(
        medicationOption: MI.InstanceType,
        dosage: MI.InstanceDosage,
        isPresented: Binding<Bool>
    ) {
        self.medicationOption = medicationOption
        self.dosage = dosage
        self._isPresented = isPresented
    }
    
    
    private func addNewTime() {
        var endlessLoopCounter = 0
        var newTimeAdded = times.last?.time.date?.addingTimeInterval(60) ?? Date.now
        
        // We assume that a user doesn't take a single medication more than the loop limit.
        while endlessLoopCounter < 100 {
            let newScheduleTime = ScheduleTime(time: Calendar.current.dateComponents([.hour, .minute], from: newTimeAdded))
            
            guard !times.contains(newScheduleTime) else {
                newTimeAdded.addTimeInterval(60)
                endlessLoopCounter += 1
                continue
            }
            
            times.append(newScheduleTime)
            return
        }
    }
}
