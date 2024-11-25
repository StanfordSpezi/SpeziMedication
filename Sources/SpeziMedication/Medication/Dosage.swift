//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import Foundation
import HealthKit

/// Dosage of a medication.
///
/// Defines the dosage of a ``MedicationInstance`` as a subset of the ``Medication/dosages`` of a ``Medication``.
@available(*, deprecated, message: "This will be removed")
public protocol LegacyDosage: Codable, Hashable {
    /// Localized description of the dosage.
    var localizedDescription: String { get }
}


/// Describes a dosage of a medication.
public struct Dosage {
    /// The strength or quantity of a single dosage.
    public var strength: UInt
    /// The unit of a single dosage.
    public var unit: HKUnit // TODO: does that work with SwiftData?
    /// The form the dosage is delivered (e.g., capsule)
    public var form: MedicationType? // TODO: make a single value container? => must be rawRepresentable then for SwiftData!

    // TODO: FHIR medicatin representation: "DeliveryRoute" e.g., oral!
    // TODO: look at FHIR coding system (e.g., system (url) + code )

    // TODO: coding system for (strenght, unit) and one with form and delivery route!

    public init(strength: UInt, unit: HKUnit, form: MedicationType? = nil) {
        self.strength = strength
        self.unit = unit
        self.form = form
    }
}


extension Dosage: Hashable, Sendable, Codable {
    enum CodingKeys: String, CodingKey {
        case strength
        case unit
        case form
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.strength = try container.decode(UInt.self, forKey: .strength)
        self.form = try container.decode(MedicationType.self, forKey: .form)

        let unitString = try container.decode(String.self, forKey: .unit) // TODO: is that doable with SwiftData?
        self.unit = HKUnit(from: unitString)
    }

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(strength, forKey: .strength)
        try container.encode(unit.unitString, forKey: .unit)
        try container.encode(form, forKey: .form)
    }
}
