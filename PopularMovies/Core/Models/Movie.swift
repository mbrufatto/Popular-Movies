//
//  Movie.swift
//  PopularMovies
//
//  Created by Marcio Habigzang Brufatto on 07/11/25.
//

import Foundation

struct MovieResponse: Codable {
    let page: Int
    let results: [Movie]
    let totalPages: Int
    let totalResults: Int
    
    enum CodingKeys: String, CodingKey {
        case page
        case results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

struct Movie: Codable, Identifiable, Equatable, Hashable {
    let id: Int
    let title: String
    let overview: String?
    let posterPath: String?
    let backdropPath: String?
    let releaseDate: String?
    let voteAverage: Double?
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case overview
        case posterPath = "poster_path"
        case backdropPath = "backdrop_path"
        case releaseDate = "release_date"
        case voteAverage = "vote_average"
    }
    
}

//extension Movie {
//    var posterURL: URL? {
//        guard let path = posterPath else { return nil }
//        return URL(string: "https://image.tmdb.org/t/p/w500\(path)")
//    }
//}

extension Movie {
    var posterURL: URL? {
        guard let path = posterPath?.trimmingCharacters(in: .whitespacesAndNewlines),
              !path.isEmpty,
              !path.hasPrefix("null") else { // às vezes APIs colocam "null" como string
            return nil
        }
        return URL(string: "https://image.tmdb.org/t/p/w500\(path)")
    }
}
