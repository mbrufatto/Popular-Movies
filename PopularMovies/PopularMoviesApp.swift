//
//  PopularMoviesApp.swift
//  PopularMovies
//
//  Created by Marcio Habigzang Brufatto on 07/11/25.
//

import SwiftUI

@main
struct PopularMoviesApp: App {
    
    var body: some Scene {
        WindowGroup {
            TabView {
                PopularView(
                    viewModel: PopularViewModel(
                        service: MovieService(
                            client: APIClient())
                    )
                )
                .tabItem {
                    Label("Populares", systemImage: "film.fill")
                }
                
                FavoritesView(viewModel: FavoritesViewModel())
                    .tabItem {
                        Label("Favoritos", systemImage: "heart.fill")
                    }
            }
        }
    }
}
