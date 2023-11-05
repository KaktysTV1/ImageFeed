//
//  AuthHelper.swift
//  ImageFeed
//
//  Created by Андрей Чупрыненко on 05.11.2023.
//

import Foundation

protocol AuthHelperProtocol {
    func authRequest() -> URLRequest
    func code(from url: URL) -> String?
}

final class AuthHelper: AuthHelperProtocol {
    func authRequest() -> URLRequest {
        let url = authURL()
        return URLRequest(url: url)
    }
    
    func code(from url: URL) -> String? {
        if
            let urlComponents = URLComponents(string: url.absoluteString),
            urlComponents.path == "/oauth/authorize/native",
            let items = urlComponents.queryItems,
            let codeItem = items.first(where: { $0.name == "code" })
        {
            return codeItem.value
        } else {
            return nil
        }
    }
    
    func authURL() -> URL {
        var urlComponents = URLComponents(string: configuration.unsplashAuthorizeURLString)!
            urlComponents.queryItems = [
                URLQueryItem(name: "client_id", value: configuration.accessKey),
                URLQueryItem(name: "redirect_uri", value: configuration.redirectURI),
                URLQueryItem(name: "response_type", value: "code"),
                URLQueryItem(name: "scope", value: configuration.accessScope)
            ]
            return urlComponents.url!
    }
    
    let configuration: AuthConfiguration
    
    init(configuration: AuthConfiguration = .standard){
        self.configuration = configuration
    }
}
