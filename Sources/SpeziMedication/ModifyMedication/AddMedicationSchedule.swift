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
    @Binding private var isPresented: Bool
    @Binding private var medicationInstances: Set<MI>
    @State private var schedule: Schedule = .regularDayIntervals(1)
    @State private var times: [DateComponents] = []
    @State private var showFrequencySheet: Bool = false
    
    private let medicationOption: MI.InstanceType
    private let dosage: MI.InstanceDosage
    private let createMedicationInstance: AddMedication<MI>.CreateMedicationInstance
    
    
    var body: some View {
        VStack(spacing: 0) {
            Form {
                titleSection
                frequencySection
            }
            VStack(alignment: .center) {
                AsyncButton(
                    action: {
                        medicationInstances.insert(createMedicationInstance(medicationOption, dosage, schedule))
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
        medicationInstances: Binding<Set<MI>>,
        medicationOption: MI.InstanceType,
        dosage: MI.InstanceDosage,
        isPresented: Binding<Bool>,
        createMedicationInstance: @escaping AddMedication<MI>.CreateMedicationInstance
    ) {
        self._medicationInstances = medicationInstances
        self.medicationOption = medicationOption
        self.dosage = dosage
        self._isPresented = isPresented
        self.createMedicationInstance = createMedicationInstance
    }
}
