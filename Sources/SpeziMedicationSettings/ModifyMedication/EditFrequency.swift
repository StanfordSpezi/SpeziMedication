//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import SpeziMedication
import SwiftUI


struct EditFrequency: View {
    @Binding private var frequency: Frequency
    @Binding private var startDate: Date
    @State private var showFrequencySheet = false
    
    
    var body: some View {
        Section {
            Button(
                action: {
                    showFrequencySheet.toggle()
                },
                label: {
                    HStack {
                        Text(frequency.description)
                            .foregroundStyle(Color.primary)
                        Spacer()
                        Text("Change")
                            .foregroundStyle(Color.accentColor)
                    }
                }
            )
        } header: {
            Text("When will you take this?")
        }
            .headerProminence(.increased) // TODO: bit weird?
            .sheet(isPresented: $showFrequencySheet) {
                ScheduleFrequencyView(frequency: $frequency, startDate: $startDate)
            }
    }
    
    
    init(frequency: Binding<Frequency>, startDate: Binding<Date>) {
        self._frequency = frequency
        self._startDate = startDate
    }
}


#if DEBUG
#Preview {
    @Previewable @State var frequency: Frequency = .regularDayIntervals(1)
    @Previewable @State var date: Date = .now

    List {
        EditFrequency(frequency: $frequency, startDate: $date)
    }
}
#endif
