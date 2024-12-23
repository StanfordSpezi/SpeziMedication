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


struct EditFrequency: View { // TODO: remove it!
    @Binding private var model: CreateScheduleViewModel

    
    var body: some View {
        Section {
            EditFrequencyButton(model: $model)

            if case .interval = model.selection {
                ScheduleIntervalPicker(model: $model)
            }
        } header: {
            Text("When will you take this?")
        }
            .headerProminence(.increased) // TODO: bit weird?
    }
    
    
    init(model: Binding<CreateScheduleViewModel>) {
        self._model = model
    }
}


#if DEBUG
#Preview {
    @Previewable @State var model = CreateScheduleViewModel()

    List {
        EditFrequency(model: $model)
    }
}
#endif
