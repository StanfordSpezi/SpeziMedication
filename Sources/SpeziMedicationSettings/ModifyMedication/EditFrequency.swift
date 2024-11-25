//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import SpeziMedication
import SpeziViews
import SwiftUI


struct EditFrequency: View {
    @Binding private var frequency: Frequency
    @Binding private var startDate: Date
    @State private var showFrequencySheet = false
    @Binding private var model: CreateScheduleViewModel

    
    var body: some View {
        Section {
            Button {
                showFrequencySheet.toggle()
            } label: {
                LabeledContent {
                    Text("Change")
                        .foregroundStyle(Color.accentColor)
                } label: {
                    Text(frequency.description)
                        .foregroundStyle(Color.primary)
                }
            }

            if case .interval = model.selection {
                Picker("Interval", selection: $model.dayInterval) {
                    ForEach(2..<366) { day in
                        Group {
                            if day == 2 {
                                Text("Every Other Day", bundle: .module)
                            } else {
                                Text("Every \(day) Days", bundle: .module)
                            }
                        }
                            .tag(day)
                    }
                }
                    .tint(Color.accentColor)
            }
        } header: {
            Text("When will you take this?")
        }
            .headerProminence(.increased) // TODO: bit weird?
            .sheet(isPresented: $showFrequencySheet) { // TODO: does this sheet need to be placed outside the list?
                ScheduleFrequencyView(frequency: $frequency, startDate: $startDate, model: $model)
            }
    }
    
    
    init(frequency: Binding<Frequency>, startDate: Binding<Date>, model: Binding<CreateScheduleViewModel>) {
        self._frequency = frequency
        self._startDate = startDate
        self._model = model
    }
}


#if DEBUG
#Preview {
    @Previewable @State var frequency: Frequency = .regularDayIntervals(1)
    @Previewable @State var date: Date = .now
    @Previewable @State var model = CreateScheduleViewModel()

    List {
        EditFrequency(frequency: $frequency, startDate: $date, model: $model)
    }
}

#Preview {
    @Previewable @State var frequency: Frequency = .regularDayIntervals(1)
    @Previewable @State var date: Date = .now
    @Previewable @State var model = CreateScheduleViewModel(selection: .interval)

    List {
        EditFrequency(frequency: $frequency, startDate: $date, model: $model)
    }
}
#endif
