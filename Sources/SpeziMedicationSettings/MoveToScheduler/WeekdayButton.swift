//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import SpeziScheduler
import SwiftUI


/// Single-letter weekday button.
public struct WeekdayButton: View {
    private let weekday: Locale.Weekday
    private let selected: Bool
    private let action: () -> Void

    @Environment(\.isEnabled)
    private var isEnabled

    public var body: some View {
        Button(action: action) {
            Text(Calendar.current.veryShortWeekdaySymbols[weekday.ordinal - 1])
                .foregroundStyle(selected ? .white : (isEnabled ? .primary : .secondary))
                .fontWeight(.semibold)
                .background {
                    Group {
                        if selected {
                            Circle()
                                .fill(.tint) // allows to customize via the native .tint modifier
                        } else {
                            Circle()
                                .foregroundStyle(.clear)
                        }
                    }
                        .frame(width: 30, height: 30)
                }
        }
            .buttonStyle(.borderless)
            .dynamicTypeSize(.large) // do not allow dynamic type size for this view
    }

    
    /// Create a new weekday button.
    /// - Parameters:
    ///   - weekday: The weekday.
    ///   - selected: Flag indicating if the weekday is currently selected.
    ///   - action: The action to execute when the button is pressed.
    public init(weekday: Locale.Weekday, selected: Bool, action: @escaping () -> Void) {
        self.weekday = weekday
        self.selected = selected
        self.action = action
    }
}


#if DEBUG
#Preview {
    @Previewable @State var selected = false

    List {
        WeekdayButton(weekday: .friday, selected: selected) {
            selected.toggle()
        }
    }
}

#Preview {
    @Previewable @State var selected = false

    List {
        WeekdayButton(weekday: .friday, selected: selected) {
            selected.toggle()
        }
            .disabled(true)
    }
}
#endif
