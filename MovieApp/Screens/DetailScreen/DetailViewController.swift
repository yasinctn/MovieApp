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
    
    private var viewModel: DetailViewModelProtocol?
    
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
        viewModel?.onMovieDetailUpdated = { [weak self] in
            guard let self else { return }
            backdropImageView.sd_setImage(with: viewModel?.movieDetail?.backdropImageURL, placeholderImage: UIImage(systemName: "photo"))
                
            overviewLabel.text = viewModel?.movieDetail?.overview
            voteLabel.text = viewModel?.movieDetail?.voteAverageText
            title = viewModel?.movieDetail?.title
        }
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        
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
            make.left.equalToSuperview().offset(5)
            make.right.equalToSuperview().offset(-5)
            make.height.equalTo(view.snp.height).multipliedBy(0.3)
        }

        overviewLabel.snp.makeConstraints { make in
            make.top.equalTo(voteLabel.snp.bottom).offset(16)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
        }

        voteLabel.snp.makeConstraints { make in
            make.centerY.equalTo(backdropImageView.snp.bottom)
            make.right.equalToSuperview().offset(-16)
        }
    }
}



extension DetailViewController: DetailViewInterface {
    
}

