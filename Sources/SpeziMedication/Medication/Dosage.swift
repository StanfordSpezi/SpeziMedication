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
/// Defines the dosage of a ``LegacyMedicationInstance`` as a subset of the ``Medication/dosages`` of a ``Medication``.
@available(*, deprecated, message: "This will be removed")
public protocol LegacyDosage: Codable, Hashable {
    /// Localized description of the dosage.
    var localizedDescription: String { get }
}


/// Describes a dosage of a specific medication.
///
/// The dosage is always ever valid only in the context of a given ``MedicationOption``.
public struct Dosage {
    /// A medication from in the context of a specific medication dosage.
    public struct DosageForm {
        /// The form of the medication.
        public var form: MedicationForm
        /// The form-specific code associated with the dosage.
        public var codes: [MedicalCode]

        init(form: MedicationForm, codes: [MedicalCode] = []) {
            self.form = form
            self.codes = codes
        }
    }

    /// The strength or quantity of a single dosage.
    public var strength: UInt
    /// The unit of a single dosage.
    public var unit: HKUnit
    /// The form the dosage is delivered (e.g., capsule).
    public var form: DosageForm?

    /// Medical code that describes the dosage of a given medication.
    ///
    /// - Note: These medical codes describe a dosage of a given medication. There might be more specific codes for the same medication
    ///     that includes a form specification. For that refer to ``DosageForm/codes``.
    public var codes: [MedicalCode]

    /// Create a new medication dosage.
    /// - Parameters:
    ///   - strength: The strength of the medication.
    ///   - unit: The unit for the given `strength`.
    ///   - form: Optional description of the medication form.
    ///   - codes: Medication codes describing the medication dosage.
    public init(strength: UInt, unit: HKUnit, form: MedicationForm? = nil, codes: MedicalCode...) {
        // swiftlint:disable:previous function_default_parameter_at_end
        self.init(strength: strength, unit: unit, form: form, codes: codes)
    }

    /// Create a new medication dosage.
    /// - Parameters:
    ///   - strength: The strength of the medication.
    ///   - unit: The unit for the given `strength`.
    ///   - form: Optional description of the medication form.
    ///   - codes: Medication codes describing the medication dosage.
    public init(strength: UInt, unit: HKUnit, form: MedicationForm? = nil, codes: [MedicalCode] = []) {
        self.init(strength: strength, unit: unit, form: form.map { DosageForm(form: $0, codes: []) }, codes: codes)
    }

    /// Create a new medication dosage.
    /// - Parameters:
    ///   - strength: The strength of the medication.
    ///   - unit: The unit for the given `strength`.
    ///   - form: Optional description of the medication form.
    ///   - codes: Medication codes describing the medication dosage.
    public init(strength: UInt, unit: HKUnit, form: DosageForm? = nil, codes: MedicalCode...) {
        // swiftlint:disable:previous function_default_parameter_at_end
        self.init(strength: strength, unit: unit, form: form, codes: codes)
    }
    
    /// Create a new medication dosage.
    /// - Parameters:
    ///   - strength: The strength of the medication.
    ///   - unit: The unit for the given `strength`.
    ///   - form: Optional description of the medication form.
    ///   - codes: Medication codes describing the medication dosage.
    public init(strength: UInt, unit: HKUnit, form: DosageForm? = nil, codes: [MedicalCode] = []) {
        self.strength = strength
        self.unit = unit
        self.form = form
        self.codes = codes
    }
}


extension Dosage: Hashable, Sendable {}


extension Dosage.DosageForm: Hashable, Sendable, Codable {}


extension Dosage: Codable {
    private enum CodingKeys: String, CodingKey {
        case strength
        case unit
        case form
        case codes
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.strength = try container.decode(UInt.self, forKey: .strength)
        self.form = try container.decode(DosageForm.self, forKey: .form)
        self.unit = try HKUnit(from: container.decode(String.self, forKey: .unit))
        self.codes = try container.decode([MedicalCode].self, forKey: .codes)
    }

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(strength, forKey: .strength)
        try container.encode(unit.unitString, forKey: .unit)
        try container.encode(form, forKey: .form)
        try container.encode(codes, forKey: .codes)
    }
}
