//
//  ImagesListCell.swift
//  ImageFeed
//
//  Created by Андрей Чупрыненко on 30.08.2023.
//

import Foundation
import UIKit

final class ImagesListCell: UITableViewCell {
    static let reuseIdentifier = "ImagesListCell"
    
    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak var dataLable: UILabel!
    @IBOutlet weak var likeButton: UIButton!
}
