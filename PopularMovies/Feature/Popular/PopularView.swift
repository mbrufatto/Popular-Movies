//
//  PopularView.swift
//  PopularMovies
//
//  Created by Marcio Habigzang Brufatto on 08/11/25.
//

import SwiftUI

struct PopularView: View {
    @StateObject var viewModel: PopularViewModel
    
    private let columns = [GridItem(.adaptive(minimum: 150), spacing: 16)]
    
    init(viewModel: PopularViewModel) {
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
                    TextField("search_for_movies", text: $viewModel.query)
                        .padding(.vertical, 16)
                        .padding(.horizontal, 16)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.white)
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.purple.opacity(0.5), lineWidth: 1.2)
                        )
                        .foregroundColor(.purple)
                        .tint(.purple)
                        .padding(.horizontal)
                        .padding(.top)
                    
                    ScrollView {
                        LazyVGrid(columns: columns, spacing: 16) {
                            ForEach(viewModel.movies, id: \.id) { movie in
                                NavigationLink {
                                    MovieDetailView(
                                        viewModel: MovieDetailViewModel(
                                            movie: movie,
                                            service: MovieService(client: APIClient())
                                        ), posterSource: .url(movie.backdropURL)
                                    )
                                } label: {
                                    MovieCardView(movie: movie, posterSource: .url(movie.posterURL))
                                }
                                .buttonStyle(.plain)
                                .onAppear {
                                    if movie.id == viewModel.movies.last?.id {
                                        Task {
                                            await viewModel.loadNextPageDependingOnMode()
                                        }
                                    }
                                }
                            }
                            
                            if viewModel.isLoading && !viewModel.movies.isEmpty {
                                ProgressView()
                                    .padding()
                            }
                        }
                        .padding()
                        .animation(.easeInOut, value: viewModel.movies)
                    }
                    .scrollIndicators(.hidden)
                }
                
                if viewModel.isLoading && viewModel.movies.isEmpty && viewModel.errorMessage == nil {
                    VStack(spacing: 12) {
                        ProgressView("loading_movies")
                            .progressViewStyle(.circular)
                            .scaleEffect(1.3)
                        Text("please_wait_loading_popular_movies")
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color(.systemBackground).opacity(0.95))
                }
                
                if !viewModel.isLoading && viewModel.movies.isEmpty && viewModel.errorMessage == nil {
                        Text(viewModel.query.isEmpty ?
                             "movies_not_found" :
                             "movies_not_found_with_name")
                            .font(.headline)
                            .foregroundStyle(.white)
                            .multilineTextAlignment(.center)
                            .lineLimit(2)
                }
                
                if let error = viewModel.errorMessage, viewModel.movies.isEmpty {
                    VStack(spacing: 12) {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .font(.system(size: 40))
                            .foregroundStyle(.yellow)
                        Text("error_loading_movies")
                            .font(.headline)
                        Text(error)
                            .font(.subheadline)
                            .multilineTextAlignment(.center)
                            .foregroundStyle(.secondary)
                            .padding(.horizontal)
                        
                        Button {
                            Task {
                                await viewModel.loadNextPageDependingOnMode()
                            }
                        } label: {
                            Label("try_again", systemImage: "arrow.clockwise")
                        }
                        .buttonStyle(.borderedProminent)
                        .padding(.top, 8)
                    }
                    .padding()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color(.systemBackground).opacity(0.95))
                }
            }
            .navigationTitle(viewModel.query.isEmpty ? "popular_movies" : "search_movies")
            .task {
                await viewModel.loadNextPageDependingOnMode()
            }
        }
    }
}

#Preview {
    PopularView(
        viewModel: PopularViewModel(
            service: MovieService(
                client: APIClient()
            )
        )
    )
}
