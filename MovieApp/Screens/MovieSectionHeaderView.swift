//
//  MovieSectionHeaderView.swift
//  MovieApp
//
//  Created by Yasin Çetin on 11.08.2025.
//

import UIKit
import SnapKit

final class MovieSectionHeaderView: UICollectionReusableView {
    
    static let reuseId = "MovieSectionHeaderView"
    
    private let titleLabel = UILabel()
    private let showAllButton = UIButton(type: .system)
    
    private var onShowAllTapped: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = .systemBackground
        
        setupTitleLabel()
        setupShowAllButton()
        makeConstraints()
    }
    
    private func setupTitleLabel() {
        titleLabel.font = UIFont.boldSystemFont(ofSize: 20)
        titleLabel.textColor = .label
        titleLabel.numberOfLines = 1
        addSubview(titleLabel)
    }
    
    private func setupShowAllButton() {
        showAllButton.setTitle("Show All", for: .normal)
        showAllButton.setTitleColor(.systemBlue, for: .normal)
        showAllButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        showAllButton.addTarget(self, action: #selector(showAllButtonTapped), for: .touchUpInside)
        addSubview(showAllButton)
    }
    
    private func makeConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
            make.trailing.lessThanOrEqualTo(showAllButton.snp.leading).offset(-16)
        }
        
        showAllButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-16)
            make.centerY.equalToSuperview()
            make.width.greaterThanOrEqualTo(60)
        }
    }
    
    func configure(title: String, onShowAllTapped: @escaping () -> Void) {
        titleLabel.text = title
        self.onShowAllTapped = onShowAllTapped
    }
    
    @objc private func showAllButtonTapped() {
        onShowAllTapped?()
    }
}
