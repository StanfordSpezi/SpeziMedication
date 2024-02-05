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
    defaultLocalization: "en",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        .library(name: "SpeziMedication", targets: ["SpeziMedication"])
    ],
    dependencies: [
        .package(url: "https://github.com/StanfordSpezi/SpeziViews", from: "1.2.0")
    ],
    targets: [
        .target(
            name: "SpeziMedication",
            dependencies: [
                .product(name: "SpeziViews", package: "SpeziViews")
            ],
            resources: [
                .process("Resources")
            ]
        ),
        .testTarget(
            name: "SpeziMedicationTests",
            dependencies: [
                .target(name: "SpeziMedication")
            ]
        )
    ]
)
