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
        XCTAssertTrue(webView.waitForExistence(timeout: 5))
        let loginTextField = webView.descendants(matching: .textField).element
        XCTAssertTrue(loginTextField.waitForExistence(timeout: 5))
        loginTextField.tap()
        loginTextField.typeText(email)
        webView.tap()
        
        let passwordTextField = webView.descendants(matching: .secureTextField).element
        XCTAssertTrue(passwordTextField.waitForExistence(timeout: 5))
        passwordTextField.tap()
        passwordTextField.typeText(password)
        webView.tap()
        sleep(3)
        
        XCTAssertTrue(webView.buttons["Login"].waitForExistence(timeout: 5))
        webView.buttons["Login"].tap()
        
        let tablesQuery = app.tables
        let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)
        
        XCTAssertTrue(cell.waitForExistence(timeout: 5))
    }
    
    func testFeed() throws {
        
        XCTAssertTrue(app.tabBars.buttons.element(boundBy: 0).waitForExistence(timeout: 4))
        
        let tableQuery = app.tables
        let cell = tableQuery.children(matching: .cell).element(boundBy: 0)
        XCTAssertTrue(cell.waitForExistence(timeout: 3))
        cell.swipeDown()
        sleep(2)
        
        let cellTwo = tableQuery.children(matching: .cell).element(boundBy: 1)
        XCTAssertTrue(cellTwo.waitForExistence(timeout: 3))
        XCTAssertTrue(cellTwo.buttons["likeButton"].waitForExistence(timeout: 1))
        cellTwo.buttons["likeButton"].tap()
        sleep(3)
        cellTwo.buttons["likeButton"].tap()
        sleep(3)
        
        cellTwo.tap()
        sleep(3)
        
        let image = app.scrollViews.images.element(boundBy: 0)
        image.pinch(withScale: 3, velocity: 1)
        image.pinch(withScale: 0.5, velocity: -1)
        
        XCTAssertTrue(app.buttons["backButton"].waitForExistence(timeout: 3))
        app.buttons["backButton"].tap()
    }
    
    func testProfile() throws {
        sleep(3)
        app.tabBars.buttons.element(boundBy: 1).tap()
        
        XCTAssertTrue(app.staticTexts["\(nameLable)"].exists)
        XCTAssertTrue(app.staticTexts["\(usernameLable)"].exists)
        
        app.buttons["logoutButton"].tap()
        
        app.alerts["Пока, пока!"].scrollViews.otherElements.buttons["Да"].tap()
        
        let authButton = app.buttons["Authenticate"]
        XCTAssertTrue(authButton.waitForExistence(timeout: 5))
    }
}
