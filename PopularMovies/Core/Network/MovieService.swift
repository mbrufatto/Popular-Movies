//
//  MovieService.swift
//  PopularMovies
//
//  Created by Marcio Habigzang Brufatto on 07/11/25.
//

import Foundation

protocol MovieServiceProtocol {
    func fetchPopular(page: Int) async throws -> MovieResponse
    func searchMovies(query: String, page: Int) async throws -> MovieResponse
}

final class MovieService: MovieServiceProtocol {
    private let client: APIClient
    
    init(client: APIClient) {
        self.client = client
    }
    
    func fetchPopular(page: Int) async throws -> MovieResponse {
        try await client.get("movie/popular", queryItems: [URLQueryItem(name: "page", value: "\(page)")])
    }
    
    func searchMovies(query: String, page: Int = 1) async throws -> MovieResponse {
        try await client.get("search/movie", queryItems: [
            URLQueryItem(name: "query", value: query),
            URLQueryItem(name: "page", value: "\(page)"),
            URLQueryItem(name: "include_adult", value: "false")
        ])
    }
}
