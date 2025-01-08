//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import SwiftUI


struct EditScheduleTime: View {
    // We assume that a user doesn't take a single medication more than the number of possible times which are 12 * 24 for 5 minute intervals.
    private static let maxTimesCount = (60 / ScheduledTimeDatePicker.minuteInterval) * 24
    @Binding private var model: CreateScheduleViewModel

    
    var body: some View {
        Section {
            if case .weekdayBased = model.selection {
                WeekdaysPicker(selection: $model.weekdays)
            }
            if !model.times.isEmpty {
                ForEach($model.times) { time in
                    EditScheduleTimeRow(time: time, form: nil) // TODO: propagate the form!
                }
            }
            if model.times.count < Self.maxTimesCount {
                Button(action: addNewTime) {
                    Label {
                        Text("Add a time", bundle: .module)
                    } icon: {
                        Image(systemName: "plus.circle.fill")
                            .accessibilityHidden(true)
                            .foregroundStyle(Color.green)
                    }
                }
            }
        }
    }
    
    
    init(model: Binding<CreateScheduleViewModel>) {
        self._model = model
    }
    
    
    private func addNewTime() { // TODO: move to model!
        var endlessLoopCounter = 0
        let possibleNewTime = model.times.last?.time.date?.addingTimeInterval(Double(ScheduledTimeDatePicker.minuteInterval) * 60) ?? Date.now
        let possibleNewTimeMinute = Calendar.current.dateComponents([.minute], from: possibleNewTime)
        
        guard var newTimeAdded = Calendar.current.date(
            bySetting: .minute,
            value: ((possibleNewTimeMinute.minute ?? 0) / 5) * 5,
            of: possibleNewTime
        ) else {
            return
        }
        
        while endlessLoopCounter <= Self.maxTimesCount {
            let newScheduleTime = ScheduledTime(date: newTimeAdded)
            
            guard !model.times.contains(newScheduleTime) else {
                newTimeAdded.addTimeInterval(Double(ScheduledTimeDatePicker.minuteInterval) * 60)
                endlessLoopCounter += 1
                continue
            }
            
            withAnimation {
                model.times.append(newScheduleTime)
                model.times.sort()
            }
            return
        }
    }
}


#if DEBUG
#Preview {
    @Previewable @State var model = CreateScheduleViewModel()

    List {
        EditScheduleTime(model: $model)
    }
}

#Preview {
    @Previewable @State var model = CreateScheduleViewModel(selection: .weekdayBased)

    List {
        EditScheduleTime(model: $model)
    }
}
#endif
