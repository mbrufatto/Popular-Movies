//
//  PosterView.swift
//  PopularMovies
//
//  Created by Marcio Habigzang Brufatto on 09/11/25.
//

import SwiftUI

struct PosterView: View {
    let source: PosterSource

    var body: some View {
        switch source {
        case .url(let url):
            AsyncImage(url: url) { phase in
                switch phase {
                case .empty:
                    placeholder
                case .success(let image):
                    image.resizable().scaledToFill()
                case .failure:
                    placeholderWithIcon
                @unknown default:
                    placeholder
                }
            }

        case .data(let data):
            if let data, let ui = UIImage(data: data) {
                Image(uiImage: ui).resizable().scaledToFill()
            } else {
                placeholderWithIcon
            }

        case .hybrid(let url, let dataFallback):
            AsyncImage(url: url) { phase in
                switch phase {
                case .empty:
                    if let dataFallback, let ui = UIImage(data: dataFallback) {
                        Image(uiImage: ui).resizable().scaledToFill()
                    } else {
                        placeholder
                    }
                case .success(let image):
                    image.resizable().scaledToFill()
                case .failure:
                    if let dataFallback, let ui = UIImage(data: dataFallback) {
                        Image(uiImage: ui).resizable().scaledToFill()
                    } else {
                        placeholderWithIcon
                    }
                @unknown default:
                    placeholder
                }
            }
        }
    }

    private var placeholder: some View {
        ZStack {
            Rectangle().fill(.gray.opacity(0.2))
            ProgressView().tint(.white)
        }
    }

    private var placeholderWithIcon: some View {
        ZStack {
            Rectangle().fill(.gray.opacity(0.2))
            Image(systemName: "film")
                .font(.largeTitle)
                .foregroundStyle(.white.opacity(0.6))
        }
    }
}
