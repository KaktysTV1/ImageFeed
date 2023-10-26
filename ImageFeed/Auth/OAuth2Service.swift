//
//  OAuthTokenResponseBody.swift
//  ImageFeed
//
//  Created by Андрей Чупрыненко on 25.09.2023.
//

import Foundation

fileprivate let unsplashTokenURL = "https://unsplash.com/oauth/token"

final class OAuth2Service {
    static let shared = OAuth2Service()
    private init(){}
    private let urlSession = URLSession.shared
    private var task: URLSessionTask?
    private var lastCode: String?
    private (set) var authToken: String? {
        get {
            return OAuth2TokenStorage.shared.token
        }
        set {
            OAuth2TokenStorage.shared.token = newValue
        }
    }
    
    func fetchOAuthToken(_ code: String, completion: @escaping (Result<String, Error>) -> Void) {
        assert(Thread.isMainThread)
        if lastCode == code {return}
        task?.cancel()
        lastCode = code
        
        let request = authTokenRequest(code: code)
        let session = URLSession.shared
        let task = session.objectTask(for: request) {[weak self] (result: Result<OAuthTokenResponseBody, Error>) in
            guard let self = self else {return}
            switch result {
            case .success(let decodedObject):
                let authToken = decodedObject.accessToken
                self.authToken = authToken
                completion(.success(authToken))
                self.task = nil
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
        self.task = task
        task.resume()
    }
}

extension OAuth2Service {
    private func authTokenRequest(code: String) -> URLRequest {
        URLRequest.makeHTTPRequest(
            path: "/oauth/token"
            + "?client_id=\(accessKey)"
            + "&&client_secret=\(secretKey)"
            + "&&redirect_uri=\(redirectURI)"
            + "&&code=\(code)"
            + "&&grant_type=authorization_code",
            httpMethod: "POST",
            baseURL: URL(string: "https://unsplash.com")!
        )
    }
}

extension URLRequest {
    static func makeHTTPRequest(
        path: String,
        httpMethod: String,
        baseURL: URL = defaultBaseURL
    ) -> URLRequest {
        var request = URLRequest(url: URL(string: path, relativeTo: baseURL) ?? defaultBaseURL)
        request.httpMethod = httpMethod
        return request
    }
}
 
private enum NetworkError: Error {
   case codeError
}
