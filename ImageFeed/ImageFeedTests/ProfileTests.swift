//
//  ProfileTests.swift
//  ImageFeedTests
//
//  Created by Андрей Чупрыненко on 09.11.2023.
//
@testable import ImageFeed
import XCTest
import Foundation
import UIKit

final class ProfileTests: XCTestCase {
    
    //MARK: - Тест контроллера
    func testViewControllerCallsViewDidLoad(){
        
        let profileService = ProfileService.shared
        let viewController = ProfileViewController()
        let presenter = ProfilePresenterSpy(profileService: profileService)
        viewController.presenter = presenter
        presenter.view = viewController
        
        _ = viewController.view
        
        XCTAssertTrue(presenter.viewDidLoadCalled)
    }
    
    //MARK: - Тест выхода из профиля
    func testExitFromProfile() {
        
        let profileService = ProfileService.shared
        let presenter = ProfilePresenterSpy(profileService: profileService)
        let view = ProfileViewControllerSpy(presenter: presenter)
        view.presenter = presenter
        presenter.view = view
        
        view.showAlert()
        
        XCTAssertTrue(presenter.didLogoutCalled)
    }
    
    //MARK: - Тест получения URL аватарки
    func testGetUrlForProfileImage(){
        let profileService = ProfileService.shared
        let presenter = ProfilePresenterSpy(profileService: profileService)
        
        let url = presenter.getUrlForProfileImage()?.absoluteString
        
        XCTAssertEqual(url, "\(Constants.defaultBaseApiURL)")
    }
    
    //MARK: - Тест обновления информации пользователя
    func testLoadProfileInfo() {
        
        let profileService = ProfileService.shared
        let presenter = ProfilePresenterSpy(profileService: profileService)
        let view = ProfileViewControllerSpy(presenter: presenter)
        view.presenter = presenter
        presenter.view = view
        
        presenter.updateProfileDetails(profile: profileService.profile)
        
        XCTAssertTrue(view.views)
        XCTAssertTrue(view.constraints)
    }
}

//MARK: - Дублеры
final class ProfilePresenterSpy: ProfileViewPresenterProtocol {
    
    var view: ProfileViewControllerProtocol?
    var viewDidLoadCalled: Bool = false
    var didLogoutCalled: Bool = false
    var clean: Bool = false
    var observe: Bool = false
    
    var profileService: ImageFeed.ProfileService
    
    init(profileService: ProfileService){
        self.profileService = profileService
    }
    
    func viewDidLoad() {
        viewDidLoadCalled = true
    }
    
    func updateProfileDetails(profile: ImageFeed.Profile?) {
        view?.setupConstraints()
        view?.setupViews()
    }
    
    func observeAvatarChanges() {
        observe = true
    }
    
    func showLogoutAlert() -> UIAlertController {
        UIAlertController()
    }
    
    func logout() {
        didLogoutCalled = true
    }
    
    func cleanServicesData() {
        clean = true
    }
    
    func getUrlForProfileImage() -> URL? {
        return URL(string: "\(Constants.defaultBaseApiURL)")
    }
    
}

final class ProfileViewControllerSpy: ProfileViewControllerProtocol {
    var presenter: ImageFeed.ProfileViewPresenterProtocol
    
    init (presenter: ProfileViewPresenterProtocol) {
        self.presenter = presenter
    }
    
    var imageView = UIImageView()
    var nameLabel = UILabel()
    var usernameLabel = UILabel()
    var userDescription = UILabel()
    var update: Bool = false
    var views: Bool = false
    var constraints: Bool = false
    var alert: Bool = false
    
    func updateAvatar() {
        update = true
    }
    
    func setupViews() {
        views = true
    }
    
    func setupConstraints() {
        constraints = true
    }
    
    func showAlert() {
        presenter.logout()
    }
    
    func showLogoutAlert() {
        alert = true
    }
}
