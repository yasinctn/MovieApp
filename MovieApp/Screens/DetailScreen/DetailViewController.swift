//
//  DetailViewController.swift
//  MovieApp
//
//  Created by Yasin Çetin on 5.08.2025.
//

import UIKit

final class DetailViewController: UIViewController {
    
    private var scrollView = UIScrollView()
    private var contentView = UIView()
    private var backdropImageView = UIImageView()
    private var voteLabel = UILabel()
    private var overviewLabel = UILabel()
    private var posterImageView = UIImageView()
    private var loadingIndicator = UIActivityIndicatorView(style: .large)
    private var errorView = UIView()
    private var errorLabel = UILabel()
    private var retryButton = UIButton(type: .system)
    private var taglineLabel = UILabel()
    private var genresStackView = UIStackView()
    private var infoStackView = UIStackView()
    private var runtimeLabel = UILabel()
    private var releaseDateLabel = UILabel()
    private var overviewTitleLabel = UILabel()
    private lazy var favoriteButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .systemRed
        let config = UIImage.SymbolConfiguration(pointSize: 22, weight: .semibold)
        button.setImage(UIImage(systemName: "heart", withConfiguration: config), for: .normal)
        button.setImage(UIImage(systemName: "heart.fill", withConfiguration: config), for: .selected)
        button.addTarget(self, action: #selector(favoriteButtonTapped), for: .touchUpInside)
        return button
    }()

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
        setupNavigationBar()
        configure()
    }

    @objc private func favoriteButtonTapped() {
        guard let movieDetail = viewModel?.movieDetail else { return }

        // Convert MovieDetail to Movie for favorites
        let movie = Movie(
            id: movieDetail.id,
            title: movieDetail.title ?? "",
            overview: movieDetail.overview,
            posterURL: movieDetail.posterURL,
            backdropImageURL: movieDetail.backdropImageURL,
            voteAverage: Double(movieDetail.voteAverageText.replacingOccurrences(of: "⭐️ ", with: "")) ?? 0.0,
            voteCount: 0,
            releaseDateString: movieDetail.releaseDate,
            originalLanguageCode: nil
        )

        FavoritesService.shared.toggleFavorite(movie: movie)
        updateFavoriteButtonState()
    }

    private func setupNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: favoriteButton)
    }

    private func updateFavoriteButtonState() {
        guard let movieDetail = viewModel?.movieDetail else { return }
        favoriteButton.isSelected = FavoritesService.shared.isFavorite(movieId: movieDetail.id)
    }
    
}

extension DetailViewController {
    
    func configure() {
        viewModel?.onMovieDetailUpdated = { [weak self] in
            guard let self else { return }
            self.loadingIndicator.stopAnimating()
            self.errorView.isHidden = true
            guard let movieDetail = viewModel?.movieDetail else { return }

            backdropImageView.sd_setImage(with: movieDetail.backdropImageURL, placeholderImage: UIImage(systemName: "photo"))
            posterImageView.sd_setImage(with: movieDetail.posterURL, placeholderImage: UIImage(systemName:"photo"))
            overviewLabel.text = movieDetail.overview
            voteLabel.text = movieDetail.voteAverageText
            title = movieDetail.title

            // Update favorite button state
            updateFavoriteButtonState()

            // Tagline
            if let tagline = movieDetail.tagline {
                taglineLabel.text = tagline
                taglineLabel.isHidden = false
            } else {
                taglineLabel.isHidden = true
            }

            // Genres
            setupGenres(genres: movieDetail.genres)

            // Runtime and Release Date
            setupMovieInfo(runtime: movieDetail.runtimeText, releaseDate: movieDetail.releaseDateFormatted)
        }

        viewModel?.onLoadingStateChanged = { [weak self] isLoading in
            guard let self else { return }
            if isLoading {
                self.loadingIndicator.startAnimating()
                self.errorView.isHidden = true
            } else {
                self.loadingIndicator.stopAnimating()
            }
        }

        viewModel?.onError = { [weak self] errorMessage in
            guard let self else { return }
            self.showError(message: errorMessage)
        }
    }

    private func setupGenres(genres: [String]) {
        // Clear existing genre tags
        genresStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }

