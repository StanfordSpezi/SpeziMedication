//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2024 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import Foundation
import SpeziViews


/// Describes the form or type of a medication.
public struct MedicationForm {
    /// An internal identifier or key to describe the form.
    public let id: String

    /// The localized description of the medication type.
    public let description: LocalizedStringResource

    /// A medical code that describes the generic medication form.
    ///
    /// Note, use ``Dosage/DosageForm`` if you want to describe the medication dosage delivered in a specific form.
    public let codes: [MedicalCode]


    /// Create a new medication form.
    /// - Parameters:
    ///   - id: A string identifier.
    ///   - description: A human-readable description.
    ///   - codes: Medical codes describing the medication form.
    @_disfavoredOverload
    public init(_ id: String, description: String.LocalizationValue, codes: [MedicalCode] = []) {
        self.init(id, description: LocalizedStringResource(description), codes: codes)
    }
    
    /// Create a new medication form.
    /// - Parameters:
    ///   - id: A string identifier.
    ///   - description: A human-readable description.
    ///   - codes: Medical codes describing the medication form.
    public init(_ id: String, description: LocalizedStringResource, codes: [MedicalCode] = []) {
        self.id = id
        self.codes = codes
        self.description = description
    }
}


extension MedicationForm {
    /// A capsule.
    public static let capsule = MedicationForm("capsule", description: "Capsule", codes: [
        MedicalCode(system: .snomedCT, code: "420692007", displayName: "Oral capsule")
    ])

    /// A tablet.
    public static let tablet = MedicationForm("tablet", description: "Tablet", codes: [
        MedicalCode(system: .snomedCT, code: "421026006", displayName: "Oral tablet")
    ])

    /// A liquid.
    public static let liquid = MedicationForm("liquid", description: "Liquid", codes: [
        MedicalCode(system: .snomedCT, code: "1231713000", displayName: "Oral pure liquid")
    ])

    /// A gel.
    public static let gel = MedicationForm("gel", description: "Gel", codes: [
        MedicalCode(system: .snomedCT, code: "385038000", displayName: "Oral gel")
    ])

    /// Drops.
    public static let drops = MedicationForm("drops", description: "Drops", codes: [
        MedicalCode(system: .snomedCT, code: "385018001", displayName: "Oral drops")
    ])
}


extension MedicationForm: Sendable, Codable {}


extension MedicationForm: Identifiable {
}


extension MedicationForm: CustomLocalizedStringResourceConvertible {
    public var localizedStringResource: LocalizedStringResource {
        description
    }
}


extension MedicationForm: Hashable {
    public static func == (lhs: MedicationForm, rhs: MedicationForm) -> Bool {
        lhs.id == rhs.id
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
