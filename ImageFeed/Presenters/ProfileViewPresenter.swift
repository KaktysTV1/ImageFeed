//
//  ProfileViewPresenter.swift
//  ImageFeed
//
//  Created by Андрей Чупрыненко on 05.11.2023.
//

import Foundation
import UIKit
import Kingfisher

protocol ProfileViewPresenterProtocol {
    var view: ProfileViewControllerProtocol? { get set }
    func viewDidLoad()
    func updateProfileDetails(profile: Profile?)
    func observeAvatarChanges()
    func showLogoutAlert() -> UIAlertController
    func logout()
    func cleanServicesData()
    func getUrlForProfileImage() -> URL?
    var profileService: ProfileService { get }
}

final class ProfileViewPresenter: ProfileViewPresenterProtocol {
    weak var view: ProfileViewControllerProtocol?
    private let webViewViewController = WebViewViewController()
    private var profileImageServiceObserver: NSObjectProtocol?
    var profileService = ProfileService.shared
    private let storageToken = OAuth2TokenStorage.shared
    
    func viewDidLoad() {
        updateProfileDetails(profile: profileService.profile)
        observeAvatarChanges()
    }
    
    func observeAvatarChanges() {
        profileImageServiceObserver = NotificationCenter.default.addObserver(
                forName: ProfileImageService.DidChangeNotification,
                object: nil,
                queue: .main
            ) { [weak self] _ in
                guard let self = self else { return }
                view?.updateAvatar()
            }
    }
    
    func showLogoutAlert() -> UIAlertController {
        let alert = UIAlertController(
            title: "Пока, пока!",
            message: "Уверены, что хотите выйти?",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Да", style: .default, handler: { [weak self] action in
            guard let self = self else { return }
            logout()
        }))
        alert.addAction(UIAlertAction(title: "Нет", style: .default, handler: nil))
        alert.dismiss(animated: true)
        return alert
    }
    
    func logout() {
        storageToken.cleanToken()
        WebViewViewController.clean()
        cleanServicesData()
        let tabBarController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TabBarViewController")
        guard let window = UIApplication.shared.windows.first else {
            fatalError("Invalid Configuration") }
        window.rootViewController = SplashViewController()
    }
    
    func cleanServicesData() {
        ImagesListService.shared.clean()
        ProfileService.shared.clean()
        ProfileImageService.shared.clean()
    }
    
    func updateProfileDetails(profile: Profile?) {
        guard let profile = profile else {return}
        view?.nameLabel.text = profile.name
        view?.usernameLabel.text = profile.loginName
        view?.userDescription.text = profile.bio
    }
    
    func getUrlForProfileImage() -> URL? {
        guard  let profileImageURL = ProfileImageService.shared.avatarURL,
               let url = URL(string: profileImageURL)  else { return nil }
        return url
    }
}

