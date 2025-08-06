//
//  HomeViewController.swift
//  MovieApp
//
//  Created by Yasin Çetin on 5.08.2025.
//

import UIKit
import SnapKit

final class HomeViewController: UIViewController {

    private lazy var moviesTableView = UITableView()
    private var viewModel: HomeViewModelInterface?

    override func viewDidLoad() {
        super.viewDidLoad()
        prepareTableView()
        drawTableView()
        moviesTableView.register(MovieCell.self, forCellReuseIdentifier: MovieCell.identifier)
        viewModel?.getMovies()
    }
    
    func setViewModel(_ viewModel: HomeViewModelInterface) {
        self.viewModel = viewModel
        
        // Bağlantı burada kurulur
        self.viewModel?.onMoviesUpdated = { [weak self] in
            DispatchQueue.main.async {
                self?.moviesTableView.reloadData()
            }
        }
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel?.didSelectMovie(at: indexPath.row)
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel?.movies.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MovieCell.identifier, for: indexPath) as! MovieCell
        if let movie = viewModel?.movies[indexPath.row] {
            let cellViewModel = MovieCellViewModel(movie: movie)
            cell.configure(with: cellViewModel)
        }
        return cell
    }
}

extension HomeViewController {
    
    func drawTableView() {
        view.addSubview(moviesTableView)
        
        moviesTableView.snp.makeConstraints { make in
            make.top.bottom.left.right.equalToSuperview()
        }
    }
    
    private func prepareTableView() {
        moviesTableView.delegate = self
        moviesTableView.dataSource = self
    }
}

