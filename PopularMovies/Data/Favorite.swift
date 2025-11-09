//
//  FavoritesManager.swift
//  PopularMovies
//
//  Created by Marcio Habigzang Brufatto on 09/11/25.
//

import CoreData

@objc(Favorite)
public class Favorite: NSManagedObject {}

extension Favorite {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Favorite> {
        NSFetchRequest<Favorite>(entityName: "Favorite")
    }

    @NSManaged public var id: Int64
    @NSManaged public var title: String
    @NSManaged public var overview: String?
    @NSManaged public var posterPath: String?
    @NSManaged public var backdropPath: String?
    @NSManaged public var releaseDate: String?
    @NSManaged public var voteAverage: Double
    @NSManaged public var backdropData: Data?
    @NSManaged public var posterData: Data?
}

