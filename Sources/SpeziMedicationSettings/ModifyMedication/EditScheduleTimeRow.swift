//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import SpeziMedication
import SwiftUI


struct EditScheduleTimeRow: View {
    private let form: MedicationForm?

    @Binding private var scheduledDosage: ScheduledTime

    // TODO: we really want a 10 base number here? (only 2 digits) (only 5,2 digits)
    private let numberOfDosageFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter
    }()
    
    
    var body: some View {
        HStack {
            Button {
                // TODO: times.removeAll(where: { $0.id == time.id })
            } label: {
                Image(systemName: "minus.circle.fill")
                    .accessibilityLabel(Text("Delete", bundle: .module))
                    .foregroundStyle(Color.red)
            }
                .buttonStyle(.borderless)

            // TODO: ways that a date already?
            ScheduledTimeDatePicker(date: $scheduledDosage.date.animation(), excludedDates: [])
                .frame(maxWidth: 70)
            // TODO: excluded: times.map(\.date)

            Spacer()

            TextField(value: $scheduledDosage.dosage, formatter: numberOfDosageFormatter) {
                Text("Quantity", bundle: .module)
            }
                .textFieldStyle(.roundedBorder)
                .keyboardType(.decimalPad)
                .frame(maxWidth: 90)
        }
            .background {
                Color.clear
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .contentShape(Rectangle())
                    // TODO: add somewhere? .onTapGesture { dosageFieldIsFocused = false }
                    .padding(-32)
            }
            .onChange(of: scheduledDosage.time) {
                withAnimation {
                    // TODO: times.sort() // TODO: remove that? only sort if you add something new!
                }
            }
    }

    init(time: Binding<ScheduledTime>, form: MedicationForm?) {
        self.form = form
        self._scheduledDosage = time
    }
}


#if DEBUG
#Preview {
    @Previewable @State var time = ScheduledTime(date: .now, dosage: 1.0)

    List {
        EditScheduleTimeRow(time: $time, form: .tablet)
    }
}
#endif
