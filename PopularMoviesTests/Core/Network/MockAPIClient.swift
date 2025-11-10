//
//  MockAPIClient.swift
//  PopularMovies
//
//  Created by Marcio Habigzang Brufatto on 09/11/25.
//

import Foundation
@testable import PopularMovies

final class MockAPIClient: APIClient {
    private let mockData: Data
    private let statusCode: Int
    
    init(mockData: Data, statusCode: Int = 200) {
        self.mockData = mockData
        self.statusCode = statusCode
        super.init(session: .shared)
    }
    
    override func get<T>(_ path: String, queryItems: [URLQueryItem] = []) async throws -> T where T : Decodable {
        
        guard statusCode == 200 else {
            throw APIError.requestFailed(NSError(domain: "", code: statusCode))
        }
        
        let decoded = try JSONDecoder().decode(T.self, from: mockData)
        return decoded
    }
}
