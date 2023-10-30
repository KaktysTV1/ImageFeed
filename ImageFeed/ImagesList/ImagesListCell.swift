//
//  ImagesListCell.swift
//  ImageFeed
//
//  Created by Андрей Чупрыненко on 30.08.2023.
//

import Foundation
import UIKit

protocol ImagesListCellDelegate: AnyObject {
    func imageListCellDidTapLike(_ cell: ImagesListCell)
}

final class ImagesListCell: UITableViewCell {
    static let reuseIdentifier = "ImagesListCell"
    weak var delegate: ImagesListCellDelegate?
    
    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak var dataLable: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    
    @IBAction private func likeButtonClicked() {
        delegate?.imageListCellDidTapLike(self)
    }
    
    override func prepareForReuse(){
        super.prepareForReuse()
        cellImage.kf.cancelDownloadTask()
    }
    
    func setIsLiked(isLiked: Bool){
        let like = isLiked ? UIImage(named: "ActiveLikeButton") : UIImage(named: "NoActiveLikeButton")
        likeButton.imageView?.image = like
        likeButton.setImage(like, for: .normal)
    }
}
