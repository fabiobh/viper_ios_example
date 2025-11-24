//
//  NetworkManager.swift
//  ios_viper_example
//
//  Created on 2025-11-24.
//

import Foundation

// MARK: - Network Error

enum NetworkError: Error {
    case invalidURL
    case noData
    case decodingError
    case serverError(String)
    case unknown
    
    var localizedDescription: String {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .noData:
            return "No data received"
        case .decodingError:
            return "Failed to decode response"
        case .serverError(let message):
            return message
        case .unknown:
            return "An unknown error occurred"
        }
    }
}

// MARK: - Network Manager

class NetworkManager {
    static let shared = NetworkManager()
    
    private let baseURL = "https://api.themoviedb.org/3"
    private let apiKey: String
    
    private init() {
        // Load API key from Configuration.plist
        guard let path = Bundle.main.path(forResource: "Configuration", ofType: "plist"),
              let config = NSDictionary(contentsOfFile: path),
              let key = config["TMDB_API_KEY"] as? String,
              !key.isEmpty && key != "YOUR_TMDB_API_KEY" else {
            fatalError("""
                ⚠️ TMDB API Key not configured!
                
                Please follow these steps:
                1. Copy Configuration.plist.example to Configuration.plist
                2. Get your API key from https://www.themoviedb.org/settings/api
                3. Replace YOUR_TMDB_API_KEY with your actual API key in Configuration.plist
                """)
        }
        self.apiKey = key
    }

    
    // MARK: - Generic Request
    
    func request<T: Decodable>(
        endpoint: String,
        parameters: [String: String] = [:],
        completion: @escaping (Result<T, NetworkError>) -> Void
    ) {
        var urlComponents = URLComponents(string: baseURL + endpoint)
        
        var queryItems = [URLQueryItem(name: "api_key", value: apiKey)]
        queryItems.append(contentsOf: parameters.map { URLQueryItem(name: $0.key, value: $0.value) })
        urlComponents?.queryItems = queryItems
        
        guard let url = urlComponents?.url else {
            completion(.failure(.invalidURL))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(.serverError(error.localizedDescription)))
                return
            }
            
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let result = try decoder.decode(T.self, from: data)
                completion(.success(result))
            } catch {
                print("Decoding error: \(error)")
                completion(.failure(.decodingError))
            }
        }
        
        task.resume()
    }
    
    // MARK: - Movie Endpoints
    
    func fetchPopularMovies(page: Int = 1, completion: @escaping (Result<MovieResponse, NetworkError>) -> Void) {
        request(endpoint: "/movie/popular", parameters: ["page": "\(page)"], completion: completion)
    }
    
    func fetchNowPlayingMovies(page: Int = 1, completion: @escaping (Result<MovieResponse, NetworkError>) -> Void) {
        request(endpoint: "/movie/now_playing", parameters: ["page": "\(page)"], completion: completion)
    }
    
    func fetchTopRatedMovies(page: Int = 1, completion: @escaping (Result<MovieResponse, NetworkError>) -> Void) {
        request(endpoint: "/movie/top_rated", parameters: ["page": "\(page)"], completion: completion)
    }
    
    func fetchUpcomingMovies(page: Int = 1, completion: @escaping (Result<MovieResponse, NetworkError>) -> Void) {
        request(endpoint: "/movie/upcoming", parameters: ["page": "\(page)"], completion: completion)
    }
    
    func fetchMovieDetails(movieId: Int, completion: @escaping (Result<MovieDetail, NetworkError>) -> Void) {
        request(endpoint: "/movie/\(movieId)", completion: completion)
    }
    
    func searchMovies(query: String, page: Int = 1, completion: @escaping (Result<MovieResponse, NetworkError>) -> Void) {
        request(endpoint: "/search/movie", parameters: ["query": query, "page": "\(page)"], completion: completion)
    }
}
