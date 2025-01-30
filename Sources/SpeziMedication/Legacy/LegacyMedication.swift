//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import Foundation


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


@available(*, deprecated, message: "Propagare")
extension LegacyMedication {
    /// See Comparable
    public static func < (lhs: Self, rhs: Self) -> Bool {
        lhs.localizedDescription < rhs.localizedDescription
    }
}
