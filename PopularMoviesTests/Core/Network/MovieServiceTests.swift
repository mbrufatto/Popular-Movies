//
//  MovieServiceTests.swift
//  PopularMovies
//
//  Created by Marcio Habigzang Brufatto on 09/11/25.
//

import XCTest
@testable import PopularMovies

final class MovieServiceTests: XCTestCase {
    
    func testFetchPopularMovieReturnResults() async throws {
        let json = """
                {
                    "page": 1,
                    "results": [
                        { "id": 1, "title": "The Batman", "overview": "Dark Knight Returns", "poster_path": "/poster.jpg", "vote_average": 8.2 }
                    ],
                    "total_pages": 1,
                    "total_results": 1
                }
                """.data(using: .utf8)!
        let mockClient = MockAPIClient(mockData: json)
        let service = MovieService(client: mockClient)
        
        let response = try await service.fetchPopular(page: 1)
        
        XCTAssertEqual(response.results.count, 1)
        XCTAssertEqual(response.results.first?.title, "The Batman")
    }
}
