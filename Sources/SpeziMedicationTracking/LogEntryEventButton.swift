//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import SpeziMedication
import SwiftUI


struct LogEntryEventButton: View {
    private let role: LogEntryEvent
    @Binding private var logEntryEvent: LogEntryEvent?
    
    
    var body: some View {
        Button(
            action: {
                withAnimation {
                    if logEntryEvent != role {
                        logEntryEvent = role
                    } else {
                        logEntryEvent = nil
                    }
                }
            },
            label: {
                HStack {
                    if logEntryEvent == role {
                        Image(systemName: "checkmark.circle.fill")
                            .accessibilityHidden(true)
                    }
                    Text(role.localizedDescription)
                }
            }
        )
    }
    
    
    init(role: LogEntryEvent, logEntryEvent: Binding<LogEntryEvent?>) {
        self.role = role
        self._logEntryEvent = logEntryEvent
    }
}
