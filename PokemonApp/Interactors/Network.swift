//
//  Network.swift
//  PokemonApp
//
//  Created by epena on 26/2/25.
//
import Foundation

protocol DataInteractor {
    func getPokemons(page: Int) async throws -> [PokemonSummary]

    // Search
    func getPokemon(name: String) async throws -> Pokemon?
}

struct Network {
    let session: URLSession

    struct constants {
        static let pageLimit = "limit"
        static let itemPerPage = 100
        static let offset = "offset"
    }

    init(session: URLSession = .shared) {
        self.session = session
    }

    func getJSON<JSON>(request: URLRequest, type: JSON.Type) async throws -> JSON where JSON: Codable {
        let (data, response) = try await session.getData(for: request)
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.noHTTP
        }
        if response.statusCode == 200 {
            do {
                return try JSONDecoder().decode(type, from: data)
            } catch {
                throw NetworkError.json(error)
            }
        } else {
            throw NetworkError.status(response.statusCode)
        }
    }
}
