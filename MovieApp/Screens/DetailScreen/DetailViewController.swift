//
//  DetailViewController.swift
//  MovieApp
//
//  Created by Yasin Çetin on 5.08.2025.
//

import UIKit

final class DetailViewController: UIViewController {
    
    private var backdropImageView = UIImageView()
    private var voteLabel = UILabel()
    private var overviewLabel = UILabel()
    private var posterImageView = UIImageView()
    
    private var viewModel: DetailViewModelProtocol?
    
    init(viewModel: DetailViewModelProtocol?) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
            posterImageView.sd_setImage(with: viewModel?.movieDetail?.posterURL, placeholderImage: UIImage(systemName:"photo"))
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
        view.addSubview(posterImageView)
        
        overviewLabel.font = .systemFont(ofSize: 14)
        overviewLabel.numberOfLines = 0
        overviewLabel.lineBreakMode = .byWordWrapping
        overviewLabel.textColor = .darkGray
        
        voteLabel.textColor = .yellow
        
        posterImageView.layer.cornerRadius = 12
        posterImageView.clipsToBounds = true
        posterImageView.contentMode = .scaleAspectFill
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        makeBackdropImageConstraints()
        makeOverviewLabelConstraints()
        makePosterImageConstraints()
        makeVoteLabelConstraints()
    }
    
    private func makeVoteLabelConstraints() {
        voteLabel.snp.makeConstraints { make in
            make.centerY.equalTo(backdropImageView.snp.bottom)
            make.right.equalToSuperview().offset(-16)
        }
    }
    
    private func makeBackdropImageConstraints() {
        backdropImageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.left.equalToSuperview().offset(5)
            make.right.equalToSuperview().offset(-5)
            make.height.equalTo(view.snp.height).multipliedBy(0.3)
        }
    }
    
    private func makePosterImageConstraints() {
        posterImageView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.bottom.equalTo(backdropImageView.snp.bottom).offset(40)
            make.width.equalTo(120)
            make.height.equalTo(180)
        }
    }
    
    private func makeOverviewLabelConstraints() {
        overviewLabel.snp.makeConstraints { make in
            make.top.equalTo(posterImageView.snp.bottom).offset(16)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
        }
    }
    
    
}
