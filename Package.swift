// swift-tools-version:5.9

//
// This source file is part of the Stanford Spezi open-source project
// 
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
// 
// SPDX-License-Identifier: MIT
//

import PackageDescription


let package = Package(
    name: "SpeziMedication",
    platforms: [
        .iOS(.v16)
    ],
    products: [
        .library(name: "SpeziMedication", targets: ["SpeziMedication"])
    ],
    targets: [
        .target(
            name: "SpeziMedication"
        ),
        .testTarget(
            name: "SpeziMedicationTests",
            dependencies: [
                .target(name: "SpeziMedication")
            ]
        )
    ]
)
