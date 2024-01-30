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
                    Spacer()
                    if logEntryEvent == role {
                        role.icon
                            .accessibilityHidden(true)
                    }
                    Text(role.localizedDescription)
                        .foregroundStyle(logEntryEvent == role ? .white : .accentColor)
                        .fontWeight(.medium)
                    Spacer()
                }
            }
        )
            .tint(.accentColor.opacity(logEntryEvent == role ? 1.0 : 0.2))
            .buttonStyle(.borderedProminent)
    }
    
    
    init(role: LogEntryEvent, logEntryEvent: Binding<LogEntryEvent?>) {
        self.role = role
        self._logEntryEvent = logEntryEvent
    }
}


#Preview {
    @State var logEntryEvent: LogEntryEvent?
    
    return HStack {
        LogEntryEventButton(role: .skipped, logEntryEvent: $logEntryEvent)
        LogEntryEventButton(role: .taken, logEntryEvent: $logEntryEvent)
    }
        .padding()
}
