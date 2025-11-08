//
//  PopularViewModel.swift
//  PopularMovies
//
//  Created by Marcio Habigzang Brufatto on 07/11/25.
//

import Combine
import Foundation
import SwiftUI

@MainActor
final class PopularViewModel: ObservableObject {
    
    @Published private(set) var movies: [Movie] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private var currentPage = 1
    private var totalPages = 1
    private let service: MovieServiceProtocol
    
    init(service: MovieServiceProtocol) {
        self.service = service
    }
    
    func loadInitial() async {
        currentPage = 1
        movies = []
        await loadNextPage()
    }
    
    func loadNextPage() async {
        guard !isLoading,
              currentPage <= totalPages else { return }
        isLoading = true
        errorMessage = nil
        
        do {
            let response = try await service.fetchPopular(page: currentPage)
            withAnimation(.easeInOut) {
                movies.append(contentsOf: response.results)
            }
            totalPages = response.totalPages
            currentPage += 1
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }
}
