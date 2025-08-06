//
//  DetailViewController.swift
//  MovieApp
//
//  Created by Yasin Çetin on 5.08.2025.
//

import UIKit

protocol DetailViewInterface: AnyObject {
    
}

final class DetailViewController: UIViewController {
    
    private var backdropImageView = UIImageView()
    private var voteLabel = UILabel()
    private var overviewLabel = UILabel()
    
    
    private var movie: MovieDTO?
    private var viewModel: DetailViewModelProtocol?
    
    func setMovie(_ movie: MovieDTO) {
        self.movie = movie
    }
    
    func setViewModel(_ viewModel: DetailViewModelProtocol) {
        self.viewModel = viewModel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        configure()
        
    }
}

extension DetailViewController {
    
    func configure() {
        if let movie {
            
            backdropImageView.sd_setImage(with: viewModel?.getImageUrl(for: movie.backdropPath), placeholderImage: UIImage(systemName: "photo"))
            
            overviewLabel.text = movie.overview
            voteLabel.text = "⭐️ \(movie.voteAverage)"
            
            
        }
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        title = movie?.title
        view.addSubview(backdropImageView)
        view.addSubview(voteLabel)
        view.addSubview(overviewLabel)
        
        overviewLabel.font = .systemFont(ofSize: 14)
        overviewLabel.numberOfLines = 0
        overviewLabel.lineBreakMode = .byWordWrapping
        overviewLabel.textColor = .darkGray
        
        voteLabel.textColor = .yellow
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        backdropImageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.left.right.equalToSuperview()
            make.height.equalTo(view.snp.height).multipliedBy(0.3)
        }

        overviewLabel.snp.makeConstraints { make in
            make.top.equalTo(backdropImageView.snp.bottom).offset(16)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-80)
        }

        voteLabel.snp.makeConstraints { make in
            make.centerY.equalTo(backdropImageView.snp.bottom)
            make.left.equalTo(overviewLabel.snp.right).offset(8)
            make.right.equalToSuperview().offset(-16)
        }

        
    }
    
   

}



extension DetailViewController: DetailViewInterface {
    
}

