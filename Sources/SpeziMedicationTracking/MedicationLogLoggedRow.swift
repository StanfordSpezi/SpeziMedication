//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import SpeziMedication
import SwiftUI


struct MedicationLogLoggedRow<MI: MedicationInstance>: View {
    @Binding private var medicationInstances: [MI]
    private var selectedDate: Date = .now
    
    
    var body: some View {
        Text("...")
    }
}
