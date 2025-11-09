//
//  TrailerPlayerSheet.swift
//  PopularMovies
//
//  Created by Marcio Habigzang Brufatto on 08/11/25.
//

import SwiftUI
import YouTubePlayerKit

struct TrailerPlayerSheet: View {
    @Environment(\.dismiss) private var dismiss
    let videoKey: String

    @State private var player: YouTubePlayer

    init(videoKey: String) {
        self.videoKey = videoKey
        _player = State(initialValue: YouTubePlayer(stringLiteral: "https://www.youtube.com/watch?v=\(videoKey)"))
    }

    var body: some View {
        ZStack {
            YouTubePlayerView(player)
                .ignoresSafeArea()
                .background(Color.black)
                .zIndex(0)

            VStack {
                HStack {
                    Spacer()
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.white)
                            .padding(12)
                            .background(.ultraThinMaterial, in: Circle())
                            .shadow(radius: 5)
                            .padding(.trailing, 12)
                            .padding(.top, 12)
                    }
                }
                Spacer()
            }
            .zIndex(1)
        }
        .background(Color.black)
        .navigationBarHidden(true)
    }
}

#Preview {
    TrailerPlayerSheet(videoKey: "dQw4w9WgXcQ")
}
