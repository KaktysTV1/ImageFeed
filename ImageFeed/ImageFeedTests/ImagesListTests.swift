//
//  ImagesListTests.swift
//  ImageFeedTests
//
//  Created by Андрей Чупрыненко on 12.11.2023.
//
@testable import ImageFeed
import XCTest
import UIKit
import Foundation

final class ImagesListTests: XCTestCase {

    func testViewControllerCallsViewDidLoad(){
        
        let imageListService = ImagesListService.shared
        let viewController = ImagesListViewController()
        let presenter = ImagesListPresenterSpy(imagesListService: imageListService)
        viewController.presenter = presenter
        presenter.view = viewController
        
        _ = viewController.view
        
        XCTAssertTrue(presenter.viewDidLoadCalled)
    }

    func testSetLike(){
        let photos: [Photo] = []
        let imagesListService = ImagesListService.shared
        let view = ImageListViewControllerSpy(photos: photos)
        let presenter = ImagesListPresenterSpy(imagesListService: imagesListService)
        view.presenter = presenter
        presenter.view = view
        
        view.setLike()
        
        XCTAssertTrue(presenter.didSetLikeCallSuccess)
    }
    
    func testLoadPhotoToTable1() {
        
        let tableView = UITableView()
        let tableCell = UITableViewCell()
        let indexPath: IndexPath = IndexPath(row: 2, section: 2)
        let photos: [Photo] = []
        let imagesListService = ImagesListService.shared
        let view = ImageListViewControllerSpy(photos: photos)
        let presenter = ImagesListPresenterSpy(imagesListService: imagesListService)
        view.presenter = presenter
        presenter.view = view
        
        view.tableView(tableView, willDisplay: tableCell, forRowAt: indexPath)
        
        XCTAssertTrue(presenter.didFetchPhotosCalled)
    }
}

final class ImagesListPresenterSpy: ImagesListViewPresenterProtocol {
   
    var view: ImagesListViewControllerProtocol?
    var viewDidLoadCalled = false
    var didFetchPhotosCalled: Bool = false
    var didSetLikeCallSuccess: Bool = false
    var imagesListService: ImageFeed.ImagesListService
    
    init(imagesListService: ImagesListService){
        self.imagesListService = imagesListService
    }
    
    func viewDidLoad() {
        viewDidLoadCalled = true
    }
    
    func fetchPhotosNextPage() {
        didFetchPhotosCalled = true
    }
    
    func checkCompletedList(_ indexPath: IndexPath) {
        fetchPhotosNextPage()
    }
    
    func setLike(photoId: String, isLike: Bool, _ completion: @escaping (Result<Void, Error>) -> Void) {
        didSetLikeCallSuccess = true
    }
    
    func showLikeErrorAlert(with error: Error) -> UIAlertController {
        UIAlertController()
    }
    
}

final class ImageListViewControllerSpy: ImagesListViewControllerProtocol {
    var presenter: ImageFeed.ImagesListViewPresenterProtocol?
    
    var photos: [ImageFeed.Photo]
    
    init(photos: [Photo]) {
        self.photos = photos
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        presenter?.fetchPhotosNextPage()
    }
    
    func setLike() {
        presenter?.setLike(photoId: "some", isLike: true)
        {[weak self ] result in
            guard let self = self else { return }
            switch result {
            case .success(_):
                break
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func updateTableViewAnimated() {
    }
}
