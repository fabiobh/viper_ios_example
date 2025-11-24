//
//  MovieListPresenterTests.swift
//  ios_viper_exampleTests
//
//  Created on 2025-11-24.
//

import XCTest
@testable import ios_viper_example

// MARK: - Mock View

class MockMovieListView: MovieListPresenterToViewProtocol {
    var showMoviesCalled = false
    var appendMoviesCalled = false
    var showLoadingCalled = false
    var hideLoadingCalled = false
    var showErrorCalled = false
    
    var moviesShown: [Movie] = []
    var moviesAppended: [Movie] = []
    var errorMessage: String?
    
    func showMovies(_ movies: [Movie]) {
        showMoviesCalled = true
        moviesShown = movies
    }
    
    func appendMovies(_ movies: [Movie]) {
        appendMoviesCalled = true
        moviesAppended = movies
    }
    
    func showLoading() {
        showLoadingCalled = true
    }
    
    func hideLoading() {
        hideLoadingCalled = true
    }
    
    func showError(message: String) {
        showErrorCalled = true
        errorMessage = message
    }
}

// MARK: - Mock Interactor

class MockMovieListInteractor: MovieListPresenterToInteractorProtocol {
    var presenter: MovieListInteractorToPresenterProtocol?
    
    var fetchPopularMoviesCalled = false
    var lastPageRequested: Int?
    
    func fetchPopularMovies(page: Int) {
        fetchPopularMoviesCalled = true
        lastPageRequested = page
    }
}

// MARK: - Mock Router

class MockMovieListRouter: MovieListPresenterToRouterProtocol {
    var navigateToMovieDetailsCalled = false
    var navigateToSearchCalled = false
    var navigateToFavoritesCalled = false
    
    var lastMovieNavigated: Movie?
    
    func navigateToMovieDetails(from view: UIViewController, with movie: Movie) {
        navigateToMovieDetailsCalled = true
        lastMovieNavigated = movie
    }
    
    func navigateToSearch(from view: UIViewController) {
        navigateToSearchCalled = true
    }
    
    func navigateToFavorites(from view: UIViewController) {
        navigateToFavoritesCalled = true
    }
}

// MARK: - Tests

class MovieListPresenterTests: XCTestCase {
    
    var presenter: MovieListPresenter!
    var mockView: MockMovieListView!
    var mockInteractor: MockMovieListInteractor!
    var mockRouter: MockMovieListRouter!
    
    override func setUp() {
        super.setUp()
        
        presenter = MovieListPresenter()
        mockView = MockMovieListView()
        mockInteractor = MockMovieListInteractor()
        mockRouter = MockMovieListRouter()
        
        presenter.view = mockView
        presenter.interactor = mockInteractor
        presenter.router = mockRouter
        
        mockInteractor.presenter = presenter
    }
    
    override func tearDown() {
        presenter = nil
        mockView = nil
        mockInteractor = nil
        mockRouter = nil
        
        super.tearDown()
    }
    
    // MARK: - Test viewDidLoad
    
    func testViewDidLoad_CallsInteractorToFetchMovies() {
        // When
        presenter.viewDidLoad()
        
        // Then
        XCTAssertTrue(mockInteractor.fetchPopularMoviesCalled, "Interactor should be called to fetch movies")
        XCTAssertEqual(mockInteractor.lastPageRequested, 1, "Should request page 1 initially")
    }
    
    func testViewDidLoad_ShowsLoading() {
        // When
        presenter.viewDidLoad()
        
        // Then
        XCTAssertTrue(mockView.showLoadingCalled, "View should show loading")
    }
    
    // MARK: - Test didFetchMovies
    
    func testDidFetchMovies_UpdatesView() {
        // Given
        let movies = createMockMovies(count: 5)
        
        // When
        presenter.didFetchMovies(movies)
        
        // Then
        XCTAssertTrue(mockView.showMoviesCalled, "View should be updated with movies")
        XCTAssertEqual(mockView.moviesShown.count, 5, "Should show 5 movies")
        XCTAssertTrue(mockView.hideLoadingCalled, "Loading should be hidden")
    }
    
