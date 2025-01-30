//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2025 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import Foundation


/// A standardized medical code from a recognized coding system.
///
/// ```swift
/// let ibuprofen = MedicalCode(
///     system: .rxNorm,
///     code: "1049630",
///     displayName: "Ibuprofen 200 MG Oral Tablet"
/// )
/// ```
public struct MedicalCode {
    /// The coding system.
    ///
    /// E.g., RxNorm, SNOMED CT, LOINC.
    public var system: CodingSystem
    /// A unique identifier within the system.
    public var code: String
    /// An optional human-readable display name.
    public var displayName: LocalizedStringResource?
    
    /// Create a new medical code.
    /// - Parameters:
    ///   - system: The coding system.
    ///   - code: A unique identifier within the system.
    ///   - displayName: An optional human-readable display name.
    @_disfavoredOverload
    public init(system: CodingSystem, code: String, displayName: String.LocalizationValue? = nil) {
        self.init(system: system, code: code, displayName: displayName.map { LocalizedStringResource($0) })
    }

    /// Create a new medical code.
    /// - Parameters:
    ///   - system: The coding system.
    ///   - code: A unique identifier within the system.
    ///   - displayName: An optional human-readable display name.
    public init(system: CodingSystem, code: String, displayName: LocalizedStringResource? = nil) {
        self.system = system
        self.code = code
        self.displayName = displayName
    }
}


extension MedicalCode: Sendable, Codable {}


extension MedicalCode: Equatable {
    public static func == (lhs: MedicalCode, rhs: MedicalCode) -> Bool {
        lhs.system == rhs.system && lhs.code == rhs.code
    }
}


extension MedicalCode: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(system)
        hasher.combine(code)
    }
}
