//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import Foundation


public protocol MedicationInstance: Codable, Identifiable, Comparable, Hashable where InstanceType.MedicationDosage == InstanceDosage {
    associatedtype InstanceDosage: Dosage
    associatedtype InstanceType: Medication
    
    
    var localizedDescription: String { get }
    var type: InstanceType { get }
    var dosage: InstanceDosage { get set }
}


extension MedicationInstance {
    var localizedDescription: String {
        type.localizedDescription
    }
}
