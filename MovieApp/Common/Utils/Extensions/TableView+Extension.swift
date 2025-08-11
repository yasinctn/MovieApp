//
//  TableView + Extension.swift
//  MovieApp
//
//  Created by Yasin Çetin on 11.08.2025.
//

import Foundation
import UIKit

extension UITableView {
    func setup(
        delegate: UITableViewDelegate & UITableViewDataSource,
        cells: UITableViewCell.Type,
        separator: UITableViewCell.SeparatorStyle = .none,
        rowHeight: CGFloat = UITableView.automaticDimension,
        estimatedRowHeight: CGFloat = 120
    ) {
        self.delegate = delegate
        self.dataSource = delegate
        self.separatorStyle = separator
        self.rowHeight = rowHeight
        self.estimatedRowHeight = estimatedRowHeight
    }
}

extension UITableView {
    
    func registerCell<T: UITableViewCell>(_ cellType: T.Type) {
        self.register(cellType, forCellReuseIdentifier: String(describing: cellType))
    }
}
