//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import SwiftUI


// TODO: String is not an error!
extension String: @retroactive LocalizedError {
    public var errorDescription: String? {
        self
    }
}

struct MedicationTrackingView: View {
    var body: some View {
        Text("Hello, World!")
    }
}


#Preview {
    MedicationTrackingView()
}
