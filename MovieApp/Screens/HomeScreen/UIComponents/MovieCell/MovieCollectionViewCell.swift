//
//  MovieCollectionViewCell.swift
//  MovieApp
//
//  Created by Yasin Çetin on 7.08.2025.
//

import UIKit
import SDWebImage
import SnapKit

final class MovieCollectionViewCell: UICollectionViewCell {

    static let identifier = "MovieCollectionViewCell"

    // Card container (shadow + corner)
    private let cardView: UIView = {
        let v = UIView()
        v.layer.cornerRadius = 14
        v.layer.masksToBounds = false
        v.backgroundColor = .secondarySystemBackground
        // Shadow
        v.layer.shadowColor = UIColor.black.cgColor
        v.layer.shadowOpacity = 0.12
        v.layer.shadowOffset = CGSize(width: 0, height: 4)
        v.layer.shadowRadius = 10
        return v
    }()

    private let posterImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 14
        return iv
    }()

    // Alt tarafta okunurluk için gradient
    private let gradientLayer = CAGradientLayer()

    // Rating badge (üst sağ)
    private let ratingContainer: UIVisualEffectView = {
        let blur = UIBlurEffect(style: .systemUltraThinMaterialDark)
        let v = UIVisualEffectView(effect: blur)
        v.layer.cornerRadius = 12
        v.layer.masksToBounds = true
        return v
    }()
    private let starImageView: UIImageView = {
        let iv = UIImageView(image: UIImage(systemName: "star.fill"))
        iv.contentMode = .scaleAspectFit
        iv.tintColor = .systemYellow
        return iv
    }()
    private let ratingLabel: UILabel = {
        let l = UILabel()
        l.font = .systemFont(ofSize: 12, weight: .semibold)
        l.textColor = .white
        return l
    }()

    // Bottom info
    private let titleLabel: UILabel = {
        let l = UILabel()
        l.font = .systemFont(ofSize: 15, weight: .semibold)
        l.numberOfLines = 2
        l.textColor = .white
        return l
    }()
    private let metaLabel: UILabel = {
        let l = UILabel()
        l.font = .systemFont(ofSize: 12, weight: .regular)
        l.textColor = .white.withAlphaComponent(0.9)
        l.numberOfLines = 1
        return l
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = posterImageView.bounds
        // poster corner radius ile uyumlu olsun
        gradientLayer.cornerCurve = .continuous
        gradientLayer.cornerRadius = posterImageView.layer.cornerRadius
        // shadow path performansı
        cardView.layer.shadowPath = UIBezierPath(roundedRect: cardView.bounds, cornerRadius: 14).cgPath
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        posterImageView.sd_cancelCurrentImageLoad()
        posterImageView.image = nil
        titleLabel.text = nil
        metaLabel.text = nil
        ratingLabel.text = nil
    }

    func configure(with vm: MovieCellViewModel) {
        titleLabel.text = vm.title
        metaLabel.text = vm.metaText
        ratingLabel.text = vm.ratingText
        posterImageView.sd_setImage(
            with: vm.imageURL,
            placeholderImage: UIImage(systemName: "photo")
        )
    }

    private func setupUI() {
        contentView.addSubview(cardView)
        cardView.addSubview(posterImageView)
        posterImageView.layer.addSublayer(gradientLayer)

        // Gradient ayarı (alttan yukarı saydamlık)
        gradientLayer.colors = [
            UIColor.black.withAlphaComponent(0.0).cgColor,
            UIColor.black.withAlphaComponent(0.55).cgColor
        ]
        gradientLayer.locations = [0.55, 1.0]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)

        // Rating badge
        contentView.addSubview(ratingContainer)
        let ratingStack = UIStackView(arrangedSubviews: [starImageView, ratingLabel])
        ratingStack.axis = .horizontal
        ratingStack.alignment = .center
        ratingStack.spacing = 4
        ratingContainer.contentView.addSubview(ratingStack)

        // Bottom labels
        posterImageView.addSubview(titleLabel)
        posterImageView.addSubview(metaLabel)

        // MARK: Constraints
        cardView.snp.makeConstraints { make in
            make.edges.equalToSuperview() // dışarıda spacing istiyorsan cell size ile ver
        }

        // Poster 2:3 oranına yakın sabitleyelim (yükseklik dıştan geliyor olabilir)
        posterImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            // İstersen oran:
            // make.height.equalTo(posterImageView.snp.width).multipliedBy(1.5)
        }

        ratingContainer.snp.makeConstraints { make in
            make.top.equalTo(cardView).offset(8)
            make.trailing.equalTo(cardView).inset(8)
            make.height.equalTo(24)
        }

        ratingStack.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(8)
        }
        starImageView.snp.makeConstraints { make in
            make.width.height.equalTo(14)
        }

        titleLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(10)
            make.bottom.equalTo(metaLabel.snp.top).offset(-2)
        }

        metaLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(10)
            make.bottom.equalToSuperview().inset(10)
        }
    }
}
