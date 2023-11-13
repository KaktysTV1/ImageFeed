//
//  ViewController.swift
//  ImageFeed
//
//  Created by Андрей Чупрыненко on 27.08.2023.
//

import UIKit
import Kingfisher

protocol ImagesListViewControllerProtocol: AnyObject {
    var presenter: ImagesListViewPresenterProtocol? {get set}
    func updateTableViewAnimated()
    var photos: [Photo] {get set}
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath)
}

final class ImagesListViewController: UIViewController, ImagesListViewControllerProtocol {
    private let ShowSingleImageSegueIdentifier = "ShowSingleImage"
    
    @IBOutlet weak var tableView: UITableView!
    
    lazy var presenter: ImagesListViewPresenterProtocol? = {
        return ImageListViewPresenter()
    }()
    
    private let imagesListService = ImagesListService.shared
    var photos: [Photo] = []
    private var imagesListServiceObserver: NSObjectProtocol?
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        presenter?.view = self
        presenter?.viewDidLoad()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: ImagesListService.DidChangeNotification, object: nil)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == ShowSingleImageSegueIdentifier {
            let viewController = segue.destination as! SingleImageViewController
            let indexPath = sender as! IndexPath
            let photo = photos[indexPath.row]
            guard let imageURL = URL(string: photo.largeImageURL!) else { return }
            viewController.imageURL = imageURL
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
    
    func updateTableViewAnimated() {
        let oldCount = photos.count
        let newCount = imagesListService.photos.count
        photos = imagesListService.photos
        if oldCount != newCount {
            tableView.performBatchUpdates{
                let indexPaths = (oldCount..<newCount).map { IndexPath(row: $0, section: 0) }
                tableView.insertRows(at: indexPaths, with: .bottom)
            } completion: { _ in }
        }
    }
}

//MARK: - Extensions

extension ImagesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photos.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath)

        guard let imageListCell = cell as? ImagesListCell else {
            return UITableViewCell()
        }
        imageListCell.delegate = self
        configCell(for: imageListCell, with: indexPath)
        return imageListCell
    }
}

extension ImagesListViewController {
    private func configCell(for cell: ImagesListCell, with indexPath: IndexPath) {
        let imageUrl = photos[indexPath.row].thumbImageURL!
        let url = URL(string: imageUrl)
        let placeholder = UIImage(named: "LoaderImages")
        cell.cellImage.kf.indicatorType = .activity
        cell.cellImage.kf.setImage(with: url, placeholder: placeholder){[weak self] _ in
            guard let self = self else { return }
            self.tableView.reloadRows(at: [indexPath], with: .automatic)
            cell.cellImage.kf.indicatorType = .none
        }
        if let date = imagesListService.photos[indexPath.row].createdAt {
            cell.dataLable.text = dateFormatter.string(from: date)
        } else {
            cell.dataLable.text = ""
        }
        let isLiked = imagesListService.photos[indexPath.row].isLiked == false
        let like = isLiked ? UIImage(named: "NoActiveLikeButton") : UIImage(named: "ActiveLikeButton")
        cell.likeButton.setImage(like, for: .normal)
        cell.selectionStyle = .none
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row + 1 == imagesListService.photos.count {
            presenter?.fetchPhotosNextPage()
        }
    }
} 

extension ImagesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: ShowSingleImageSegueIdentifier, sender: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let cell = photos[indexPath.row]
        let imageSize = CGSize(width: cell.width, height: cell.height)
        let aspectRatio = imageSize.width / imageSize.height
        return tableView.frame.width / aspectRatio
    }
}

extension ImagesListViewController: ImagesListCellDelegate {
    func imageListCellDidTapLike(_ cell: ImagesListCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        let photo = photos[indexPath.row]
        UIBlockingProgressHUD.show()
        presenter?.setLike(photoId: photo.id, isLike: photo.isLiked) {result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    guard let newPhotos = self.presenter?.imagesListService.photos else {return}
                    self.photos = newPhotos
                    cell.setIsLiked(isLiked: self.photos[indexPath.row].isLiked)
                    UIBlockingProgressHUD.dismiss()
                case .failure(let error):
                    UIBlockingProgressHUD.dismiss()
                    self.showLikeErrorAlert(with: error)
                }
            }
        }
    }
    
    private func showLikeErrorAlert(with error: Error) {
        guard let alert = presenter?.showLikeErrorAlert(with: Error.self as! Error) else {return}
        present(alert, animated: true, completion: nil)
    }
}
