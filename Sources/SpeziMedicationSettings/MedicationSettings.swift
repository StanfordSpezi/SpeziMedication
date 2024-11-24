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


/// Present medication settings including mechanisms to add, edit, and delete medications.
public struct MedicationSettings: View {
    private let medicationOptions: [MedicationOption] // TODO: was a Set previously?
    private let isPresented: Binding<Bool>? // TODO: cancelBehaviro/dismissBehavior or similar? using dismiss environment key!
    private let allowEmptySave: Bool
    private let action: () -> Void
        
    @State private var cancelAlert = false
    @State private var showAddMedicationSheet = false
    @State private var viewState: ViewState = .idle
    
    
    private var modifiedMedications: Bool {
        false
        // TODO: medicationSettingsViewModel.medicationInstances.sorted() != viewModel.medicationInstances
    }
    
    private var cancelButtonTitie: String {
        if modifiedMedications {
            String(localized: "Cancel", bundle: .module)
        } else {
            String(localized: "Close", bundle: .module)
        }
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            if false { // TODO: how to get the list of persisted medications? just filter after the fact?
                Spacer()
                // TODO: conent unavaialbel view (as an overlay?)
                Text("Use the \"+\" button at the top to add all the medications you take.", bundle: .module)
                    .multilineTextAlignment(.center)
                    .font(.title3)
                    .padding(.horizontal)
                Spacer()
            } else {
                MedicationList()
            }
            saveMedicationButton
        }
            .background {
                Color(uiColor: .systemGroupedBackground)
                    .edgesIgnoringSafeArea(.all)
            }
            .navigationTitle(String(localized: "Medication Settings", bundle: .module))
            .sheet(isPresented: $showAddMedicationSheet) {
                AddMedication(from: medicationOptions)
            }
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    addMedicationButton
                        .disabled(viewState == .processing)
                }
                if let isPresented {
                    ToolbarItem(placement: .cancellationAction) {
                        Button(cancelButtonTitie) {
                            if !modifiedMedications {
                                isPresented.wrappedValue = false
                            } else {
                                cancelAlert = true
                            }
                        }
                    }
                }
            }
            .viewStateAlert(state: $viewState)
            .alert(isPresented: $cancelAlert) { // TODO: migrate to confirmation dialog!
                Alert(
                    title: Text("Discard Changes", bundle: .module),
                    message: Text("You are about to leave the medication settings view without saving your settings.", bundle: .module),
                    primaryButton: .default(
                        Text("Cancel", bundle: .module),
                        action: {
                            cancelAlert = false
                        }
                    ),
                    secondaryButton: .destructive(
                        Text("Discard Changes", bundle: .module),
                        action: discardChangesAction
                    )
                )
            }
            .interactiveDismissDisabled(isPresented == nil || modifiedMedications)
    }
    
    @MainActor private var saveMedicationButton: some View {
        let title: String
        title = String(localized: "Save Medications", bundle: .module) // TODO: restore previous functionality
        /*
        if viewModel.medicationInstances.isEmpty, !modifiedMedications && allowEmptySave {
            title = String(localized: "Continue with no Medications", bundle: .module)
        } else {
            title = String(localized: "Save Medications", bundle: .module)
        }
         */

        return AsyncButton(state: $viewState) {
            // TODO: try await medicationSettingsViewModel.persist(medicationInstances: Set(viewModel.medicationInstances))
            // TODO: viewModel.medicationInstances = medicationSettingsViewModel.medicationInstances.sorted()
            action()
            isPresented?.wrappedValue = false
        } label: {
            Text(title)
                .frame(maxWidth: .infinity, minHeight: 38)
        }
            .buttonStyle(.borderedProminent)
            .disabled(!modifiedMedications && !allowEmptySave)
            .padding()
            .background {
                Color(uiColor: .systemGroupedBackground)
                    .edgesIgnoringSafeArea([.horizontal, .bottom])
            }
    }
    
    private var addMedicationButton: some View {
        Button {
            showAddMedicationSheet = true
        } label: {
            Image(systemName: "plus")
                .accessibilityLabel(String(localized: "Add New Medication", bundle: .module))
        }
    }
    
    
    /// Initializes a new ``MedicationSettings`` view.
    /// - Parameters:
    ///   - isPresented: An optional binding to allow the ``MedicationSettings`` view to control the presentation of itself, should be used in combination with e.g. a `.sheet(isPresented:)` modifier.
    ///   - allowEmptySave: Flag to determine if saving without any medication instances is allowed.
    ///   - medicationSettingsViewModel: The ``MedicationSettingsViewModel`` to manage the medication settings.
    ///   - action: An optional closure to be executed after persisting medications and performing custom logic.
    public init( // swiftlint:disable:this function_default_parameter_at_end
        // We disable the default parameter order here to ensure that the action can be a trailing closure but only needs to be optionally provided.
        isPresented: Binding<Bool>? = nil,
        allowEmptySave: Bool = false,
        options: [MedicationOption],
        action: @escaping () -> Void = {}
    ) {
        self.isPresented = isPresented
        self.allowEmptySave = allowEmptySave
        self.medicationOptions = options
        self.action = action
    }
    
    
    private func discardChangesAction() {
        // TODO: viewModel.medicationInstances = medicationSettingsViewModel.medicationInstances.sorted()
        isPresented?.wrappedValue = false
    }
}
