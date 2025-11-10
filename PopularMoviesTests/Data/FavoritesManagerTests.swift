//
//  FavoritesManagerTests.swift
//  PopularMovies
//
//  Created by Marcio Habigzang Brufatto on 09/11/25.
//

import CoreData
import XCTest
@testable import PopularMovies

final class FavoritesManagerTests: XCTestCase {
    
    var manager: FavoritesManager!
    var context: NSManagedObjectContext!
    
    override func setUp() {
        super.setUp()
        
        let container = NSPersistentContainer(name: "Favorites")
        let description = NSPersistentStoreDescription()
        description.url = URL(fileURLWithPath: "/dev/null") // in-memory
        container.persistentStoreDescriptions = [description]
        
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Erro ao carregar container em memória: \(error)")
            }
        }
        context = container.viewContext
        manager = FavoritesManager(context: context)
    }
    
    override func tearDown() {
        context = nil
        manager = nil
        super.tearDown()
    }
    
    func testAddAndFetchFavorite() {
        let movie = Movie(
            id: 123,
            title: "Inception",
            overview: "Dream inside dream",
            posterPath: "/poster.jpg",
            backdropPath: "/backdrop.jpg",
            releaseDate: "2010-07-16",
            voteAverage: 8.8
        )
        
        manager.addFavorite(from: movie)
        let favorites = manager.fetchFavorites()
        
        XCTAssertEqual(favorites.count, 1)
        XCTAssertEqual(favorites.first?.title, "Inception")
    }
    
    func testRemoveFavorite() {
        let movie = Movie(
            id: 123,
            title: "Inception",
            overview: nil,
            posterPath: nil,
            backdropPath: nil,
            releaseDate: nil,
            voteAverage: 0)
        
        manager.addFavorite(from: movie)
        
        manager.removeFavorite(with: 123)
        
        let favorites = manager.fetchFavorites()
        XCTAssertTrue(favorites.isEmpty)
    }
}
