//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import Foundation
import SpeziMedication


extension ScheduledTime {
    var date: Date {
        get {
            Calendar.current.date(bySettingHour: self.time.hour ?? 0, minute: self.time.minute ?? 0, second: 0, of: .now) ?? .now
        }
        set {
            self.time = Calendar.current.dateComponents([.hour, .minute], from: newValue)
        }
    }
}
