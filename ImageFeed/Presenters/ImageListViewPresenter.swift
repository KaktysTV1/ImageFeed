//
//  ImageListViewPresenter.swift
//  ImageFeed
//
//  Created by Андрей Чупрыненко on 06.11.2023.
//

import Foundation
import UIKit

protocol ImagesListViewPresenterProtocol {
    var view: ImagesListViewControllerProtocol? {get set}
    var imagesListService: ImagesListService {get}
    func viewDidLoad()
    func fetchPhotosNextPage()
    func setLike(photoId: String, isLike: Bool, _ completion: @escaping (Result<Void, Error>) -> Void)
    func showLikeErrorAlert(with error: Error) -> UIAlertController
}

final class ImageListViewPresenter: ImagesListViewPresenterProtocol {
    var view: ImagesListViewControllerProtocol?
    private var imagesListServiceObserver: NSObjectProtocol?
    let imagesListService = ImagesListService.shared
    
    func viewDidLoad() {
        imagesListServiceObserver = NotificationCenter.default.addObserver(
            forName: ImagesListService.DidChangeNotification,
            object: nil,
            queue: .main) { [weak self] _ in
                guard let self = self else { return }
                view?.updateTableViewAnimated()
            }
        imagesListService.fetchPhotosNextPage()
    }
    
    func fetchPhotosNextPage(){
        imagesListService.fetchPhotosNextPage()
    }
    
    func setLike(photoId: String, isLike: Bool, _ completion: @escaping (Result<Void, Error>) -> Void) {
            imagesListService.changeLike(photoId: photoId, isLike: isLike, {[weak self] result in
                guard let self = self else { return }
                switch result{
                case .success(_):
                    completion(.success(()))
                case .failure(let error):
                    completion(.failure(error))
                    print(error.localizedDescription)
                }
            })
        }
    
    func showLikeErrorAlert(with error: Error) -> UIAlertController {
        let alert = UIAlertController(
            title: "Что-то пошло не так(",
            message: "Не удалось поставить лайк",
            preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel))
        alert.dismiss(animated: true)
        return alert
    }
}
