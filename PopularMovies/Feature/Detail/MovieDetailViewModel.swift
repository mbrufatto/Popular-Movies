//
//  MovieDetailViewModel.swift
//  PopularMovies
//
//  Created by Marcio Habigzang Brufatto on 08/11/25.
//

import Combine
import Foundation
import SwiftUI

@MainActor
final class MovieDetailViewModel: ObservableObject {
    @Published var movie: Movie
    @Published var trailerKey: String?
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let service: MovieServiceProtocol
    
    init(movie: Movie, service: MovieServiceProtocol) {
        self.movie = movie
        self.service = service
    }
    
    func loadDetails() async {
        isLoading = true
        defer { isLoading = false }
        errorMessage = nil
        
        do {
            movie = try await service.fetchMovieDetails(id: movie.id)
            
            let videos = try await service.fetchVideos(for: movie.id)
            trailerKey = videos.results.first(where: {
                $0.site == "YouTube" && $0.type.lowercased() == "trailer"
            })?.key
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
}
