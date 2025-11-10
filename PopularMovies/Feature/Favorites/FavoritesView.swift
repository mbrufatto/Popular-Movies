//
//  FavoritesView.swift
//  PopularMovies
//
//  Created by Marcio Habigzang Brufatto on 09/11/25.
//

import SwiftUI

struct FavoritesView: View {
    @StateObject var viewModel: FavoritesViewModel

    private let columns = [GridItem(.adaptive(minimum: 150), spacing: 16)]

    init(viewModel: FavoritesViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)

        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]

        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }

    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(
                    colors: [
                        .blue.opacity(0.9),
                        .purple.opacity(0.7),
                        .black.opacity(0.6)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                VStack {
                    Spacer()
                    if viewModel.favorites.isEmpty {
                        Text("no_favorites")
                            .font(.headline)
                            .foregroundStyle(.white)
                            .shadow(color: .black.opacity(0.4), radius: 2, x: 0, y: 1)
                        HStack {
                            Image(systemName: "heart.fill")
                                .font(.footnote)
                                .foregroundStyle(.white.opacity(0.85))
                                .shadow(color: .black.opacity(0.4), radius: 2, x: 0, y: 1)
                            
                            Text("movies_favorite_appear_here")
                                .font(.footnote)
                                .foregroundStyle(.white.opacity(0.85))
                                .shadow(color: .black.opacity(0.4), radius: 2, x: 0, y: 1)
                        }
                    } else {
                        
                        ScrollView {
                            LazyVGrid(columns: columns, spacing: 16) {
                                ForEach(viewModel.favorites, id: \.objectID) { favorite in
                                    let movie = viewModel.asMovie(favorite: favorite)
                                    
                                    NavigationLink {
                                        let service = MovieService(client: APIClient())
                                        let detailVM = MovieDetailViewModel(movie: movie, service: service)
                                        MovieDetailView(
                                            viewModel: detailVM,
                                            posterSource: viewModel.posterSource(
                                                for: favorite,
                                                preferredWidth: 780,
                                                preference: .backdropFirst))
                                    } label: {
                                        MovieCardView(
                                            movie: movie,
                                            posterSource: viewModel.posterSource(
                                                for: favorite,
                                                preferredWidth: 500,
                                                preference: .posterFirst))
                                    }
                                    .buttonStyle(.plain)
                                    .onAppear {
                                        if favorite == viewModel.favorites.last {
                                            viewModel.loadFavorites()
                                        }
                                    }
                                }
                            }
                            .padding()
                            .animation(.easeInOut, value: viewModel.favorites)
                        }
                        .scrollIndicators(.hidden)
                    }
                    Spacer()
                }
            }
            .navigationTitle("favorites")
            .task {
                viewModel.loadFavorites()
            }
        }
    }
}
