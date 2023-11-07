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
                Image(systemName: "calendar")
                    .accessibilityHidden(true)
                    .foregroundColor(.accentColor)
                    .font(.largeTitle)
                Text("When will you take the medication?")
                    .font(.title)
                Text(medicationOption.localizedDescription)
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
                        Spacer()
                        Text(schedule.description)
                            .foregroundColor(.accentColor)
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
                        Text(time.debugDescription)
                    }
                }
                
            }
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
