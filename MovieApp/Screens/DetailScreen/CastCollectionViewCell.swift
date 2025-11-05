//
//  CastCollectionViewCell.swift
//  MovieApp
//
//  Created by Claude Code
//

import UIKit
import SDWebImage
import SnapKit

final class CastCollectionViewCell: UICollectionViewCell {

    static let identifier = "CastCollectionViewCell"

    // MARK: - UI Components
    private let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 40
        iv.backgroundColor = .secondarySystemBackground
        return iv
    }()

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .semibold)
        label.textColor = .label
        label.textAlignment = .center
        label.numberOfLines = 2
        return label
    }()

    private let characterLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 11, weight: .regular)
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        label.numberOfLines = 2
        return label
    }()

    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup
    private func setupUI() {
        contentView.addSubview(profileImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(characterLabel)

        profileImageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
            make.width.height.equalTo(80)
        }

        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.bottom).offset(8)
            make.left.right.equalToSuperview().inset(4)
        }

        characterLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(2)
            make.left.right.equalToSuperview().inset(4)
            make.bottom.lessThanOrEqualToSuperview()
        }
    }

    // MARK: - Configuration
    func configure(with cast: Cast) {
        nameLabel.text = cast.name
        characterLabel.text = cast.character

        if let profileURL = cast.profileURL {
            profileImageView.sd_setImage(
                with: profileURL,
                placeholderImage: UIImage(systemName: "person.circle.fill")
            )
        } else {
            profileImageView.image = UIImage(systemName: "person.circle.fill")
            profileImageView.tintColor = .systemGray3
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        profileImageView.sd_cancelCurrentImageLoad()
        profileImageView.image = nil
        nameLabel.text = nil
        characterLabel.text = nil
    }
}
