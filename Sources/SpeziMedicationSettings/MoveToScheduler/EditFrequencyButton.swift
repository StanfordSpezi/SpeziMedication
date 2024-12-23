//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import SpeziViews
import SwiftUI


public struct EditFrequencyButton: View {
    @Binding private var model: CreateScheduleViewModel
    @State private var showFrequencySheet = false

    public var body: some View {
        Button {
            showFrequencySheet = true
        } label: {
            LabeledContent {
                Text("Change", bundle: .module)
                    .foregroundStyle(Color.accentColor)
            } label: {
                Text(model.selection.localizedStringResource)
                    .foregroundStyle(Color.primary)
            }
        }
            .sheet(isPresented: $showFrequencySheet) {
                ScheduleFrequencyPickerSheet("Frequency", model: $model) // TODO: title?
            }
    }

    public init(model: Binding<CreateScheduleViewModel>) {
        self._model = model
    }
}


#if DEBUG
#Preview {
    @Previewable @State var model = CreateScheduleViewModel()

    List {
        EditFrequencyButton(model: $model)
    }
}
#endif
