//
//  Constants.swift
//  ImageFeed
//
//  Created by Андрей Чупрыненко on 23.09.2023.
//

import Foundation

struct Constants{
    static let accessKey = "zMKWGqFw5qtHCBjCNWrnv9JEuJA-R0hPu2KAxahNQTg"
    static let secretKey = "pAvXS3M_IiXasNB0orfqF7SFu3lb7foPmZ5-LybnXhk"
    static let redirectURI = "urn:ietf:wg:oauth:2.0:oob"
    static let accessScope = "public+read_user+write_likes"
    static let defaultBaseURL = URL(string: "https://unsplash.com")!
    static let defaultBaseApiURL = URL(string: "https://api.unsplash.com/")!
    static let unsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"
}

struct AuthConfiguration {
    let accessKey: String
    let secretKey: String
    let redirectURI: String
    let accessScope: String
    let defaultBaseApiURL: URL
    let unsplashAuthorizeURLString: String
    
    static var standard: AuthConfiguration{
        return AuthConfiguration(accessKey: Constants.accessKey,
                                 secretKey: Constants.secretKey,
                                 redirectURI: Constants.redirectURI,
                                 accessScope: Constants.accessScope,
                                 defaultBaseApiURL: Constants.defaultBaseApiURL,
                                 unsplashAuthorizeURLString: Constants.unsplashAuthorizeURLString)
    }
}