    func testDidFetchMovies_FirstPage_ShowsMovies() {
        // Given
        let movies = createMockMovies(count: 20)
        
        // When
        presenter.viewDidLoad()
        presenter.didFetchMovies(movies)
        
        // Then
        XCTAssertTrue(mockView.showMoviesCalled, "Should call showMovies for first page")
        XCTAssertFalse(mockView.appendMoviesCalled, "Should not call appendMovies for first page")
    }
    
    func testDidFetchMovies_SecondPage_AppendsMovies() {
        // Given
        let firstPageMovies = createMockMovies(count: 20)
        let secondPageMovies = createMockMovies(count: 20, startId: 21)
        
        // When
        presenter.viewDidLoad()
        presenter.didFetchMovies(firstPageMovies)
        presenter.loadMoreMovies()
        presenter.didFetchMovies(secondPageMovies)
        
        // Then
        XCTAssertTrue(mockView.appendMoviesCalled, "Should call appendMovies for second page")
    }
    
    // MARK: - Test Error Handling
    
    func testDidFailToFetchMovies_ShowsError() {
        // Given
        let errorMessage = "Network error"
        
        // When
        presenter.didFailToFetchMovies(with: errorMessage)
        
        // Then
        XCTAssertTrue(mockView.showErrorCalled, "Should show error")
        XCTAssertEqual(mockView.errorMessage, errorMessage, "Should show correct error message")
        XCTAssertTrue(mockView.hideLoadingCalled, "Should hide loading")
    }
    
    // MARK: - Test Navigation
    
    func testDidSelectMovie_NavigatesToDetails() {
        // Given
        let movies = createMockMovies(count: 5)
        presenter.didFetchMovies(movies)
        
        // When
        presenter.didSelectMovie(at: 2)
        
        // Then
        XCTAssertTrue(mockRouter.navigateToMovieDetailsCalled, "Should navigate to details")
        XCTAssertEqual(mockRouter.lastMovieNavigated?.id, movies[2].id, "Should navigate with correct movie")
    }
    
    func testDidTapSearch_NavigatesToSearch() {
        // When
        presenter.didTapSearch()
        
        // Then
        XCTAssertTrue(mockRouter.navigateToSearchCalled, "Should navigate to search")
    }
    
    func testDidTapFavorites_NavigatesToFavorites() {
        // When
        presenter.didTapFavorites()
        
        // Then
        XCTAssertTrue(mockRouter.navigateToFavoritesCalled, "Should navigate to favorites")
    }
    
    // MARK: - Test Pagination
    
    func testLoadMoreMovies_RequestsNextPage() {
        // Given
        let firstPageMovies = createMockMovies(count: 20)
        presenter.viewDidLoad()
        presenter.didFetchMovies(firstPageMovies)
        
        // When
        presenter.loadMoreMovies()
        
        // Then
        XCTAssertEqual(mockInteractor.lastPageRequested, 2, "Should request page 2")
    }
    
    func testRefreshMovies_ResetsToFirstPage() {
        // Given
        let firstPageMovies = createMockMovies(count: 20)
        presenter.viewDidLoad()
        presenter.didFetchMovies(firstPageMovies)
        presenter.loadMoreMovies()
        
        // When
        presenter.refreshMovies()
        
        // Then
        XCTAssertEqual(mockInteractor.lastPageRequested, 1, "Should reset to page 1")
    }
    
    // MARK: - Helper Methods
    
    private func createMockMovies(count: Int, startId: Int = 1) -> [Movie] {
        return (startId..<(startId + count)).map { id in
            Movie(
                id: id,
                title: "Movie \(id)",
                overview: "Overview \(id)",
                posterPath: "/poster\(id).jpg",
                backdropPath: "/backdrop\(id).jpg",
                releaseDate: "2024-01-01",
                voteAverage: 7.5,
                voteCount: 1000,
                popularity: 100.0,
                originalLanguage: "en",
                genreIds: [28, 12]
            )
        }
    }
}
