//
//  ImageListService.swift
//  ImageFeed
//
//  Created by Андрей Чупрыненко on 26.10.2023.
//

import Foundation

final class ImagesListService {
    static let DidChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")
    static let shared = ImagesListService()
    private init(){}
    private (set) var photos: [Photo] = []
    private var lastLoadedPage: Int?
    private let perPage = "10"
    private var task: URLSessionTask?
    private let storageToken = OAuth2TokenStorage.shared
    private let dateFormatter = ISO8601DateFormatter()
    
    func updatePhotos(_ photos: [Photo]) {
             self.photos = photos
         }
    
    func fetchPhotosNextPage() {
        assert(Thread.isMainThread)
        guard task == nil else { return }
        
        let page = lastLoadedPage == nil ? 1 : lastLoadedPage! + 1
        guard let token = storageToken.token else { return }
        guard let request = fetchImagesListRequest(token, page: String(page), perPage: perPage) else { return }
        let task = URLSession.shared.objectTask(for: request) { [weak self] (result: Result<[PhotoResult], Error>) in
            DispatchQueue.main.async {
                guard let self = self else { return }
                switch result {
                case .success(let photoResults):
                    for photoResult in photoResults {
                        self.photos.append(self.convert(photoResult))
                    }
                    self.lastLoadedPage = page
                    NotificationCenter.default
                        .post(
                            name: ImagesListService.DidChangeNotification,
                            object: self,
                            userInfo: ["Images" : self.photos])
                case .failure(let error):
                    assertionFailure("Ошибка получения изображений \(error)")
                }
                self.task = nil
            }
        }
        self.task = task
        task.resume()
    }
    
    private func convert(_ photoResult: PhotoResult) -> Photo {
        
        return Photo.init(id: photoResult.id,
                          width: CGFloat(photoResult.width),
                          height: CGFloat(photoResult.height),
                          createdAt: self.dateFormatter.date(from:photoResult.createdAt ?? ""),
                          welcomeDescription: photoResult.welcomeDescription,
                          thumbImageURL: photoResult.urls?.thumbImageURL,
                          largeImageURL: photoResult.urls?.largeImageURL,
                          isLiked: photoResult.isLiked ?? false)
    }
    
    private func fetchImagesListRequest(_ token: String, page: String, perPage: String) -> URLRequest? {
        var request = URLRequest.makeHTTPRequest(
            path: "/photos?page=\(page)&&per_page=\(perPage)",
            httpMethod: "GET",
            baseURL: URL(string: "\(defaultBaseApiURL)")!)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
}



extension Array {
    func withReplaced(itemAt: Int, newValue: Photo) -> [Photo] {
        var photos = ImagesListService.shared.photos
        photos.replaceSubrange(itemAt...itemAt, with: [newValue])
        return photos
    }
}
