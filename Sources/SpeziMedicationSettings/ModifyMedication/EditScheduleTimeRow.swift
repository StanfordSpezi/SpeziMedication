//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import SpeziMedication
import SwiftUI


struct ScheduleDosage { // TODO: Move to main
    var time: Date
    var quantity: Double // TODO: we really want a 10 base number here? (only 2 digits) (only 5,2 digits)
}


struct EditScheduleTimeRow: View {
    private let form: MedicationType?

    @Binding private var scheduledDosage: ScheduleDosage
    
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
                    // TODO: times.removeAll(where: { $0.id == time.id })
                },
                label: {
                    Image(systemName: "minus.circle.fill")
                        .accessibilityLabel(Text("Delete", bundle: .module))
                        .foregroundStyle(Color.red)
                }
            )
                .buttonStyle(.borderless)

            ScheduledTimeDatePicker(
                date: $scheduledDosage.time.animation(),
                excludedDates: [] // TODO: times.map(\.date)
            )
                .frame(width: 100)
            Spacer()
            dosageTextField
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
            .onChange(of: scheduledDosage.time) {
                withAnimation {
                    // TODO: times.sort() // TODO: remove that? only sort if you add something new!
                }
            }
    }
    
    private var dosageTextField: some View {
        TextField(
            String(localized: "Quantity", bundle: .module),
            value: $scheduledDosage.quantity,
            formatter: numberOfDosageFormatter
        )
            .focused($dosageFieldIsFocused)
            .textFieldStyle(.roundedBorder)
            .keyboardType(.decimalPad)
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    Button(
                        action: {
                            dosageFieldIsFocused = false
                        },
                        label: {
                            Text("Done")
                        }
                    )
                }
            }
            .frame(maxWidth: 90)
    }
    

    init(scheduledDosage: Binding<ScheduleDosage>, form: MedicationType?) {
        self.form = form
        self._scheduledDosage = scheduledDosage
    }
}


#if DEBUG
#Preview {
    @Previewable @State var time = ScheduleDosage(time: .now, quantity: 1.0)

    List {
        EditScheduleTimeRow(scheduledDosage: $time, form: .tablet)
    }
}
#endif
