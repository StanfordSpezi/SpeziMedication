//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import SpeziViews
import SwiftUI

extension DateComponents: Identifiable {
    public var id: Int {
        hashValue
    }
}

struct ScheduleTime: Identifiable, Hashable, Equatable {
    let id: UUID
    let time: DateComponents
}



struct AddMedicationSchedule<MI: MedicationInstance>: View {
    @Environment(InternalMedicationSettingsViewModel<MI>.self) private var viewModel
    @Binding private var isPresented: Bool
    
    @State private var schedule: Schedule = .regularDayIntervals(1)
    @State private var times: [DateComponents] = []
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
                        Text("ADD_MEDICATION_TITLE", bundle: .module)
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
                    Text("When will you take the medication?")
                        .multilineTextAlignment(.center)
                        .font(.title2)
                    Text(medicationOption.localizedDescription)
                        .multilineTextAlignment(.center)
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
                ForEach(times) { time in
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
                        DatePicker("Time", selection: Binding(get: { .now }, set: { _ in }), displayedComponents: .hourAndMinute)
                            .labelsHidden()
                    }
                }
            }
            Button(
                action: {
                    times.append(DateComponents(hour: 13, minute: 30))
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
}
