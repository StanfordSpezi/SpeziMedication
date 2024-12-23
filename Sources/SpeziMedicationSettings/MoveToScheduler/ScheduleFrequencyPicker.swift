//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import SpeziMedication
import SwiftUI


public struct ScheduleFrequencyPicker: View {
    @Binding private var model: CreateScheduleViewModel

    public var body: some View {
        Picker(selection: $model.selection) {
            ForEach(ScheduleFrequencySelection.allCases, id: \.rawValue) { selection in
                LabeledContent {
                    EmptyView()
                } label: {
                    Text(selection.localizedStringResource)
                    if let explanation = selection.explanation {
                        Text("\"\(explanation)\"", bundle: .module)
                            .font(.footnote)
                    }
                }
                .tag(selection)
            }
        } label: {
            Text("Schedule Options", bundle: .module)
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
        ScheduleFrequencyPicker(model: $model)
    }
}
#endif
