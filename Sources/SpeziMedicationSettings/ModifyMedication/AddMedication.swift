//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import SpeziMedication
import SwiftUI


struct AddMedication: View {
    private let options: [MedicationOption]

    @Environment(\.dismiss)
    private var dismiss

    @State private var searchText = ""
    @State private var isSearching = false

    
    private var searchResults: [MedicationOption] {
        // TODO: make it sorted again!
        if isSearching && !searchText.isEmpty {
            options.filter {
                // TODO: what locale is used here?
                String(localized: $0.label).contains(searchText)
            }
        } else {
            options
        }
    }
    
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(searchResults) { medicationOption in
                    NavigationLink {
                        AddMedicationDosage(medicationOption)
                    } label: {
                        Text(medicationOption.label)
                    }
                }
            }
                .navigationTitle(String(localized: "Add a Medication", bundle: .module))
                .searchable(text: $searchText, isPresented: $isSearching, prompt: String(localized: "Search for a medication", bundle: .module))
            // TODO: promt localzanb!
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button(String(localized: "Cancel", bundle: .module)) {
                            dismiss()
                        }
                    }
                }
        }
    }
    
    
    init(from options: [MedicationOption]) {
        self.options = options
    }
}


// TODO: preview!
