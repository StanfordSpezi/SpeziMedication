//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import SpeziViews
import SwiftUI


struct ScheduleIntervalPicker: View {
    @Binding private var model: CreateScheduleViewModel

    var body: some View {
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

    init(model: Binding<CreateScheduleViewModel>) {
        self._model = model
    }
}


#if DEBUG
#Preview {
    @Previewable @State var model = CreateScheduleViewModel(selection: .interval)

    List {
        EditFrequency(model: $model)
    }
}
#endif
