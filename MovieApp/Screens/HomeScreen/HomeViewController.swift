//
//  HomeViewController.swift
//  MovieApp
//
//  Created by Yasin Çetin on 5.08.2025.
//

import UIKit
import SnapKit

final class HomeViewController: UIViewController {
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createCompositionalLayout())
        collectionView.backgroundColor = .systemBackground
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsVerticalScrollIndicator = false
        
        // Register cells and headers
        collectionView.register(MovieCollectionViewCell.self, forCellWithReuseIdentifier: MovieCollectionViewCell.identifier)
        collectionView.register(MovieSectionHeaderView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: MovieSectionHeaderView.reuseId)
        
        return collectionView
    }()
    
    private var viewModel: HomeViewModelInterface
    
    init(viewModel: HomeViewModelInterface) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
        viewModel.getAllSections()
    }
    
    private func setupUI() {
        title = "Movies"
        view.backgroundColor = .systemBackground
        
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func bindViewModel() {
        viewModel.onMoviesUpdated = { [weak self] in
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
            }
        }
    }
    
    // MARK: - Compositional Layout
    private func createCompositionalLayout() -> UICollectionViewLayout {
        UICollectionViewCompositionalLayout { [weak self] sectionIndex, _ in
            guard let self = self else { return nil }
            let sectionType = self.viewModel.getSection(at: sectionIndex)
            return self.layoutSection(for: sectionType)
        }
    }
    
    private func layoutSection(for sectionType: MovieSectionType) -> NSCollectionLayoutSection {
        switch sectionType {
        case .popular:
            return CompositionalLayoutManager.shared.createLayoutSection(layoutType: .horizontal(isFeatured: true))
        case .topRated, .upcoming, .nowPlaying:
            return CompositionalLayoutManager.shared.createLayoutSection(layoutType: .horizontal(isFeatured: false))
        }
    }
}

// MARK: - UICollectionViewDataSource
extension HomeViewController: UICollectionViewDataSource {
    
    // Kaç section var?
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel.getSectionsCount()
    }
    
    // Her section'daki item sayısı: O section'ın filmlerinin sayısı olmalı
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let sectionType = viewModel.getSection(at: section)
        return viewModel.movies(for: sectionType).count
    }
    
    // Hücreyi doldur
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCollectionViewCell.identifier, for: indexPath) as? MovieCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let sectionType = viewModel.getSection(at: indexPath.section)
        let items = viewModel.movies(for: sectionType)
        guard indexPath.item < items.count else { return cell }
        
        let movie = items[indexPath.item]
        let movieViewModel = MovieCellViewModel(movie: movie)
        cell.configure(with: movieViewModel)
        return cell
    }
    
    // Header
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader,
              let header = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: MovieSectionHeaderView.reuseId,
                for: indexPath
              ) as? MovieSectionHeaderView else {
            return UICollectionReusableView()
        }
        
        let sectionType = viewModel.getSection(at: indexPath.section)
        header.configure(title: sectionType.title) { [weak self] in
            self?.viewModel.didTapShowAll(for: sectionType)
        }
        return header
    }
    
}

// MARK: - UICollectionViewDelegate
extension HomeViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let sectionType = viewModel.getSection(at: indexPath.section)
        let items = viewModel.movies(for: sectionType)
        
        if let movie = items[safe: indexPath.item] {
            viewModel.didSelectMovie(movie)
        }
        
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}
