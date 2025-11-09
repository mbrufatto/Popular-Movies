//
//  MovieDetailView.swift
//  PopularMovies
//
//  Created by Marcio Habigzang Brufatto on 08/11/25.
//

import SwiftUI

struct MovieDetailView: View {
    
    @StateObject var viewModel: MovieDetailViewModel
    @State private var showTrailer = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                AsyncImage(
                    url: URL(string: "https://image.tmdb.org/t/p/w780\(viewModel.movie.backdropPath ?? viewModel.movie.posterPath ?? "")")
                ) { image in
                    image
                        .resizable()
                        .scaledToFit()
                } placeholder: {
                    Rectangle()
                        .fill(.gray.opacity(0.3))
                        .frame(height: 200)
                }
                .cornerRadius(12)
                
                Text(viewModel.movie.title)
                    .font(.title)
                    .bold()
                
                HStack {
                    if let date = viewModel.movie.releaseDate, !date.isEmpty {
                        Label(date, systemImage: "calendar")
                    }
                    if let rating = viewModel.movie.voteAverage {
                        Label(String(format: "%.1f", rating), systemImage: "star.fill")
                            .foregroundStyle(.yellow)
                    }
                }
                .font(.subheadline)
                .foregroundStyle(.secondary)
                
                Text(viewModel.movie.overviewText)
                    .font(.body)
                
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
        .navigationTitle(viewModel.movie.title)
        .navigationBarTitleDisplayMode(.inline)
        .task { await viewModel.loadDetails() }
        .sheet(isPresented: $showTrailer) {
            if let key = viewModel.trailerKey {
                TrailerPlayerSheet(videoKey: key)
            }
        }
    }
}
