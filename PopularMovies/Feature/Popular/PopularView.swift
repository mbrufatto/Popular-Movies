//
//  PopularView.swift
//  PopularMovies
//
//  Created by Marcio Habigzang Brufatto on 08/11/25.
//

import SwiftUI

struct PopularView: View {
    
    @StateObject var viewModel: PopularViewModel
    
    private let columns = [
        GridItem(.adaptive(minimum: 150), spacing: 16)
    ]
    
    var body: some View {
        NavigationStack {
            ZStack {
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 16) {
                        ForEach(viewModel.movies) { movie in
                            MovieCardView(movie: movie)
                                .onAppear {
                                    if movie == viewModel.movies.last {
                                        Task {
                                            await viewModel.loadNextPage()
                                        }
                                    }
                                }
                        }
                        
                        if viewModel.isLoading {
                            ProgressView()
                                .padding()
                                .frame(maxWidth: .infinity)
                        }
                    }
                    .padding()
                }
                .scrollIndicators(.hidden)
                
                if viewModel.isLoading && viewModel.movies.isEmpty {
                    ProgressView("Carregando filmes...")
                        .progressViewStyle(.circular)
                        .scaleEffect(1.5)
                }
                
                if let error = viewModel.errorMessage {
                    VStack(spacing: 12) {
                        Text("Erro ao carregar filmes:")
                            .font(.headline)
                        Text(error)
                            .foregroundStyle(.red)
                            .padding()
                        Button("Tentar novamente") {
                            Task {
                                await viewModel.loadInitial()
                            }
                        }.buttonStyle(.borderedProminent)
                    }
                    .padding()
                    .background(.thinMaterial)
                    .cornerRadius(12)
                }
                
                if !viewModel.isLoading && viewModel.movies.isEmpty && viewModel.errorMessage == nil {
                    Text("Nenhum filme encontrado.")
                        .font(.headline)
                        .foregroundStyle(.secondary)
                }
            }
            .navigationTitle("Filmes Populares")
            .task {
                await viewModel.loadInitial()
            }
        }
    }
}

#Preview {
    PopularView(
        viewModel: PopularViewModel(
            service: MovieService(
                client: APIClient(
                    apiKey: Bundle.main.infoDictionary?["API_KEY"] as? String ?? ""
                )
            )
        )
    )
}
