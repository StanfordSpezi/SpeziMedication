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
        
        XCTAssertTrue(app.staticTexts["No Medications"].waitForExistence(timeout: 2))
        
        app.buttonTap("Show Settings")
        
        XCTAssertTrue(app.navigationBars["Medication Settings"].buttons["Add New Medication"].waitForExistence(timeout: 10))
        app.navigationBars["Medication Settings"].buttons["Add New Medication"].tap()
        
        app.buttonTap("Medication 1")
        app.buttonTap("Add Medication")
        app.buttonTap("Save Medications")
        
        try await Task.sleep(for: .seconds(2))
        
        XCTAssertTrue(app.staticTexts["Medication 1 - Dosage 1.1"].waitForExistence(timeout: 2))
    }
    
    func testSpeziMedicationDismiss() throws {
        let app = XCUIApplication()
        app.launch()
        
        XCTAssertTrue(app.staticTexts["No Medications"].waitForExistence(timeout: 2))
        
        app.buttonTap("Show Settings")
        
        XCTAssertTrue(app.navigationBars["Medication Settings"].buttons["Add New Medication"].waitForExistence(timeout: 10))
        app.navigationBars["Medication Settings"].buttons["Add New Medication"].tap()
        
        app.buttonTap("Medication 1")
        app.buttonTap("Add Medication")
        
        app.buttonTap("Cancel")
        app.buttonTap("Discard Changes")
        
        XCTAssertTrue(app.staticTexts["No Medications"].waitForExistence(timeout: 2))
    }
    
    func testSpeziMedicationEdit() throws {
//        let app = XCUIApplication()
//        app.launch()
//        
//        XCTAssertTrue(app.staticTexts["No Medications"].waitForExistence(timeout: 2))
//        
//        app.buttonTap("Show Settings")
//        
//        XCTAssertTrue(app.navigationBars["Medication Settings"].buttons["Add New Medication"].waitForExistence(timeout: 10))
//        app.navigationBars["Medication Settings"].buttons["Add New Medication"].tap()
//        
//        app.buttonTap("Medication 1")
//        app.buttonTap("Add Medication")
//        
//        let app = XCUIApplication()
//        app.buttons["Show Settings"].tap()
//        
//        let medicationSettingsNavigationBar = app.navigationBars["Medication Settings"]
//        let addNewMedicationButton = medicationSettingsNavigationBar/*@START_MENU_TOKEN@*/.buttons["Add New Medication"]/*[[".otherElements[\"Add New Medication\"].buttons[\"Add New Medication\"]",".buttons[\"Add New Medication\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
//        addNewMedicationButton.tap()
//        
//        let collectionViewsQuery2 = app.collectionViews
//        let medication1Button = collectionViewsQuery2/*@START_MENU_TOKEN@*/.buttons["Medication 1"]/*[[".cells.buttons[\"Medication 1\"]",".buttons[\"Medication 1\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
//        medication1Button.tap()
//        app.windows.children(matching: .other).element.children(matching: .other).element(boundBy: 1).children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.tap()
//        
//        let collectionViewsQuery = collectionViewsQuery2
//        collectionViewsQuery/*@START_MENU_TOKEN@*/.staticTexts["Medication 1"]/*[[".cells",".buttons[\"Medication 1, Dosage 1.1\"].staticTexts[\"Medication 1\"]",".staticTexts[\"Medication 1\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/.tap()
//        
//        let dosage12Button = collectionViewsQuery/*@START_MENU_TOKEN@*/.buttons["Dosage 1.2"]/*[[".cells.buttons[\"Dosage 1.2\"]",".buttons[\"Dosage 1.2\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
//        dosage12Button.tap()
//        dosage12Button.tap()
//        app.navigationBars["Medication 1"].buttons["Medication Settings"].tap()
//        addNewMedicationButton.tap()
//        collectionViewsQuery/*@START_MENU_TOKEN@*/.buttons["Medication 3"]/*[[".cells.buttons[\"Medication 3\"]",".buttons[\"Medication 3\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
//        
//        let addMedicationButton = app.buttons["Add Medication"]
//        addMedicationButton.tap()
//        collectionViewsQuery/*@START_MENU_TOKEN@*/.buttons["Medication 3, Dosage 3.1"]/*[[".cells.buttons[\"Medication 3, Dosage 3.1\"]",".buttons[\"Medication 3, Dosage 3.1\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
//        collectionViewsQuery/*@START_MENU_TOKEN@*/.buttons["Delete"]/*[[".cells.buttons[\"Delete\"]",".buttons[\"Delete\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
//        addNewMedicationButton.tap()
//        medication1Button.tap()
//        addMedicationButton.tap()
//        medicationSettingsNavigationBar/*@START_MENU_TOKEN@*/.buttons["Cancel"]/*[[".otherElements[\"Cancel\"].buttons[\"Cancel\"]",".buttons[\"Cancel\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
//        app.alerts["Discard Changes"].scrollViews.otherElements.buttons["Discard Changes"].tap()
//        
//        
//        XCTAssertTrue(app.staticTexts["No Medications"].waitForExistence(timeout: 2))
    }
}
