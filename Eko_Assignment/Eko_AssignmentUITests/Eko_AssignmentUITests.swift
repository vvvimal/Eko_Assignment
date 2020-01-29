//
//  Eko_AssignmentUITests.swift
//  Eko_AssignmentUITests
//
//  Created by Venugopalan, Vimal on 25/01/20.
//  Copyright © 2020 Venugopalan, Vimal. All rights reserved.
//

import XCTest

class Eko_AssignmentUITests: XCTestCase {
    let app = XCUIApplication()
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        app.launchEnvironment = ["animations" : "0"]
        app.launch()
        
        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    
    /// Test app flow
    func testAppFlow() {
        let tableView = app.tables["UserListTableView"]
        //            XCTAssertTrue(tableView.cells.element(boundBy: 0).waitForExistence(timeout: 5))
        let lastCell = tableView.cells.element(boundBy: 0)
        lastCell.tap()
        

        app.navigationBars["evanphx"].buttons["Users"].tap()
        
    }
    
    /// Test table scroll to reload data from bottom
    func testScrollTable() {
        let tableView = app.tables["UserListTableView"]
        let lastCell = tableView.cells.element(boundBy: 0)
        tableView.scrollToElement(element: lastCell, count: 6)
        
    }
    
    /// Custom swipe gesture
    ///
    /// - Parameters:
    ///   - refElement: element on which swipe gesture is to be applied
    ///   - startdelxy: start point
    ///   - enddeltaxy: end point
    func customSwipe(refElement:XCUIElement,startdelxy:CGVector,enddeltaxy: CGVector){
        let swipeStartPoint = refElement.coordinate(withNormalizedOffset: startdelxy)
        let swipeEndPoint = refElement.coordinate(withNormalizedOffset: enddeltaxy)
        swipeStartPoint.press(forDuration: 0.01, thenDragTo: swipeEndPoint)
        
    }
    
    /// test background reload
    func testBackGroundReload() {
        
        sleep(5)
        //press home button
        XCUIDevice.shared.press(.home)
        //relaunch app from background
        app.activate()
        sleep(5)
    }
    
    
}

extension XCUIElement {
    func scrollToElement(element: XCUIElement, count:Int) {
        var counter = 0
        while !element.visible() && counter < count {
            counter = counter + 1
            swipeUp()
        }
    }
    
    func visible() -> Bool {
        guard self.exists && self.isHittable && !self.frame.isEmpty else { return false }
        return XCUIApplication().windows.element(boundBy: 0).frame.contains(self.frame)
    }
}
