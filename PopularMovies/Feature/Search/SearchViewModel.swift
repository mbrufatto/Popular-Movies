//
//  SearchViewModel.swift
//  PopularMovies
//
//  Created by Marcio Habigzang Brufatto on 08/11/25.
//

import Combine
import Foundation
import SwiftUI

@MainActor
final class SearchViewModel: ObservableObject {
    @Published var query: String = ""
    @Published private(set) var results: [Movie] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private var cancellables = Set<AnyCancellable>()
    private let service: MovieServiceProtocol
    private var currentPage = 1
    private var totalPages = 1
    
    init(service: MovieServiceProtocol) {
        self.service = service
        
        $query
            .removeDuplicates()
            .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
            .sink { [weak self] newQuery in
                Task {
                    await self?.performSearch(for: newQuery)
                }
            }
            .store(in: &cancellables)
    }
    
    func performSearch(for query: String) async {
        guard !query.trimmingCharacters(in: .whitespaces).isEmpty else {
            results = []
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        do {
            let response = try await service.searchMovies(query: query, page: currentPage)
            withAnimation(.easeInOut) {
                results = response.results
            }
            totalPages = response.totalPages
            currentPage = 2
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
    
    func loadNextPage() async {
        guard !isLoading, currentPage <= totalPages else { return }
        isLoading = true
        defer { isLoading = false }
        
        do {
            let response = try await service.searchMovies(query: query, page: currentPage)
            withAnimation(.easeInOut) {
                results.append(contentsOf: response.results)
            }
            currentPage += 1
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
