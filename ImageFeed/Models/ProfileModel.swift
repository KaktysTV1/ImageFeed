//
//  ProfileModel.swift
//  ImageFeed
//
//  Created by Андрей Чупрыненко on 24.10.2023.
//

import Foundation

struct ProfileResult: Codable {
    let username: String
    let firstName: String
    let lastName: String
    let bio: String?
    
    enum CodingKeys: String, CodingKey {
        case username = "username"
        case firstName = "first_name"
        case lastName = "last_name"
        case bio = "bio"
        
    }
}

struct Profile: Codable {
    let username: String
    let name: String
    let loginName: String
    let bio: String?
    
    init(decodedData: ProfileResult) {
        self.username = decodedData.username
        self.name = (decodedData.firstName ) + " " + (decodedData.lastName )
        self.loginName = "@" + (decodedData.username )
        self.bio = decodedData.bio
    }
}
