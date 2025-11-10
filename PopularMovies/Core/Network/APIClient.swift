//
//  APIClient.swift
//  PopularMovies
//
//  Created by Marcio Habigzang Brufatto on 07/11/25.
//

import Foundation

enum APIError: Error {
    case invalidURL
    case requestFailed(Error)
    case invalidResponse
    case decodingFailed(Error)
    case rateLimited
}

final class APIClient {
    
    private let session: URLSession
    private let apiKey: String
    private let baseURL = "https://api.themoviedb.org/3"
    
    init(session: URLSession = .shared) {
        self.session = session
        guard let key = Bundle.main.object(forInfoDictionaryKey: "API_KEY") as? String,
              !key.isEmpty else {
            fatalError("🚨 API_KEY não configurada no Info.plist")
        }
        self.apiKey = key
    }
    
    func get<T: Decodable>(_ path: String, queryItems: [URLQueryItem] = []) async throws -> T {
        var components = URLComponents(string: "\(baseURL)/\(path)")
        var items = queryItems
        items.append(URLQueryItem(name: "api_key", value: apiKey))
        items.append(URLQueryItem(name: "language", value: "pt-BR"))
        components?.queryItems = items
        
        guard let url = components?.url else { throw APIError.invalidURL }
        
        var request = URLRequest(url: url)
        request.timeoutInterval = 15
        
        do {
            let (data, response) = try await session.data(for: request)
            guard let http = response as? HTTPURLResponse else { throw APIError.invalidResponse }
            if http.statusCode == 429 { throw APIError.rateLimited }
            
            guard (200...299).contains(http.statusCode) else {
                throw APIError.requestFailed(NSError(domain: "", code: http.statusCode))
            }
            do {
                let decoded = try JSONDecoder().decode(T.self, from: data)
                return decoded
            } catch {
                throw APIError.decodingFailed(error)
            }
        } catch {
            throw APIError.requestFailed(error)
        }
        
    }
}

