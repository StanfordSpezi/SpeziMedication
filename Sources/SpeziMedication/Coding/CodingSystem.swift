//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2025 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//


/// Represents a standardized coding system used in healthcare and clinical data exchange.
///
/// Coding systems provide structured vocabularies to ensure consistency and interoperability
/// between different health information systems. Examples include RxNorm (for medications),
/// SNOMED CT (for clinical concepts), and LOINC (for laboratory tests).
public struct CodingSystem {
    /// The raw value string.
    public let rawValue: String
    
    /// Create a new coding system type using its raw value.
    /// - Parameter rawValue: The raw value.
    public init(rawValue: String) {
        self.rawValue = rawValue
    }
}


extension CodingSystem: RawRepresentable, Hashable, Codable, Sendable {}


extension CodingSystem {
    /// A standardized nomenclature for clinical drugs, developed by the U.S. National Library of Medicine (NLM).
    ///
    /// Used for identifying and normalizing medication names and their relationships.
    /// See [RxNorm](https://www.nlm.nih.gov/research/umls/rxnorm/).
    public static let rxNorm = CodingSystem(rawValue: "http://www.nlm.nih.gov/research/umls/rxnorm")

    /// Systematized Nomenclature of Medicine – Clinical Terms.
    ///
    /// Covers diseases, procedures, anatomy, substances, and more.
    /// See [SNOMED CT](https://www.snomed.org/).
    public static let snomedCT = CodingSystem(rawValue: "http://snomed.info/sct")

    /// Logical Observation Identifiers Names and Codes.
    ///
    /// Identifying laboratory tests, clinical observations, and patient assessments.
    /// See [LOINC](https://loinc.org/).
    public static let loinc = CodingSystem(rawValue: "http://loinc.org")
}


extension CodingSystem: ExpressibleByStringLiteral {
    public init(stringLiteral value: StringLiteralType) {
        self.init(rawValue: value)
    }
}
