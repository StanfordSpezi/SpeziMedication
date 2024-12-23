//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import SpeziMedication
import SwiftUI


public struct ScheduleFrequencyPickerSheet: View {
    private let title: Text

    @Environment(\.dismiss)
    private var dismiss

    @Binding private var model: CreateScheduleViewModel

    
    public var body: some View {
        NavigationStack {
            Form {
                ScheduleFrequencyPicker(model: $model)
                    .pickerStyle(.inline)
            }
                .navigationTitle(title)
                .navigationBarTitleDisplayMode(.inline)
                .toolbar(content: toolbar)
        }
    }
    
    
    public init(_ title: Text, model: Binding<CreateScheduleViewModel>) {
        self.title = title
        self._model = model
    }

    public init(_ titleKey: LocalizedStringResource, model: Binding<CreateScheduleViewModel>) {
        self.init(Text(titleKey), model: model)
    }

    @ToolbarContentBuilder
    private func toolbar() -> some ToolbarContent {
        ToolbarItem {
            Button {
                dismiss()
            } label: {
                Text("Done", bundle: .module)
            }
                .bold()
        }
    }
}


#if DEBUG
#Preview {
    @Previewable @State var model = CreateScheduleViewModel()
    ScheduleFrequencyPickerSheet("Schedule", model: $model)
}
#endif
