//
//  MovieCardView.swift
//  PopularMovies
//
//  Created by Marcio Habigzang Brufatto on 08/11/25.
//

import SwiftUI

struct MovieCardView: View {
    
    let movie: Movie
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            AsyncImage(url: movie.posterURL) { phase in
                switch phase {
                case .empty:
                    ZStack {
                        Rectangle()
                            .fill(.gray.opacity(0.2))
                        ProgressView()
                    }
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()
                case .failure:
                    ZStack {
                        Rectangle()
                            .fill(.gray.opacity(0.2))
                        Image(systemName: "film")
                            .font(.largeTitle)
                            .foregroundStyle(.gray)
                    }
                @unknown default:
                    EmptyView()
                }
            }
            .frame(height: 220)
            .cornerRadius(12)
            .clipped()
            
            Text(movie.title)
                .font(.headline)
                .lineLimit(2)
            
            Text(movie.overviewText)
                .font(.footnote)
                .foregroundStyle(.secondary)
                .lineLimit(3)
        }
        .padding(8)
        .background(.ultraThinMaterial)
        .cornerRadius(16)
        .shadow(radius: 2)
    }
}

#Preview {
    MovieCardView(
        movie: Movie(
            id: 1,
            title: "Sei lá",
            overview: "Homem que gosta de mulher",
            posterPath: nil, backdropPath: nil,
            releaseDate: nil,
            voteAverage: 5.0))
}
