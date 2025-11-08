//
//  SearchView.swift
//  PopularMovies
//
//  Created by Marcio Habigzang Brufatto on 08/11/25.
//

import SwiftUI

struct SearchView: View {
    
    @StateObject var viewModel: SearchViewModel
    
    private let columns = [
        GridItem(.adaptive(minimum: 150), spacing: 16)
    ]
    
    var body: some View {
        NavigationStack {
            VStack {
                TextField("Buscar filmes...", text: $viewModel.query)
                    .textFieldStyle(.roundedBorder)
                    .padding(.horizontal)
                    .padding(.top)
                
                if viewModel.isLoading && viewModel.results.isEmpty {
                    ProgressView("Procurando...")
                        .padding()
                } else if let error = viewModel.errorMessage {
                    Text("Erro: \(error)")
                        .foregroundStyle(.red)
                        .padding()
                } else if viewModel.results.isEmpty && !viewModel.query.isEmpty {
                    Text("Nenhum resultado para '\(viewModel.query)'")
                        .foregroundStyle(.secondary)
                        .padding()
                } else {
                    ScrollView {
                        LazyVGrid(columns: columns, spacing: 16) {
                            ForEach(viewModel.results) { movie in
                                MovieCardView(movie: movie)
                                    .onAppear {
                                        if movie == viewModel.results.last {
                                            Task {
                                                await viewModel.loadNextPage()
                                            }
                                        }
                                    }
                                
                                if viewModel.isLoading {
                                    ProgressView()
                                        .padding()
                                }
                            }
                            .padding()
                            .animation(.easeInOut, value: viewModel.results)
                        }
                        .scrollIndicators(.hidden)
                    }
                }
            }
            .navigationTitle(viewModel.query.isEmpty ? "Buscar Filmes" : viewModel.query)
        }
    }
}

#Preview {
    SearchView(
        viewModel: SearchViewModel(
            service: MovieService(
                client: APIClient(
                    apiKey: Bundle.main.infoDictionary?["API_KEY"] as? String ?? ""
                )
            )
        )
    )
}
