//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import SwiftUI


struct AddMedication<MI: MedicationInstance>: View {
    typealias CreateMedicationInstance = (MI.InstanceType, MI.InstanceDosage) -> MI
    
    
    @State private var searchText = ""
    @Binding private var isPresented: Bool
    @Binding private var medicationInstances: Set<MI>
    
    private let medicationOptions: Set<MI.InstanceType>
    private let createMedicationInstance: CreateMedicationInstance
    
    
    private var searchResults: [MI.InstanceType] {
        if searchText.isEmpty {
            return medicationOptions.sorted()
        } else {
            return medicationOptions
                .filter {
                    $0.localizedDescription.contains(searchText)
                }
                .sorted()
        }
    }
    
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(searchResults, id: \.self) { medicationOption in
                    NavigationLink {
                        AddMedicationDosage(
                            medicationInstances: $medicationInstances,
                            medicationOption: medicationOption,
                            isPresented: $isPresented,
                            createMedicationInstance: createMedicationInstance
                        )
                    } label: {
                        Text(medicationOption.localizedDescription)
                    }
                }
            }
                .navigationTitle(String(localized: "ADD_MEDICATION", bundle: .module))
                .searchable(text: $searchText, prompt: String(localized: "SEARCH_FOR_MEDICATION", bundle: .module))
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button(String(localized: "CANCEL", bundle: .module)) {
                            isPresented = false
                        }
                    }
                }
        }
    }
    
    
    init(
        medicationInstances: Binding<Set<MI>>,
        medicationOptions: Set<MI.InstanceType>,
        createMedicationInstance: @escaping CreateMedicationInstance,
        isPresented: Binding<Bool>
    ) {
        self._medicationInstances = medicationInstances
        self.medicationOptions = medicationOptions
        self.createMedicationInstance = createMedicationInstance
        self._isPresented = isPresented
    }
}
