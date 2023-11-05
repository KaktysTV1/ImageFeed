//
//  ImageFeedTests.swift
//  ImageFeedTests
//
//  Created by Андрей Чупрыненко on 05.11.2023.
//

@testable import ImageFeed
import XCTest
import Foundation

final class WebViewTests: XCTestCase {
    
//MARK: - Тестируем связь контроллера и презентера
    
    func testViewControllerCallsViewDidLoad() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "WebViewViewController") as! WebViewViewController
        let presenter = WebViewPresenterSpy()
        viewController.presenter = presenter
        presenter.view = viewController
        
        _ = viewController.view
        
        XCTAssertTrue(presenter.viewDidLoadCalled)
    }
    
    //MARK: - Вызывает ли презентер после вызова presenter.viewDidLoad() метод loadRequest
    
    func testPresenterCallsLoadRequest() {
        let viewController = WebViewViewControllerSpy()
        let authHelp = AuthHelper()
        let presenter = WebViewPresenter(authHelper: authHelp)
        viewController.presenter = presenter
        presenter.view = viewController
        
        presenter.viewDidLoad()
        
        XCTAssertTrue(viewController.loadRequestCalled)
    }
    
    //MARK: - Тестируем необходимость скрытия прогресса
    
    func testProgressVisibleWhenLessThenOne() {
        let authHelp = AuthHelper()
        let presenter = WebViewPresenter(authHelper: authHelp)
        let progress: Float = 1.0
        
        let shouldHideProgress = presenter.shouldHideProgress(for: progress)
        
        XCTAssertTrue(shouldHideProgress)
    }
    
    //MARK: - Тестируем хелпер
    
    func testAuthHelperAuthURL() {
        let configuration = AuthConfiguration.standard
        let authHelp = AuthHelper()
        
        let url = authHelp.authURL()
        let urlString = url.absoluteString
        
        XCTAssertTrue(urlString.contains(configuration.unsplashAuthorizeURLString))
        XCTAssertTrue(urlString.contains(configuration.accessKey))
        XCTAssertTrue(urlString.contains(configuration.redirectURI))
        XCTAssertTrue(urlString.contains("code"))
        XCTAssertTrue(urlString.contains(configuration.accessScope))
    }
     
    //MARK: - Проверка, что AuthHelper корректно распознаёт код из ссылки
    
    func testCodeFromURL() {
        var urlComponents = URLComponents(string: "https://unsplash.com/oauth/authorize/native")!
        urlComponents.queryItems = [URLQueryItem(name: "code", value: "test code")]
        let url = urlComponents.url!
        let authHelper = AuthHelper()
        
        let code = authHelper.code(from: url)
        
        XCTAssertEqual(code, "test code")
    }
}



    

//MARK: - Дублеры

final class WebViewPresenterSpy: WebViewPresenterProtocol {
    var viewDidLoadCalled: Bool = false
    var view: WebViewViewControllerProtocol?
    
    func viewDidLoad() {
        viewDidLoadCalled = true
    }
    
    func didUpdateProgressValue(_ newValue: Double) {
        
    }
    
    func code(from url: URL) -> String? {
        return nil
    }
}

final class WebViewViewControllerSpy: WebViewViewControllerProtocol {
    func load(request: URLRequest) {
        loadRequestCalled = true
    }
    
    func setProgressValue(_ newValue: Float) {

    }
    
    func setProgressHidden(_ isHiden: Bool) {
        
    }
    
    var presenter: WebViewPresenterProtocol?
    var loadRequestCalled: Bool = false
    
    
}
