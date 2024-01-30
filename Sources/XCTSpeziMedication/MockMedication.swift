//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import SpeziMedication


public struct MockMedication: Medication, Comparable {
    public var localizedDescription: String
    public var dosages: [MockDosage]
}
