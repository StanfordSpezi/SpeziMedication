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

    var body: some View {
        VStack(spacing: 0) {
            Form {
                titleSection
                    .onTapGesture {
                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                    }
                EditFrequency(frequency: $frequency, startDate: $startDate)
                EditScheduleTime(times: $times)
            }
            VStack(alignment: .center) {
                AsyncButton(
                    action: {
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
            .navigationBarTitleDisplayMode(.inline)
    }
    
    private var titleSection: some View {
        Section {
            HStack {
                Spacer()
                VStack(alignment: .center) {
                    Image(systemName: "calendar")
                        .resizable()
                        .accessibilityHidden(true)
                        .symbolRenderingMode(.multicolor)
                        .scaledToFit()
                        .frame(maxWidth: 60, maxHeight: 60)
                    // TODO: Text("When will you take \(medicationOption.localizedDescription) (\(dosage.localizedDescription))?", bundle: .module)
                    Text("Set a Schedule", bundle: .module) // TODO: make that meaningful!
                        .multilineTextAlignment(.center)
                        .font(.title)
                        .bold()
                }
                Spacer()
            }
                .listRowInsets(.init(top: 15, leading: 0, bottom: 0, trailing: 0))
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
