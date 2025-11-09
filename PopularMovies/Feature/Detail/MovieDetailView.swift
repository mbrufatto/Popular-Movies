//
//  MovieDetailView.swift
//  PopularMovies
//
//  Created by Marcio Habigzang Brufatto on 08/11/25.
//

import SwiftUI

struct MovieDetailView: View {
    
    @StateObject var viewModel: MovieDetailViewModel
    let posterSource: PosterSource
    @State private var showTrailer = false
    
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color.blue.opacity(0.9),
                    Color.purple.opacity(0.7),
                    Color.black.opacity(0.6)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    PosterView(source: posterSource)
                        .cornerRadius(12)
                    
                    Text(viewModel.movie.title)
                        .font(.title)
                        .foregroundColor(.white)
                        .shadow(color: .black.opacity(0.4), radius: 2, x: 0, y: 1)
                        .bold()
                    
                    HStack {
                        if let date = viewModel.movie.releaseDate, !date.isEmpty {
                            Label(date, systemImage: "calendar")
                                .foregroundColor(.white)
                                .shadow(color: .black.opacity(0.4), radius: 2, x: 0, y: 1)
                        }
                        if let rating = viewModel.movie.voteAverage {
                            Label(String(format: "%.1f", rating), systemImage: "star.fill")
                                .foregroundStyle(.yellow)
                                .shadow(color: .black.opacity(0.4), radius: 2, x: 0, y: 1)
                        }
                    }
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    
                    Text(viewModel.movie.overviewText)
                        .font(.body)
                        .foregroundStyle(.white.opacity(0.85))
                        .shadow(color: .black.opacity(0.4), radius: 2, x: 0, y: 1)
                    
                    if let _ = viewModel.trailerKey {
                        Button {
                            showTrailer = true
                        } label: {
                            Label("Assistir Triler", systemImage: "play.circle.fill")
                                .font(.headline)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(.red.gradient)
                                .foregroundStyle(.white)
                                .cornerRadius(12)
                        }
                        .padding(.top)
                    }
                }.padding()
            }
        }
        .navigationTitle(viewModel.movie.title)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(content: {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    Task { viewModel.toggleFavorite() }
                } label: {
                    Image(systemName: viewModel.isFavorite ? "heart.fill" : "heart")
                        .foregroundStyle(viewModel.isFavorite ? .red : .gray)
                }
            }
        })
        .task {
            await viewModel.loadDetails()
            viewModel.checkFavorite()
        }
        .sheet(isPresented: $showTrailer) {
            if let key = viewModel.trailerKey {
                TrailerPlayerSheet(videoKey: key)
            }
        }
    }
}
