//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2025 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import SwiftUI // TODO: extension?


/// A specific instance of an medication.
public struct MedicationDescription { // TODO: specific instance, right?
    // TODO: let id: UUID?
    // TODO: dosages!
    let description: String.LocalizationValue? // TODO: do we need Hashable?
    let name: String?

    var label: Text {
        if let name {
            Text(name)
        } else if let description {
            Text(LocalizedStringResource(description)) // TODO: which bundle? we assume main bundle?
        } else {
            Text("Medication", bundle: .module) // TODO: generic label!???
        }
    }

    let dosage: Dosage

    // TODO: schedule is part of the task!
}

extension MedicationDescription: Codable, Equatable, Sendable {
}
