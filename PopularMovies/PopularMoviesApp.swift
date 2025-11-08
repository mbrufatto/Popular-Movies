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
                            client: APIClient(apiKey: Self.apiKey))
                    )
                )
                .tabItem {
                    Label("Populares", systemImage: "film.fill")
                }
                
                SearchView(
                    viewModel: SearchViewModel(
                        service: MovieService(
                            client: APIClient(apiKey: Self.apiKey)
                        )
                    )
                )
                .tabItem {
                    Label("Buscar", systemImage: "magnifyingglass")
                }
            }
        }
    }
}

extension PopularMoviesApp {
    static var apiKey: String {
        Bundle.main.infoDictionary?["API_KEY"] as? String ?? ""
     }
}
