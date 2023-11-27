//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import SpeziViews
import SwiftUI


struct AddMedicationSchedule<MI: MedicationInstance>: View {
    @Environment(InternalMedicationSettingsViewModel<MI>.self) private var viewModel
    @Binding private var isPresented: Bool
    
    @State private var frequency: Frequency = .regularDayIntervals(1)
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
                        viewModel.medicationInstances.insert(
                            viewModel.createMedicationInstance(
                                medicationOption,
                                dosage,
                                Schedule(frequency: frequency, times: times)
                            )
                        )
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
                        Text(frequency.description)
                            .foregroundStyle(Color.accentColor)
                    }
                }
            )
        }
            .sheet(isPresented: $showFrequencySheet) {
                ScheduleFrequencyView(frequency: $frequency)
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
