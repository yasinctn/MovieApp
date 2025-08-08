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
    private var moviesCollectionView: UICollectionView?
    
    private var viewModel: HomeViewModelInterface?

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Filmler"
        viewModel?.getMovies()
//        prepareTableView()
//        drawTableView()
//        moviesTableView.register(MovieCell.self, forCellReuseIdentifier: MovieCell.identifier)
//        updateTableView()
        prepareCollectionView()
        drawCollectionView()
        moviesCollectionView?.register(MovieCollectionViewCell.self, forCellWithReuseIdentifier: MovieCollectionViewCell.identifier)
        updateCollectionView()
    }
    
    func setViewModel(_ viewModel: HomeViewModelInterface) {
        
        self.viewModel = viewModel
        
    }
}

//MARK: - TableView
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
    
    func updateTableView() {
        self.viewModel?.onMoviesUpdated = { [weak self] in
            DispatchQueue.main.async {
                self?.moviesTableView.reloadData()
            }
        }
    }
}

//MARK: - CollectionView
extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel?.movies.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCollectionViewCell.identifier, for: indexPath) as! MovieCollectionViewCell
        if let movie = viewModel?.movies[indexPath.row] {
            let cellViewModel = MovieCellViewModel(movie: movie)
            cell.configure(with: cellViewModel)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let spacing: CGFloat = 16
        let sectionInsets: CGFloat = 16 * 2
        
        let totalSpacing = spacing + sectionInsets
        let availableWidth = collectionView.bounds.width - totalSpacing
        let numberOfItemsPerRow: CGFloat = 2
        let itemWidth = floor(availableWidth / numberOfItemsPerRow)
        
        return CGSize(width: itemWidth, height: 300)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel?.didSelectMovie(at: indexPath.item)
    }
}

extension HomeViewController {
    
    func prepareCollectionView() {
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 16
        layout.minimumInteritemSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        
        moviesCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        moviesCollectionView?.delegate = self
        moviesCollectionView?.dataSource = self
    }
    
    func drawCollectionView() {
        guard let moviesCollectionView else { return }
        view.addSubview(moviesCollectionView)
        
        moviesCollectionView.snp.makeConstraints { make in
            make.top.bottom.left.right.equalToSuperview()
        }
    }
    
    func updateCollectionView() {
        self.viewModel?.onMoviesUpdated = { [weak self] in
            DispatchQueue.main.async {
                self?.moviesCollectionView?.reloadData()
            }
        }
    }
}

