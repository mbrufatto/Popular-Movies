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
    @Published var query: String = ""
    
    private var currentPage = 1
    private var totalPages = 1
    private let service: MovieServiceProtocol
    private var cancellables = Set<AnyCancellable>()
    
    private var isSearching = false
    
    init(service: MovieServiceProtocol) {
        self.service = service
        
        $query
            .removeDuplicates()
            .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
            .receive(on: RunLoop.main)
            .sink { [weak self] text in
                Task { await self?.handleSearch(text: text) }
            }
            .store(in: &cancellables)
    }
    
    private func handleSearch(text: String) async {
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmed.isEmpty {
            await loadInitial()
        } else {
            await searchMovies(for: trimmed, reset: true)
        }
    }
    
    func loadInitial() async {
        currentPage = 1
        totalPages = 1
        movies = []
        isSearching = false
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
    
    private func searchMovies(for query: String, reset: Bool = false) async {
        guard !isLoading else { return }
        isSearching = true
        if reset {
            currentPage = 1
            totalPages = 1
            movies = []
        }
        
        isLoading = true
        errorMessage = nil
        
        do {
            let response = try await service.searchMovies(query: query, page: currentPage)
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
    
    func loadNextSearchPage() async {
        guard !isLoading, currentPage <= totalPages else { return }
        await searchMovies(for: query)
    }
    
    func loadNextPageDependingOnMode() async {
        if isSearching {
            await loadNextSearchPage()
        } else {
            await loadNextPage()
        }
    }
}
