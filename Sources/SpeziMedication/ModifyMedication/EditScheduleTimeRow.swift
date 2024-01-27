//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import SwiftUI


struct EditScheduleTimeRow: View {
    let index: Int
    
    @Binding private var times: [ScheduledTime]
    
    @FocusState private var dosageFieldIsFocused: Bool
    
    
    private let numberOfDosageFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter
    }()
    
    
    var body: some View {
        HStack {
            Button(
                action: {
                    times.removeAll(where: { $0.id == times[index].id })
                },
                label: {
                    Image(systemName: "minus.circle.fill")
                        .accessibilityLabel(Text("Delete", bundle: .module))
                        .foregroundStyle(Color.red)
                }
            )
                .buttonStyle(.borderless)
            ScheduledTimeDatePicker(
                date: $times[index].date.animation(),
                excludedDates: times.map(\.date)
            )
                .frame(width: 100)
            Spacer()
            TextField(
                String(localized: "Quantity", bundle: .module),
                value: $times[index].dosage,
                formatter: numberOfDosageFormatter
            )
                .focused($dosageFieldIsFocused)
                .textFieldStyle(.roundedBorder)
                .keyboardType(.decimalPad)
                .frame(maxWidth: 90)
        }
            .background {
                Color.clear
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        dosageFieldIsFocused = false
                    }
                    .padding(-32)
            }
            .onChange(of: times[index].date) {
                withAnimation {
                    times.sort()
                }
            }
    }
    
    
    init(time: ScheduledTime.ID, times: Binding<[ScheduledTime]>) {
        guard let index = times.wrappedValue.firstIndex(where: { $0.id == time }) else {
            preconditionFailure("An EditScheduleTimeRow must be initialized with a time id that is part of the times collection.")
        }
        
        self._times = times
        self.index = index
        
        self.dosageFieldIsFocused = dosageFieldIsFocused
    }
}
