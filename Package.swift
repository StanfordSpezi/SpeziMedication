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
        .library(name: "SpeziMedication", targets: ["SpeziMedication"]),
        .library(name: "SpeziMedicationSettings", targets: ["SpeziMedicationSettings"]),
        .library(name: "SpeziMedicationTracking", targets: ["SpeziMedicationTracking"])
    ],
    dependencies: [
        .package(url: "https://github.com/StanfordSpezi/Spezi", .upToNextMinor(from: "0.8.0")),
        .package(url: "https://github.com/StanfordSpezi/SpeziViews", .upToNextMinor(from: "0.6.2"))
    ],
    targets: [
        .target(
            name: "SpeziMedication",
            dependencies: [
                .product(name: "Spezi", package: "Spezi"),
                .product(name: "SpeziViews", package: "SpeziViews")
            ],
            resources: [
                .process("Resources")
            ]
        ),
        .target(
            name: "SpeziMedicationSettings",
            dependencies: [
                .target(name: "SpeziMedication"),
                .product(name: "Spezi", package: "Spezi"),
                .product(name: "SpeziViews", package: "SpeziViews")
            ],
            resources: [
                .process("Resources")
            ]
        ),
        .target(
            name: "SpeziMedicationTracking",
            dependencies: [
                .target(name: "SpeziMedication"),
                .product(name: "Spezi", package: "Spezi"),
                .product(name: "SpeziViews", package: "SpeziViews")
            ],
            resources: [
                .process("Resources")
            ]
        ),
        .testTarget(
            name: "SpeziMedicationTests",
            dependencies: [
                .target(name: "SpeziMedication"),
                .target(name: "SpeziMedicationSettings"),
                .target(name: "SpeziMedicationTracking")
            ]
        )
    ]
)
