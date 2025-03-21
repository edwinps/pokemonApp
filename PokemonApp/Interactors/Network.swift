//
//  Network.swift
//  PokemonApp
//
//  Created by epena on 26/2/25.
//
import Foundation


protocol DataInteractor: Sendable {
    func getPokemons(page: Int) async throws -> PokemonListResponse
    func getPokemon(name: String) async throws -> Pokemon?
    func getSpecies(name: String) async throws -> PokemonSpecies
    func getEvolutions(url: URL) async throws -> EvolutionChain
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

extension Network {
    func getSpecies(name: String) async throws -> PokemonSpecies {
        return try await getJSON(
            request: .get(url: .getPokemonSpecies.appending(path: "/\(name)"),
                          queryParams: nil),
            type: PokemonSpecies.self
        )
    }

    func getEvolutions(url: URL) async throws -> EvolutionChain {
        return try await getJSON(
            request: .get(url: url,
                          queryParams: nil),
            type: EvolutionChain.self
        )
    }
}

extension Network: DataInteractor {
    func getPokemons(page: Int) async throws -> PokemonListResponse {
        let queryParams = [
            URLQueryItem(name: constants.pageLimit, value: "\(constants.itemPerPage)"),
            URLQueryItem(name: constants.offset, value: "\(constants.itemPerPage * page)"),
        ]
        return try await getJSON(request: .get(url: .getPokemonList, queryParams: queryParams),
                                 type: PokemonListResponse.self)
    }

    func getPokemon(name: String) async throws -> Pokemon? {
        return try await getJSON(request: .get(url: .getPokemon.appending(path: "/\(name)"), queryParams: nil),
                          type: Pokemon.self)
    }
}
