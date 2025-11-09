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
            PopularView(
                viewModel: PopularViewModel(
                    service: MovieService(
                        client: APIClient(apiKey: Self.apiKey))
                )
            )
        }
    }
}

extension PopularMoviesApp {
    static var apiKey: String {
        Bundle.main.infoDictionary?["API_KEY"] as? String ?? ""
    }
}
