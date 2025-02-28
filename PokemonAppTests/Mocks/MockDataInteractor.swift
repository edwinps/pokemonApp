//
//  MockDataInteractor.swift
//  PokemonApp
//
//  Created by epena on 28/2/25.
//

import XCTest
@testable import PokemonApp

class MockDataInteractor: DataInteractor {
    var shouldThrowError = false
    var mockPokemonSummaries: [PokemonSummary] = []
    var mockPokemon: Pokemon?

    func getPokemons(page: Int) async throws -> [PokemonSummary] {
        if shouldThrowError {
            throw NetworkError.status(500)
        }
        return mockPokemonSummaries
    }

    func getPokemon(name: String) async throws -> Pokemon? {
        if shouldThrowError {
            throw NetworkError.status(404)
        }
        return mockPokemon
    }
}
