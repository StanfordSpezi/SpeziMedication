//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import Foundation

// TODO: remove

/// Marks a ``LegacyMedicationInstance`` as being initiailzable using ``LegacyMedicationInstanceInitializable/init(type:dosage:)``.
@available(*, deprecated, message: "This will be removed")
public protocol LegacyMedicationInstanceInitializable: LegacyMedicationInstance {
    /// - Parameters:
    ///   - type: Type of the medication.
    ///   - dosage: Dosage of the medication.
    ///   - schedule: The schedule for the medication.
    init(type: InstanceType, dosage: InstanceDosage, schedule: Schedule)
}
