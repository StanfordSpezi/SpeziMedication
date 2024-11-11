//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import SwiftUI


public enum LogEntryEvent: Codable, CaseIterable, Sendable {
    case skipped
    case taken
    
    
    public var localizedDescription: String {
        switch self {
        case .skipped:
            String(localized: "Skipped", bundle: .module)
        case .taken:
            String(localized: "Taken", bundle: .module)
        }
    }
}
