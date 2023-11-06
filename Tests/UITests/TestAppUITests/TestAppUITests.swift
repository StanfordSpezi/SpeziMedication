//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import XCTest


class TestAppUITests: XCTestCase {
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        continueAfterFailure = false
    }
    
    
    @MainActor
    func testSpeziMedication() async throws {
        let app = XCUIApplication()
        app.launch()
        
        app.buttonTap("Show Settings")
        
        XCTAssertTrue(app.navigationBars["Medication Settings"].buttons["Add New Medication"].waitForExistence(timeout: 10))
        app.navigationBars["Medication Settings"].buttons["Add New Medication"].tap()
        
        app.buttonTap("Medication 1")
        app.buttonTap("Add Medication")
        app.buttonTap("Save Medications")
        
        try await Task.sleep(for: .seconds(2))
        
        XCTAssertTrue(app.staticTexts["Medication 1 - Dosage 1.1"].waitForExistence(timeout: 2))
    }
}
