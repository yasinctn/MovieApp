//
//  MovieCell.swift
//  MovieApp
//
//  Created by Yasin Çetin on 5.08.2025.
//

import UIKit
import SDWebImage

final class MovieCell: UITableViewCell {
    
    static let identifier = "MovieCell"

    private let posterImageView = UIImageView()
    private let titleLabel = UILabel()
    private let voteLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
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
        
        makeConstraints()
        
    }
    
    private func makeConstraints() {
        posterImageView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview().offset(8)
            make.right.equalToSuperview().offset(-8)
            make.width.equalTo(200)
            make.height.equalTo(200)
        }

        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(posterImageView.snp.bottom).offset(12)
            make.left.equalToSuperview().offset(8)
            make.right.lessThanOrEqualTo(voteLabel.snp.left).offset(-8)
            make.bottom.equalToSuperview().offset(-8)
        }

        voteLabel.snp.makeConstraints { make in
            make.centerY.equalTo(titleLabel) // Aynı dikey hizada tut
            make.right.equalToSuperview().offset(-8)
        }
    }
}
