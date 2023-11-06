//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import Foundation


public protocol MedicationInstanceInitializable: MedicationInstance {
    init(type: InstanceType, dosage: InstanceDosage)
}
