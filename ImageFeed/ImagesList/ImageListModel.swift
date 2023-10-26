//
//  ImageListModel.swift
//  ImageFeed
//
//  Created by Андрей Чупрыненко on 26.10.2023.
//

import Foundation

struct PhotoResult: Decodable{
    let id: String
    let createdAt: String?
    let welcomeDescription: String?
    let isLiked: Bool?
    let urls: UrlsResult?
    let width: CGFloat
    let height: CGFloat
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case createdAt = "created_at"
        case welcomeDescription = "description"
        case isLiked = "liked_by_user"
        case urls = "urls"
        case width = "width"
        case height = "height"
    }
}

struct UrlsResult: Decodable {
    let thumbImageURL: String?
    let largeImageURL: String?
    
    enum CodingKeys: String, CodingKey {
        case thumbImageURL = "thumb"
        case largeImageURL = "full"
    }
}

struct Photo {
     let id: String
     let width: CGFloat
     let height: CGFloat
     let createdAt: Date?
     let welcomeDescription: String?
     let thumbImageURL: String?
     let largeImageURL: String?
     let isLiked: Bool
 }
