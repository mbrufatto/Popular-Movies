//
//  MovieCardView.swift
//  PopularMovies
//
//  Created by Marcio Habigzang Brufatto on 08/11/25.
//

import SwiftUI

enum PosterSource {
    case url(URL?)
    case data(Data?)
    case hybrid(url: URL?, dataFallback: Data?)
}

struct MovieCardView: View {
    
    let movie: Movie
    let posterSource: PosterSource
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            PosterView(source: posterSource)
                .frame(height: 220)
                .cornerRadius(12)
                .clipped()
            
            .frame(height: 220)
            .cornerRadius(12)
            .clipped()
            
            Text(movie.title)
                .font(.headline)
                .foregroundStyle(.white)
                .shadow(color: .black.opacity(0.4), radius: 2, x: 0, y: 1)
                .lineLimit(2)
            
            Text(movie.overviewText)
                .font(.footnote)
                .foregroundStyle(.white.opacity(0.85))
                .lineLimit(3)
        }
        .padding(8)
        .background(
            LinearGradient(
                colors: [Color.black.opacity(0.35), Color.black.opacity(0.25)],
                startPoint: .top,
                endPoint: .bottom
            )
        )
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
            voteAverage: 5.0), posterSource: .url(nil))
}
