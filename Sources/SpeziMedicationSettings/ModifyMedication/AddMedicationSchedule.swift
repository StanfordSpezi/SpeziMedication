//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import SpeziMedication
import SpeziViews
import SwiftUI


struct AddMedicationSchedule: View {
    // TODO: private let medicationOption: MI.InstanceType
    // TODO: private let dosage: MI.InstanceDosage

    @Environment(\.dismiss)
    private var dismiss

    @State private var frequency: Frequency = .regularDayIntervals(1)
    @State private var startDate: Date = .now
    @State private var times: [ScheduledTime] = []

    @State private var viewModel = CreateScheduleViewModel() // TODO: integrate this new model!

    @FocusState private var hasFocus: Bool

    var body: some View {
        VStack(spacing: 0) {
            Form {
                titleSection
                    .onTapGesture { // TODO: should we use that?
                        hasFocus = false
                    }

                Section {
                    EditFrequencyButton(model: $viewModel)

                    if case .interval = viewModel.selection {
                        ScheduleIntervalPicker(model: $viewModel)
                    }
                } header: {
                    Text("When will you take this?")
                }
                    .headerProminence(.increased) // TODO: use that always?

                EditScheduleTime(times: $times, model: $viewModel)
            }
                .focused($hasFocus)

            VStack(alignment: .center) {
                AsyncButton {
                    // TODO: restore!
                    /*
                     viewModel.medicationInstances.append(
                     viewModel.createMedicationInstance(
                     medicationOption,
                     dosage,
                     Schedule(frequency: frequency, times: times, startDate: startDate)
                     )
                     )*/
                    // TODO: viewModel.medicationInstances.sort()
                    dismiss()
                } label: {
                    Text("Add Medication", bundle: .module)
                        .frame(maxWidth: .infinity, minHeight: 38)
                }
                    .buttonStyle(.borderedProminent)
            }
                .padding()
                .background {
                    // TODO: weird?
                    Color(uiColor: .systemGroupedBackground)
                        .edgesIgnoringSafeArea(.bottom)
                }
        }
            .navigationTitle("Medication Schedule")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    Button {
                        hasFocus = false
                    } label: {
                        Text("Done", bundle: .module)
                    }
                        .bold()
                }
            }
    }

    @ViewBuilder private var titleSection: some View {
        Section {
            ListHeader(systemImage: "calendar") {
                Text("Set a Schedule", bundle: .module)
            }
            // TODO: Text("When will you take \(medicationOption.localizedDescription) (\(dosage.localizedDescription))?", bundle: .module)
                .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
                .listRowBackground(Color.clear)
        }
    }
    
    
    init() {}
}



#if DEBUG
#Preview {
    NavigationStack {
        AddMedicationSchedule()
    }
}
#endif
