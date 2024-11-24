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
public struct MedicationType {
    // TODO: just make it a fixed list? enum => so we can provide the translations!

    /// The localized description of the medication type.
    public let description: LocalizedStringResource // TODO: we must not store LocalizedStringResource with SwiftData!

    private var key: String {
        description.key
    }

    fileprivate init(_ description: LocalizedStringResource) {
        self.description = description
    }
}


extension MedicationType {
    public static let capsule = MedicationType(.init("capsule", defaultValue: "Capsule", bundle: .atURL(from: .module), comment: "Medication Type"))
    public static let tablet = MedicationType(.init("tablet", defaultValue: "Tablet", bundle: .atURL(from: .module), comment: "Medication Type"))
    public static let liquid = MedicationType(.init("liquid", defaultValue: "Liquid", bundle: .atURL(from: .module), comment: "Medication Type"))
    public static let gel = MedicationType(.init("gel", defaultValue: "Gel", bundle: .atURL(from: .module), comment: "Medication Type"))
    public static let drops = MedicationType(.init("drops", defaultValue: "Drops", bundle: .atURL(from: .module), comment: "Medication Type"))


    /// Creates a custom medication type.
    ///
    /// The `key` of the `LocalizedStringResource` is used to identify a medication type.
    /// - Parameter description: The localized description of the type.
    /// - Returns: Returns the medication type.
    public static func custom(_ description: LocalizedStringResource) -> MedicationType {
        MedicationType(description)
    }
}


extension MedicationType: Sendable, Codable {}


extension MedicationType: Identifiable {
    public var id: String {
        key
    }
}


extension MedicationType: CustomLocalizedStringResourceConvertible {
    public var localizedStringResource: LocalizedStringResource {
        description
    }
}


extension MedicationType: Hashable {
    public static func == (lhs: MedicationType, rhs: MedicationType) -> Bool {
        lhs.key == rhs.key
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(key)
    }
}
