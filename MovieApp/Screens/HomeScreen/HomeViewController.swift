//
//  HomeViewController.swift
//  MovieApp
//
//  Created by Yasin Çetin on 5.08.2025.
//

import UIKit
import SnapKit

final class HomeViewController: UIViewController {
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        view.addSubview(tableView)
        tableView.setup(delegate: self, cells: MovieSectionCell.self)
        tableView.registerCell(MovieSectionCell.self)
        tableView.snp.makeConstraints { $0.edges.equalToSuperview() }
        return tableView
    }()
    
    private var viewModel: HomeViewModelInterface?
    
    init(viewModel: HomeViewModelInterface?) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Filmler"
        view.backgroundColor = .white
        viewModel?.getAllSections()
        bindViewModel()
    }
    
    
    
    private func bindViewModel() {
        viewModel?.onMoviesUpdated = { [weak self] in
            self?.tableView.reloadData()
        }
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        MovieSection.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1 // her section'da 1 tane yatay collection view olacak
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        260
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        MovieSection(rawValue: section)?.title
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let section = MovieSection(rawValue: indexPath.section),
              let cell = tableView.dequeueReusableCell(withIdentifier: MovieSectionCell.identifier, for: indexPath) as? MovieSectionCell
        else { return UITableViewCell() }
        
        let movies = viewModel?.movies(for: section) ?? []
        cell.configure(with: movies)
        cell.onSelect = { [weak self] movie in
            self?.viewModel?.didSelectMovie(movie)
        }
        return cell
    }
}
