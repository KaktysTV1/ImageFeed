//
//  ViewController.swift
//  ImageFeed
//
//  Created by Андрей Чупрыненко on 27.08.2023.
//

import UIKit

class ImagesListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        tableView.dataSource = self
        
        tableView.register(ImagesListCell.self, forCellReuseIdentifier: ImagesListCell.reuseIdentifier)
    }
}

extension ImagesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func configCell(for cell: ImagesListCell) { }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath) // 1
            
            guard let imageListCell = cell as? ImagesListCell else { // 2
                return UITableViewCell()
            }
            
            configCell(for: imageListCell) // 3
            return imageListCell // 4
        }
}

extension ImagesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) { }
}
