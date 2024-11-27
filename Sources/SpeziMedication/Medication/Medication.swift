//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import Foundation
import SpeziScheduler

/// Defines a medication type.
///
/// ``Medication``'s are instanced as ``MedicationInstance``s.
@available(*, deprecated, message: "This will be removed")
public protocol LegacyMedication: Codable, Comparable, Hashable {
    /// The dosage type associated with the medication.
    associatedtype MedicationDosage: LegacyDosage


    /// Localized description of the medication.
    var localizedDescription: String { get }
    /// Dosage options defining a set of options when instantiating a ``MedicationInstance``.
    var dosages: [MedicationDosage] { get }
}


extension LegacyMedication {
    /// See Comparable
    public static func < (lhs: Self, rhs: Self) -> Bool {
        lhs.localizedDescription < rhs.localizedDescription
    }
}

public struct MedicationOption: Identifiable { // TODO: how to make identifiable?
    public let id: String
    public let label: LocalizedStringResource
    public let dosageOptions: [Dosage]

    // TODO: coding system, SNOMED CT, RxNome??? => medication might have multiple codes!

    public init(id: String, label: LocalizedStringResource, dosageOptions: [Dosage]) {
        self.id = id
        self.label = label
        self.dosageOptions = dosageOptions
    }
}


import SwiftUI // TODO: extension?
public struct MedicationDescription {
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
