//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import SwiftUI


struct ScheduleFrequencyView: View {
    @Binding var schedule: Schedule
    
    var body: some View {
        Text("Frequency ...")
    }
}

#Preview {
    @State var schedule: Schedule = .asNeeded
    
    return ScheduleFrequencyView(schedule: $schedule)
}
