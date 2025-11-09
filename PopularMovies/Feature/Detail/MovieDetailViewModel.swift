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
    @Published var isFavorite = false
    
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
    
    func toggleFavorite() {
        if isFavorite {
            FavoritesManager.shared.removeFavorite(with: movie.id)
            isFavorite.toggle()
            return
        }
        
        Task {
            let posterURL = ImageURLBuilder.tmdb(path: movie.posterPath, size: "w500")
            let backdropURL = ImageURLBuilder.tmdb(path: movie.backdropPath, size: "w780")
            
            async let posterData = downloadImageData(from: posterURL)
            async let backdropData = downloadImageData(from: backdropURL)
            
            let poster = await posterData
            let backdrop = await backdropData
            
            FavoritesManager.shared.addFavorite(from: movie, posterData: poster, backdropData: backdrop)
            
            await MainActor.run {
                self.isFavorite = true
            }
        }
    }
    
    func checkFavorite() {
        isFavorite = FavoritesManager.shared.isFavorite(id: movie.id)
    }
    
    private func downloadImageData(from url: URL?) async -> Data? {
        guard let url = url else { return nil }
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            guard let http = response as? HTTPURLResponse, http.statusCode == 200 else {
                return nil
            }
            return data
        } catch {
            print("Falha ao baixar imagem: \(error)")
            return nil
        }
    }
    
    
}
