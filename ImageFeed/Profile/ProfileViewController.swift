//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Андрей Чупрыненко on 07.09.2023.
//

import UIKit

final class ProfileViewController: UIViewController {
    private let storageToken = OAuth2TokenStorage()
    private let profileService = ProfileService.shared
    
    private let imageView: UIImageView = {
        let image = UIImage(named: "Avatar.png")
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Екатерина Новикова"
        label.textColor = .ypWhite
        label.font = UIFont.boldSystemFont(ofSize: 23)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.text = "@katerina_nov"
        label.textColor = .ypGray
        label.font = UIFont.systemFont(ofSize: 13)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let userDescription: UILabel = {
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
        updateProfileDetails(profile: profileService.profile)
    }
    
    private func setupViews() {
        view.backgroundColor = .ypBlack
        view.addSubview(imageView)
        view.addSubview(nameLabel)
        view.addSubview(usernameLabel)
        view.addSubview(userDescription)
        view.addSubview(logoutButton)
    }
    
    private func setupConstraints() {
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
        print("Tap tap tap")
    }
}

extension ProfileViewController {
    private func updateProfileDetails(profile: Profile?) {
        guard let profile = profileService.profile else {return}
        nameLabel.text = profile.name
        usernameLabel.text = profile.loginName
        userDescription.text = profile.bio
    }
}
