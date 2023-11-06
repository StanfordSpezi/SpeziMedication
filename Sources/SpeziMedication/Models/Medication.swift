//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import Foundation


public protocol Medication: Codable, Comparable, Hashable {
    associatedtype MedicationDosage: Dosage
    
    
    var localizedDescription: String { get }
    var dosages: [MedicationDosage] { get }
}
