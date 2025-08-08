//
//  MovieCollectionViewCell.swift
//  MovieApp
//
//  Created by Yasin Çetin on 7.08.2025.
//

import UIKit
import SDWebImage

final class MovieCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "MovieCollectionViewCell"

    private let posterImageView = UIImageView()
    private let titleLabel = UILabel()
    private let voteLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with viewModel: MovieCellViewModel) {
        titleLabel.text = viewModel.title
        voteLabel.text = viewModel.voteAverageText
        posterImageView.sd_setImage(with: viewModel.imageURL, placeholderImage: UIImage(systemName: "photo"))
    }

    private func setupUI() {
        contentView.addSubview(posterImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(voteLabel)
        
        posterImageView.contentMode = .scaleAspectFill
        posterImageView.clipsToBounds = true
        posterImageView.layer.cornerRadius = 8
        
        titleLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        titleLabel.numberOfLines = 2
        titleLabel.textAlignment = .left
        
        voteLabel.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        voteLabel.textColor = .systemOrange
        voteLabel.textAlignment = .right
        
        contentView.layer.cornerRadius = 8
        contentView.layer.shadowColor = UIColor.black.cgColor
        contentView.layer.shadowOffset = CGSize(width: 0, height: 2)
        contentView.layer.shadowRadius = 4
        contentView.layer.shadowOpacity = 0.1
        contentView.backgroundColor = .systemBackground
        
        makeConstraints()
    }
    
    private func makeConstraints() {
        posterImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.left.right.equalToSuperview().inset(8)
            make.height.equalTo(200)
        }

        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(posterImageView.snp.bottom).offset(8)
            make.left.right.equalToSuperview().inset(8)
        }

        voteLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.right.equalToSuperview().offset(-8)
            make.bottom.lessThanOrEqualToSuperview().offset(-8)
        }
    }

}
