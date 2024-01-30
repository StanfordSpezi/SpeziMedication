//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import SpeziMedication
import SpeziMedicationSettings
import SpeziMedicationTracking
import SwiftUI
import XCTSpeziMedication


struct ContentView: View {
    @State private var presentSettings = false
    @State private var presentLog = false
    @State private var medicationInstances = Mock.medicationInstances
    private var medicationSettingsViewModel = ExampleMedicationSettingsViewModel()
    
    
    var body: some View {
        VStack {
            Button("Show Settings") {
                presentSettings.toggle()
            }
            Button("Show Log") {
                presentLog.toggle()
            }
            Text(medicationSettingsViewModel.description)
        }
            .sheet(isPresented: $presentSettings) {
                NavigationStack {
                    MedicationSettings(isPresented: $presentSettings, medicationSettingsViewModel: medicationSettingsViewModel)
                        .navigationTitle("Medication Settings")
                }
            }
            .sheet(isPresented: $presentLog) {
                NavigationStack {
                    ScrollView {
                        MedicationTrackingView(medicationInstances: $medicationInstances)
                    }
                        .navigationTitle("Medication Log")
                }
            }
    }
}

#Preview {
    ContentView()
}
