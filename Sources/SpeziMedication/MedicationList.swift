//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import SwiftUI


struct MedicationList<MI: MedicationInstance>: View {
    @Binding private var medicationInstances: Set<MI>
    private let medicationOptions: Set<MI.InstanceType>
    
    
    private var sortedMedicationInstances: [MI] {
        Array(medicationInstances).sorted()
    }
    
    
    var body: some View {
        List {
            ForEach(sortedMedicationInstances) { medicationInstance in
                NavigationLink(value: medicationInstance) {
                    VStack(alignment: .leading, spacing: 0) {
                        Text(medicationInstance.localizedDescription)
                            .font(.headline)
                        Text(medicationInstance.dosage.localizedDescription)
                            .font(.subheadline)
                    }
                }
            }
                .onDelete { offsets in
                    for offset in offsets {
                        medicationInstances.remove(sortedMedicationInstances[offset])
                    }
                }
                .navigationDestination(for: MI.self) { medicationInstance in
                    EditMedication(
                        medication: medicationInstance.id,
                        medicationInstances: $medicationInstances,
                        medicationOptions: medicationOptions
                    )
                }
        }
    }
    
    
    init(
        medicationInstances: Binding<Set<MI>>,
        medicationOptions: Set<MI.InstanceType>
    ) {
        self._medicationInstances = medicationInstances
        self.medicationOptions = medicationOptions
    }
}
