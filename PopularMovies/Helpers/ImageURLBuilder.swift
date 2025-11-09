//
//  ImageUrl.swift
//  PopularMovies
//
//  Created by Marcio Habigzang Brufatto on 09/11/25.
//

import Foundation

import Foundation

enum ImageURLBuilder {
    static func tmdb(path: String?, size: String = "w500") -> URL? {
        guard let path = path else { return nil }
        return URL(string: "https://image.tmdb.org/t/p/\(size)\(path)")
    }
}