        guard !genres.isEmpty else {
            genresStackView.isHidden = true
            return
        }

        genresStackView.isHidden = false
        genres.prefix(3).forEach { genre in
            let label = createGenreLabel(text: genre)
            genresStackView.addArrangedSubview(label)
        }
    }

    private func createGenreLabel(text: String) -> UIView {
        let containerView = UIView()
        let label = UILabel()
        label.text = text
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textColor = .white
        label.textAlignment = .center

        containerView.backgroundColor = .systemBlue.withAlphaComponent(0.8)
        containerView.layer.cornerRadius = 12
        containerView.clipsToBounds = true

        containerView.addSubview(label)
        label.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(4)
            make.bottom.equalToSuperview().offset(-4)
            make.left.equalToSuperview().offset(12)
            make.right.equalToSuperview().offset(-12)
        }

        return containerView
    }

    private func setupMovieInfo(runtime: String?, releaseDate: String?) {
        var infoTexts: [String] = []

        if let releaseDate = releaseDate {
            infoTexts.append(releaseDate)
        }

        if let runtime = runtime {
            infoTexts.append(runtime)
        }

        if !infoTexts.isEmpty {
            let infoText = infoTexts.joined(separator: " • ")
            runtimeLabel.text = infoText
            infoStackView.isHidden = false
        } else {
            infoStackView.isHidden = true
        }
    }

    private func showError(message: String) {
        errorLabel.text = message
        errorView.isHidden = false
    }

    @objc private func retryButtonTapped() {
        viewModel?.retry()
    }
    
    private func setupUI() {

        view.backgroundColor = .systemBackground

        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(backdropImageView)
        contentView.addSubview(voteLabel)
        contentView.addSubview(posterImageView)
        contentView.addSubview(taglineLabel)
        contentView.addSubview(genresStackView)
        contentView.addSubview(infoStackView)
        contentView.addSubview(overviewTitleLabel)
        contentView.addSubview(overviewLabel)
        view.addSubview(loadingIndicator)
        view.addSubview(errorView)

        scrollView.showsVerticalScrollIndicator = true
        scrollView.alwaysBounceVertical = true

        backdropImageView.contentMode = .scaleAspectFill
        backdropImageView.clipsToBounds = true

        overviewLabel.font = .systemFont(ofSize: 15)
        overviewLabel.numberOfLines = 0
        overviewLabel.lineBreakMode = .byWordWrapping
        overviewLabel.textColor = .secondaryLabel

        overviewTitleLabel.text = "Overview"
        overviewTitleLabel.font = .systemFont(ofSize: 18, weight: .bold)
        overviewTitleLabel.textColor = .label

        voteLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        voteLabel.textColor = .systemOrange
        voteLabel.backgroundColor = .secondarySystemBackground
        voteLabel.layer.cornerRadius = 8
        voteLabel.clipsToBounds = true
        voteLabel.textAlignment = .center
        voteLabel.snp.makeConstraints { make in
            make.width.greaterThanOrEqualTo(60)
            make.height.equalTo(32)
        }

        posterImageView.layer.cornerRadius = 12
        posterImageView.clipsToBounds = true
        posterImageView.contentMode = .scaleAspectFill
        posterImageView.layer.shadowColor = UIColor.black.cgColor
        posterImageView.layer.shadowOffset = CGSize(width: 0, height: 4)
        posterImageView.layer.shadowOpacity = 0.3
        posterImageView.layer.shadowRadius = 8

        taglineLabel.font = .systemFont(ofSize: 14, weight: .medium)
        taglineLabel.textColor = .systemGray
        taglineLabel.numberOfLines = 3
        taglineLabel.textAlignment = .left
        taglineLabel.isHidden = true

        genresStackView.axis = .horizontal
        genresStackView.spacing = 8
        genresStackView.distribution = .fillProportionally
        genresStackView.isHidden = true

        infoStackView.axis = .vertical
        infoStackView.spacing = 4
        infoStackView.isHidden = true
        infoStackView.addArrangedSubview(runtimeLabel)

        runtimeLabel.font = .systemFont(ofSize: 14, weight: .regular)
        runtimeLabel.textColor = .systemGray
        runtimeLabel.numberOfLines = 1

        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.color = .systemBlue

        setupErrorView()
        setupConstraints()
    }

    private func setupErrorView() {
        errorView.isHidden = true
        errorView.backgroundColor = .systemBackground

        errorView.addSubview(errorLabel)
        errorView.addSubview(retryButton)

        errorLabel.font = .systemFont(ofSize: 16, weight: .medium)
        errorLabel.textColor = .secondaryLabel
        errorLabel.textAlignment = .center
        errorLabel.numberOfLines = 0

        retryButton.setTitle("Tekrar Dene", for: .normal)
        retryButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        retryButton.backgroundColor = .systemBlue
        retryButton.setTitleColor(.white, for: .normal)
        retryButton.layer.cornerRadius = 8
        retryButton.addTarget(self, action: #selector(retryButtonTapped), for: .touchUpInside)

        errorLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview().offset(-30)
            make.left.equalToSuperview().offset(40)
            make.right.equalToSuperview().offset(-40)
        }

        retryButton.snp.makeConstraints { make in
            make.top.equalTo(errorLabel.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.width.equalTo(140)
            make.height.equalTo(44)
        }
    }

    private func setupConstraints() {
        makeScrollViewConstraints()
        makeContentViewConstraints()
        makeBackdropImageConstraints()
        makePosterImageConstraints()
        makeVoteLabelConstraints()
        makeTaglineLabelConstraints()
        makeGenresStackViewConstraints()
        makeInfoStackViewConstraints()
        makeOverviewTitleLabelConstraints()
        makeOverviewLabelConstraints()
        makeLoadingIndicatorConstraints()
        makeErrorViewConstraints()
    }

    private func makeScrollViewConstraints() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }

    private func makeContentViewConstraints() {
        contentView.snp.makeConstraints { make in
            make.edges.equalTo(scrollView)
            make.width.equalTo(scrollView)
        }
    }

    private func makeLoadingIndicatorConstraints() {
        loadingIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }

    private func makeErrorViewConstraints() {
        errorView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    private func makeVoteLabelConstraints() {
        voteLabel.snp.makeConstraints { make in
            make.centerY.equalTo(backdropImageView.snp.bottom)
            make.right.equalTo(contentView).offset(-16)
        }
    }

    private func makeBackdropImageConstraints() {
        backdropImageView.snp.makeConstraints { make in
            make.top.equalTo(contentView)
            make.left.right.equalTo(contentView)
            make.height.equalTo(250)
        }
    }

    private func makePosterImageConstraints() {
        posterImageView.snp.makeConstraints { make in
            make.left.equalTo(contentView).offset(16)
            make.bottom.equalTo(backdropImageView.snp.bottom).offset(40)
            make.width.equalTo(120)
            make.height.equalTo(180)
        }
    }

    private func makeTaglineLabelConstraints() {
        taglineLabel.snp.makeConstraints { make in
            make.top.equalTo(posterImageView.snp.bottom).offset(16)
            make.left.equalTo(contentView).offset(16)
            make.right.equalTo(contentView).offset(-16)
        }
    }

    private func makeGenresStackViewConstraints() {
        genresStackView.snp.makeConstraints { make in
            make.top.equalTo(taglineLabel.snp.bottom).offset(12)
            make.left.equalTo(contentView).offset(16)
            make.right.lessThanOrEqualTo(contentView).offset(-16)
        }
    }

    private func makeInfoStackViewConstraints() {
        infoStackView.snp.makeConstraints { make in
            make.top.equalTo(genresStackView.snp.bottom).offset(12)
            make.left.equalTo(contentView).offset(16)
            make.right.equalTo(contentView).offset(-16)
        }
    }

    private func makeOverviewTitleLabelConstraints() {
        overviewTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(infoStackView.snp.bottom).offset(20)
            make.left.equalTo(contentView).offset(16)
            make.right.equalTo(contentView).offset(-16)
        }
    }

    private func makeOverviewLabelConstraints() {
        overviewLabel.snp.makeConstraints { make in
            make.top.equalTo(overviewTitleLabel.snp.bottom).offset(12)
            make.left.equalTo(contentView).offset(16)
            make.right.equalTo(contentView).offset(-16)
            make.bottom.equalTo(contentView).offset(-24)
        }
    }
    
    
}
