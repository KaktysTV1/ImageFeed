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
    
    func clean(){
        photos = []
        lastLoadedPage = nil
        task?.cancel()
        task = nil
    }
//MARK: - Download image list
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
            baseURL: URL(string: "\(Constants.defaultBaseApiURL)")!)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
//MARK: - Fetch like photo
    
    func changeLike(photoId: String, isLike: Bool, _ completion: @escaping (Result<Void, Error>) -> Void){
        assert(Thread.isMainThread)
        task?.cancel()
        
        guard let token = storageToken.token else { return }
        var request: URLRequest?
        if isLike {
            request = deleteLikeRequest(token, photoId: photoId)
        } else {
            request = postLikeRequest(token, photoId: photoId)
        }
        guard let request = request else {return}
        let session = URLSession.shared
        let task = session.objectTask(for: request){[weak self] (result: Result<LikePhotoResult, Error>) in
            guard let self = self else { return }
            self.task = nil
            switch result {
            case .success(let photoResult):
                let isLiked = photoResult.photo?.isLiked ?? false
                if let index = self.photos.firstIndex(where: {$0.id == photoResult.photo?.id}) {
                    let photo = self.photos[index]
                    let newPhoto = Photo(id: photo.id,
                                         width: photo.width,
                                         height: photo.height,
                                         createdAt: photo.createdAt,
                                         welcomeDescription: photo.welcomeDescription,
                                         thumbImageURL: photo.thumbImageURL,
                                         largeImageURL: photo.largeImageURL,
                                         isLiked: isLiked)
                    self.photos = self.photos.withReplaced(itemAt: index, newValue: newPhoto)
                }
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
        self.task = task
        task.resume()
    }
    
    func postLikeRequest(_ token: String, photoId: String) -> URLRequest? {
        var requestPost = URLRequest.makeHTTPRequest(path: "photos/\(photoId)/like",
                                                     httpMethod: "POST",
                                                     baseURL: URL(string: "\(Constants.defaultBaseApiURL)")!)
        requestPost.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return requestPost
    }
    
    func deleteLikeRequest(_ token: String, photoId: String) -> URLRequest? {
        var requestDelete = URLRequest.makeHTTPRequest(path: "photos/\(photoId)/like",
                                                       httpMethod: "DELETE",
                                                       baseURL: URL(string: "\(Constants.defaultBaseApiURL)")!)
        requestDelete.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return requestDelete
    }
}

//MARK: - Extensions

extension Array {
    func withReplaced(itemAt: Int, newValue: Photo) -> [Photo] {
        var photos = ImagesListService.shared.photos
        photos.replaceSubrange(itemAt...itemAt, with: [newValue])
        return photos
    }
}
