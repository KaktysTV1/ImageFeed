//
//  ViewController.swift
//  ImageFeed
//
//  Created by Андрей Чупрыненко on 27.08.2023.
//

import UIKit

class ImagesListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        tableView.dataSource = self
    }
}

extension ImagesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath)

        guard let imageListCell = cell as? ImagesListCell else {
            return UITableViewCell()
        }

        configCell(for: imageListCell, with: indexPath)

        return imageListCell
    }
}

extension ImagesListViewController {
    func configCell(for cell: ImagesListCell, with indexPath: IndexPath) { }
}

extension ImagesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {}
}
