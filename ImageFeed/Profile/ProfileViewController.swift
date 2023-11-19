//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Андрей Чупрыненко on 07.09.2023.
//

import UIKit
import Kingfisher

protocol ProfileViewControllerProtocol: AnyObject {
    var presenter: ProfileViewPresenterProtocol {get set}
    var imageView: UIImageView {get set}
    var nameLabel: UILabel {get set}
    var usernameLabel: UILabel {get set}
    var userDescription: UILabel {get set}
    func updateAvatar()
    func setupConstraints()
    func showLogoutAlert()
    func setupViews()
    
}

final class ProfileViewController: UIViewController, ProfileViewControllerProtocol {
    var presenter: ProfileViewPresenterProtocol = {
        return ProfileViewPresenter()
    }()
    
    private let storageToken = OAuth2TokenStorage.shared
    private let profileService = ProfileService.shared
    
    private var profileImage = UIImage(named: "Avatar.png")
    
    var imageView: UIImageView = {
        let image = UIImage(named: "Avatar.png")
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    var nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Екатерина Новикова"
        label.textColor = .ypWhite
        label.font = UIFont.boldSystemFont(ofSize: 23)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    var usernameLabel: UILabel = {
        let label = UILabel()
        label.text = "@katerina_nov"
        label.textColor = .ypGray
        label.font = UIFont.systemFont(ofSize: 13)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    var userDescription: UILabel = {
        let label = UILabel()
        label.text = "Привет мир!"
        label.textColor = .ypWhite
        label.font = UIFont.systemFont(ofSize: 13)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let logoutButton: UIButton = {
        let button = UIButton.systemButton(
            with: UIImage(named: "Exit")!,
            target: self,
            action: #selector(Self.didTapButton)
        )
        button.translatesAutoresizingMaskIntoConstraints = false
        button.accessibilityIdentifier = "logoutButton"
        button.tintColor = .ypRed
        
        return button
    }()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent;
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        presenter.view = self
        presenter.viewDidLoad()
        updateAvatar()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateAvatar()
    }
    
    internal func setupViews() {
        view.backgroundColor = .ypBlack
        view.addSubview(imageView)
        view.addSubview(nameLabel)
        view.addSubview(usernameLabel)
        view.addSubview(userDescription)
        view.addSubview(logoutButton)
    }
    
    func setupConstraints() {
        var constraints = [NSLayoutConstraint]()
        
        constraints.append(imageView.widthAnchor.constraint(equalToConstant: 70))
        constraints.append(imageView.heightAnchor.constraint(equalToConstant: 70))
        constraints.append(imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32))
        constraints.append(imageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16))
        
        constraints.append(nameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8))
        constraints.append(nameLabel.leadingAnchor.constraint(equalTo: imageView.leadingAnchor))
        
        constraints.append(usernameLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8))
        constraints.append(usernameLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor))
        
        constraints.append(userDescription.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: 8))
        constraints.append(userDescription.leadingAnchor.constraint(equalTo: usernameLabel.leadingAnchor))
        
        constraints.append(logoutButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20))
        constraints.append(logoutButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 45))
        
        NSLayoutConstraint.activate(constraints)
    }
    
    @objc private func didTapButton() {
        showLogoutAlert()
    }
}

extension ProfileViewController {
    
    func showLogoutAlert() {
        let alert = presenter.showLogoutAlert()
            present(alert, animated: true, completion: nil)
        }
    
    internal func updateAvatar() {
        guard
            let profileImageURL = ProfileImageService.shared.avatarURL,
            let url = URL(string: profileImageURL)
        else {return}
        let processor = RoundCornerImageProcessor(cornerRadius: imageView.frame.width)
        imageView.kf.indicatorType = .activity
        imageView.kf.setImage(with: url, placeholder: UIImage(named: "placeholder.svg"), options: [.processor(processor),.cacheSerializer(FormatIndicatedCacheSerializer.png)])
        let cache = ImageCache.default
        cache.clearDiskCache()
        cache.clearMemoryCache()
    }
}
