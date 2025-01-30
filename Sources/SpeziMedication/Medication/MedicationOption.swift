//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import Foundation
import SpeziScheduler


/// Describe an available medication option the user might select.
///
/// A medication option can be used to provide a user with a pre-existing selection of medications.
public struct MedicationOption { // TODO: rename?
    /// Unique identifier for an medication option.
    public let id: String // TODO: do we need id?
    /// Human-readable medication label.
    public let label: LocalizedStringResource
    /// Available dosage options for a medication.
    public let dosageOptions: [Dosage]

    /// Medical codes representing the type of medication.
    public let codes: [MedicalCode]


    public init(id: String, label: LocalizedStringResource, dosageOptions: [Dosage], codes: MedicalCode...) {
        self.init(id: id, label: label, dosageOptions: dosageOptions, codes: codes)
    }


    public init(id: String, label: LocalizedStringResource, dosageOptions: [Dosage], codes: [MedicalCode] = []) {
        // TODO: do we REQUIRE dosage options?
        self.id = id
        self.label = label
        self.dosageOptions = dosageOptions
        self.codes = codes
    }
}


extension MedicationOption: Identifiable, Sendable, Equatable {}
