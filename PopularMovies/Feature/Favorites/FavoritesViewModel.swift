//
//  FavoritesViewModel.swift
//  PopularMovies
//
//  Created by Marcio Habigzang Brufatto on 09/11/25.
//

import Combine
import SwiftUI

enum PosterPreference {
    case posterFirst   // para grid/listas
    case backdropFirst // para detalhes/hero
}

@MainActor
final class FavoritesViewModel: ObservableObject {
    @Published private(set) var favorites: [Favorite] = []
    @Published var isOnline: Bool = true
    private var cancellable: Any?
    
    init() {
        cancellable = NetworkMonitor.shared.$isOnline
            .receive(on: DispatchQueue.main)
            .sink { [weak self] value in
                self?.isOnline = value
            }
    }
    
    func loadFavorites() {
        favorites = FavoritesManager.shared.fetchFavorites()
    }
    
    func posterSource(
        for favorite: Favorite,
        preferredWidth: Int = 500,
        preference: PosterPreference
    ) -> PosterSource {
        let path: String?
        switch preference {
        case .posterFirst:
            path = favorite.posterPath ?? favorite.backdropPath
        case .backdropFirst:
            path = favorite.backdropPath ?? favorite.posterPath
        }

        // Monta URL se houver path
        let url = path.flatMap { URL(string: "https://image.tmdb.org/t/p/w\(preferredWidth)\($0)") }

        // Fallback local (mantém a mesma priorização de dados salvos: usa backdropData se houver, senão posterData)
        // Opcionalmente, você pode alinhar o fallback de dados à mesma preferência da URL:
        let dataFallback: Data?
        switch preference {
        case .posterFirst:
            dataFallback = favorite.posterData ?? favorite.backdropData
        case .backdropFirst:
            dataFallback = favorite.backdropData ?? favorite.posterData
        }

        // Híbrido conforme conectividade
        return isOnline
            ? .hybrid(url: url, dataFallback: dataFallback)
            : .hybrid(url: nil, dataFallback: dataFallback)
    }
    
    func asMovie(favorite: Favorite) -> Movie {
        return Movie(
            id: Int(favorite.id),
            title: favorite.title,
            overview: favorite.overview,
            posterPath: favorite.posterPath,
            backdropPath: favorite.backdropPath,
            releaseDate: favorite.releaseDate,
            voteAverage: favorite.voteAverage
        )
    }
}
