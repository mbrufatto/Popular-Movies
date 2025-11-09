//
//  FavoritesManager.swift
//  PopularMovies
//
//  Created by Marcio Habigzang Brufatto on 09/11/25.
//

import CoreData
import Foundation

final class FavoritesManager {
    static let shared = FavoritesManager()
    private let context = CoreDataManager.shared.context
    
    func addFavorite(from movie: Movie, posterData: Data? = nil, backdropData: Data? = nil) {
        let favorite = Favorite(context: context)
        favorite.id = Int64(movie.id)
        favorite.title = movie.title
        favorite.overview = movie.overview
        favorite.posterPath = movie.posterPath
        favorite.backdropPath = movie.backdropPath
        favorite.releaseDate = movie.releaseDate
        favorite.voteAverage = movie.voteAverage ?? 0
        favorite.posterData = posterData
        favorite.backdropData = backdropData
        
        saveContext()
    }
    
    func removeFavorite(with id: Int) {
        let request: NSFetchRequest<Favorite> = Favorite.fetchRequest()
        request.predicate = NSPredicate(format: "id == %d", id)
        
        if let result = try? context.fetch(request).first {
            context.delete(result)
            saveContext()
        }
    }
    
    func fetchFavorites() -> [Favorite] {
        let request: NSFetchRequest<Favorite> = Favorite.fetchRequest()
        let results = try? context.fetch(request)
        return results ?? []
    }
    
    func isFavorite(id: Int) -> Bool {
        let request: NSFetchRequest<Favorite> = Favorite.fetchRequest()
        request.predicate = NSPredicate(format: "id == %d", id)
        let count = (try? context.count(for: request)) ?? 0
        return count > 0
    }
    
    private func saveContext() {
        do {
            try context.save()
        } catch {
            print("❌ Erro ao salvar contexto: \(error.localizedDescription)")
        }
    }
}
