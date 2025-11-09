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
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    TextField("Buscar filmes...", text: $viewModel.query)
                        .textFieldStyle(.roundedBorder)
                        .padding(.horizontal)
                        .padding(.top)
                    
                    ScrollView {
                        LazyVGrid(columns: columns, spacing: 16) {
                            ForEach(viewModel.movies, id: \.id) { movie in
                                NavigationLink {
                                    MovieDetailView(
                                        viewModel: MovieDetailViewModel(
                                            movie: movie,
                                            service: MovieService(client: APIClient(apiKey: PopularMoviesApp.apiKey))
                                        )
                                    )
                                } label: {
                                    MovieCardView(movie: movie)
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
                        ProgressView("Carregando filmes...")
                            .progressViewStyle(.circular)
                            .scaleEffect(1.3)
                        Text("Aguarde, estamos carregando os filmes populares.")
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color(.systemBackground).opacity(0.95))
                }
                
                if !viewModel.isLoading && viewModel.movies.isEmpty && viewModel.errorMessage == nil {
                    
                    Text(viewModel.query.isEmpty ? "Filmes não encontrados." : "Filmes não encontrados com o nome \(viewModel.query)")
                        .font(.headline)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                    
                }
                
                if let error = viewModel.errorMessage, viewModel.movies.isEmpty {
                    VStack(spacing: 12) {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .font(.system(size: 40))
                            .foregroundStyle(.yellow)
                        Text("Erro ao carregar filmes")
                            .font(.headline)
                        Text(error)
                            .font(.subheadline)
                            .multilineTextAlignment(.center)
                            .foregroundStyle(.secondary)
                            .padding(.horizontal)
                        
                        Button {
                            Task {
                                await viewModel.loadInitial()
                            }
                        } label: {
                            Label("Tentar novamente", systemImage: "arrow.clockwise")
                        }
                        .buttonStyle(.borderedProminent)
                        .padding(.top, 8)
                    }
                    .padding()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color(.systemBackground).opacity(0.95))
                }
            }
            .navigationTitle(viewModel.query.isEmpty ? "Filmes Populares" : "Buscar Filmes")
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
