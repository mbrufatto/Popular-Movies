//
//  Video.swift
//  PopularMovies
//
//  Created by Marcio Habigzang Brufatto on 08/11/25.
//

struct VideoResponse: Codable {
    let results: [Video]
}

struct Video: Codable, Identifiable {
    let id: String
    let key: String
    let name: String
    let site: String
    let type: String
}
