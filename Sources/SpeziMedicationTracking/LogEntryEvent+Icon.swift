//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import SpeziMedication
import SwiftUI


extension LogEntryEvent {
    var icon: Image {
        switch self {
        case .skipped:
            Image(systemName: "x.circle.fill")
        case .taken:
            Image(systemName: "checkmark.circle.fill")
        }
    }
}
