//
//  ProfileService.swift
//  ImageFeed
//
//  Created by Андрей Чупрыненко on 09.10.2023.
//

import Foundation

final class ProfileService {
    static let shared = ProfileService()
    private init(){}
    private let urlSession = URLSession.shared
    private var task: URLSessionTask?
    private (set) var profile: Profile?
    
    private enum NetworkError: Error {
        case codeError
    }
    
    func clean() {
        profile = nil
        task?.cancel()
        task = nil
    }
    
    func fetchProfile(_ token: String, completion: @escaping (Result<Profile, Error>) -> Void) {
        assert(Thread.isMainThread)
        
        let request = makeRequest(token: token)
        let session = URLSession.shared
        let task = session.objectTask(for: request) { [weak self] (result: Result<ProfileResult, Error>) in
            switch result {
            case .success(let decodedObject):
                let profile = Profile(decodedData: decodedObject)
                self?.profile = profile
                completion(.success(profile))
            case .failure(let error):
                completion(.failure(error))
            }
        }
        self.task = task
        task.resume()
    }
}

extension ProfileService {
    private func makeRequest(token: String) -> URLRequest {
        guard let url = URL(string: "\(Constants.defaultBaseApiURL)" + "/me") else { fatalError("Failed to create URL") }
        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
}
