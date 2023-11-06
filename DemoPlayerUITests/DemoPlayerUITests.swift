//
//  DemoPlayerUITests.swift
//  DemoPlayerUITests
//
//  Created by Tomas Pollak on 02/11/2023.
//

import XCTest

final class DemoPlayerUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testNavigationsBetweenViews() throws {
        // UI tests must launch the application that they test.
        
       
        let app = XCUIApplication()
        app.launch()
        

        app.otherElements.buttons["ListRow0"].firstMatch.tap()
        
        var staticElement = app.staticTexts["A bird in the city"]
        XCTAssertTrue(staticElement.exists)

        
        var actionElement = app.buttons["Next"]
        XCTAssertTrue(actionElement.exists)
        actionElement.tap()
        
        staticElement = app.staticTexts["Goldfinches eating"]
        XCTAssertTrue(staticElement.exists)

        
        actionElement = app.buttons["Next"]
        XCTAssertTrue(actionElement.exists)
        actionElement.tap()
        
        staticElement = app.staticTexts["Small waterfall"]
        XCTAssertTrue(staticElement.exists)

        
        actionElement = app.buttons["Next"]
        XCTAssertTrue(actionElement.exists)
        actionElement.tap()
        
        staticElement = app.staticTexts["Calming meadow"]
        XCTAssertTrue(staticElement.exists)

        
        actionElement = app.buttons["Next"]
        XCTAssertTrue(actionElement.exists)
        actionElement.tap()
        
        staticElement = app.staticTexts["A Melodic Morning Perch"]
        XCTAssertTrue(staticElement.exists)

        
        actionElement = app.buttons["Next"]
        XCTAssertTrue(actionElement.exists)
        actionElement.tap()
        
        staticElement = app.staticTexts["A Dog's Adventure Amidst the Trees"]
        XCTAssertTrue(staticElement.exists)

        
        actionElement = app.buttons["Next"]
        XCTAssertTrue(actionElement.exists)
        actionElement.tap()
        
        staticElement = app.staticTexts["Forest Stream"]
        XCTAssertTrue(staticElement.exists)

        
        actionElement = app.buttons["Next"]
        XCTAssertFalse(actionElement.exists)
 
        app.navigationBars["_TtGC7SwiftUI19UIHosting"].buttons["Videá"].tap()
        
        staticElement = app.staticTexts["A bird in the city"]
        XCTAssertTrue(staticElement.exists)
        
        app.otherElements.buttons["ListRow1"].firstMatch.tap()
        
        staticElement = app.staticTexts["A bird in the city"]
        XCTAssertTrue(staticElement.exists)

        
        actionElement = app.buttons["Next"]
        XCTAssertTrue(actionElement.exists)
        
                       
    }
    
    func testInteruptDownloadingFile() throws {
        let app = XCUIApplication()
        app.launch()
        app.collectionViews.staticTexts["ListRow3"].tap()
        
        let navigationBar = app.navigationBars["_TtGC7SwiftUI19UIHosting"]
        
        let downloadButton = navigationBar.buttons["Download"]
        XCTAssertTrue(downloadButton.exists)
        downloadButton.tap()
        
        sleep(2)
        
        let downloadingButton = navigationBar.buttons["Downloading"]
        XCTAssertTrue(downloadingButton.exists)
        downloadingButton.tap()
        
        sleep(1)
        
        let downloadButton2 = navigationBar.buttons["Download"]
        XCTAssertTrue(downloadButton2.exists)
        
    }
    
    
    func testDownloadingAndDeletingFile() throws {
        let app = XCUIApplication()
        app.launch()
        app.collectionViews.staticTexts["ListRow0"].tap()
        
        let navigationBar = app.navigationBars["_TtGC7SwiftUI19UIHosting"]
        
        var downloadButton = navigationBar.buttons["Download"]
        if !downloadButton.exists {
            let deleteButton = navigationBar.buttons["Delete"]
            XCTAssertTrue(deleteButton.exists)
            deleteButton.tap()
        }
        
        downloadButton = navigationBar.buttons["Download"]
        XCTAssertTrue(downloadButton.exists)
        downloadButton.tap()
        
        
        let downloadingButton = navigationBar.buttons["Downloading"]
        XCTAssertTrue(downloadingButton.exists)
        
        sleep(10)
        
        let deleteButton = navigationBar.buttons["Delete"]
        XCTAssertTrue(deleteButton.exists)
        deleteButton.tap()
        
        sleep(1)
        
        let downloadButton2 = navigationBar.buttons["Download"]
        XCTAssertTrue(downloadButton2.exists)
        
        
    }

}
