//
//  ImageFeedUITests.swift
//  ImageFeedUITests
//
//  Created by Андрей Чупрыненко on 14.11.2023.
//

import XCTest


final class ImageFeedUITests: XCTestCase {
    
    private let nameLable = ""
    private let usernameLable = ""
    private let email = ""
    private let password = ""
    
    private let app = XCUIApplication()
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        
        app.launch()
    }
    
    func testAuth() throws {
        app.buttons["Authenticate"].tap()
        
        let webView = app.webViews["UnsplashWebView"]
        
        XCTAssert(webView.waitForExistence(timeout: 5))
        
        let loginTextField = webView.descendants(matching: .textField).element
        XCTAssert(loginTextField.waitForExistence(timeout: 5))
        
        loginTextField.tap()
        loginTextField.typeText(email)
        webView.swipeUp()
        
        let paswordTextField = webView.descendants(matching: .textField).element
        XCTAssert(paswordTextField.waitForExistence(timeout: 5))
        
        paswordTextField.tap()
        paswordTextField.typeText(password)
        webView.swipeUp()
        
        webView.buttons["Login"].tap()
        
        let tablesQuery = app.tables
        let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)
        
        XCTAssertTrue(cell.waitForExistence(timeout: 5))
        
        print(app.debugDescription)
    }
    
    func testFeed() throws {
        let tablesQuery = app.tables
        let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)
        cell.swipeUp()
        
        sleep(2)
        
        let cellToLike = tablesQuery.children(matching: .cell).element(boundBy: 1)
        
        cellToLike.buttons["likeButton"].tap()
        cellToLike.buttons["likeButton"].tap()
        
        sleep(2)
        
        cellToLike.tap()
        
        sleep(2)
        
        let image = app.scrollViews.images.element(boundBy: 0)
        image.pinch(withScale: 3, velocity: 1)
        image.pinch(withScale: 0.5, velocity: -1)
        
        let navBackButtonWhiteButton = app.buttons["backButton"]
        navBackButtonWhiteButton.tap()
    }
    
    func testProfile() throws {
        sleep(3)
        app.tabBars.buttons.element(boundBy: 1).tap()
        
        XCTAssertTrue(app.staticTexts["\(nameLable)"].exists)
        XCTAssertTrue(app.staticTexts["\(usernameLable)"].exists)
        
        app.buttons["logoutButton"].tap()
        
        app.alerts["Пока, пока!"].scrollViews.otherElements.buttons["Да"].tap()
    }
}
