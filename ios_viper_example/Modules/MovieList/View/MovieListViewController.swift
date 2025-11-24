//
//  MovieListViewController.swift
//  ios_viper_example
//
//  Created on 2025-11-24.
//

import UIKit

class MovieListViewController: UIViewController {
    
    // MARK: - Properties
    var presenter: MovieListViewToPresenterProtocol?
    
    private var movies: [Movie] = []
    private var isLoadingMore = false
    
    // MARK: - UI Components
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 16
        layout.minimumLineSpacing = 16
        layout.sectionInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .systemBackground
        cv.delegate = self
        cv.dataSource = self
        cv.register(MovieCell.self, forCellWithReuseIdentifier: MovieCell.identifier)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.refreshControl = refreshControl
        return cv
    }()
    
    private lazy var refreshControl: UIRefreshControl = {
        let rc = UIRefreshControl()
        rc.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        return rc
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        presenter?.viewDidLoad()
    }
    
    // MARK: - Setup
    
    private func setupUI() {
        title = "Popular Movies"
        view.backgroundColor = .systemBackground
        
        // Navigation bar buttons
        let searchButton = UIBarButtonItem(
            barButtonSystemItem: .search,
            target: self,
            action: #selector(searchTapped)
        )
        
        let favoritesButton = UIBarButtonItem(
            image: UIImage(systemName: "heart.fill"),
            style: .plain,
            target: self,
            action: #selector(favoritesTapped)
        )
        
        navigationItem.rightBarButtonItems = [favoritesButton, searchButton]
        
        // Add subviews
        view.addSubview(collectionView)
        view.addSubview(activityIndicator)
        
        // Constraints
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    // MARK: - Actions
    
    @objc private func handleRefresh() {
        presenter?.refreshMovies()
    }
    
    @objc private func searchTapped() {
        presenter?.didTapSearch()
    }
    
    @objc private func favoritesTapped() {
        presenter?.didTapFavorites()
    }
}

// MARK: - Presenter to View Protocol

extension MovieListViewController: MovieListPresenterToViewProtocol {
    func showLoading() {
        DispatchQueue.main.async { [weak self] in
            if self?.movies.isEmpty == true {
                self?.activityIndicator.startAnimating()
            }
        }
    }
    
    func hideLoading() {
        DispatchQueue.main.async { [weak self] in
            self?.activityIndicator.stopAnimating()
            self?.refreshControl.endRefreshing()
            self?.isLoadingMore = false
        }
    }
    
    func showError(message: String) {
        DispatchQueue.main.async { [weak self] in
            let alert = UIAlertController(
                title: "Error",
                message: message,
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self?.present(alert, animated: true)
        }
    }
    
    func showMovies(_ movies: [Movie]) {
        DispatchQueue.main.async { [weak self] in
            self?.movies = movies
            self?.collectionView.reloadData()
        }
    }
    
    func appendMovies(_ movies: [Movie]) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            let startIndex = self.movies.count
            self.movies.append(contentsOf: movies)
            
            let indexPaths = (startIndex..<self.movies.count).map {
                IndexPath(item: $0, section: 0)
            }
            
            self.collectionView.insertItems(at: indexPaths)
        }
    }
}

// MARK: - UICollectionView DataSource

extension MovieListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: MovieCell.identifier,
            for: indexPath
        ) as? MovieCell else {
            return UICollectionViewCell()
        }
        
        let movie = movies[indexPath.item]
        cell.configure(with: movie)
        
        return cell
    }
}

// MARK: - UICollectionView Delegate

extension MovieListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        presenter?.didSelectMovie(at: indexPath.item)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height
        
        if offsetY > contentHeight - height - 100 {
            if !isLoadingMore {
                isLoadingMore = true
                presenter?.loadMoreMovies()
            }
        }
    }
}

// MARK: - UICollectionView FlowLayout

extension MovieListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let padding: CGFloat = 16
        let availableWidth = collectionView.frame.width - (padding * 3)
        let itemWidth = availableWidth / 2
        let itemHeight = itemWidth * 1.5 + 60 // Poster ratio + text space
        
        return CGSize(width: itemWidth, height: itemHeight)
    }
}
