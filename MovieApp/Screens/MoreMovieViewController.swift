//
//  MoreMovieViewController.swift
//  MovieApp
//
//  Created by Yasin Çetin on 8.08.2025.
//

import Foundation
import UIKit
import SnapKit

final class MoreMovieViewController: UIViewController {

    
    private lazy var moviesCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 16
        layout.minimumInteritemSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        
        return UICollectionView(frame: .zero, collectionViewLayout: layout)
    }()
    
    private var viewModel: MoreMovieViewModelInterface?

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Filmler"
        // değişecek
        prepareCollectionView()
        makeConstraints()
        moviesCollectionView.register(MovieCollectionViewCell.self, forCellWithReuseIdentifier: MovieCollectionViewCell.identifier)
        updateCollectionView()
    }
    
    init(viewModel: MoreMovieViewModelInterface?) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func prepareCollectionView() {
        moviesCollectionView.delegate = self
        moviesCollectionView.dataSource = self
    }
}

//MARK: - CollectionView
extension MoreMovieViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
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

extension MoreMovieViewController {
    
    func makeConstraints() {
        
        view.addSubview(moviesCollectionView)
        
        moviesCollectionView.snp.makeConstraints { make in
            make.top.bottom.left.right.equalToSuperview()
        }
    }
    
    func updateCollectionView() {
        self.viewModel?.onMoviesUpdated = { [weak self] in
            DispatchQueue.main.async {
                self?.moviesCollectionView.reloadData()
            }
        }
    }
}

