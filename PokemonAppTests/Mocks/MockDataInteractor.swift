//
//  MockDataInteractor.swift
//  PokemonApp
//
//  Created by epena on 28/2/25.
//

import XCTest
@testable import PokemonApp

@MainActor
final class MockDataInteractor: DataInteractor {
    var shouldThrowError = false
    var mockPokemonListResponse = PokemonListResponse(results: [], next: nil)
    var mockPokemon: Pokemon?
    var mockPokemonSpecies = PokemonSpecies(evolutionChain: EvolutionChainReference(url: ""),
                                                 evolvesFromSpecies: nil)
    var mockEvolutionChain = EvolutionChain(chain: EvolutionChainLink(species: EvolutionSpecies(name: ""), evolvesTo: []))

    func getPokemons(page: Int) async throws -> PokemonListResponse {
        if shouldThrowError {
            throw NetworkError.status(500)
        }
        return mockPokemonListResponse
    }

    func getPokemon(name: String) async throws -> Pokemon? {
        if shouldThrowError {
            throw NetworkError.status(404)
        }
        return mockPokemon
    }

    func getSpecies(name: String) async throws -> PokemonSpecies {
        if shouldThrowError {
            throw NetworkError.status(404)
        }
        return mockPokemonSpecies
    }

    func getEvolutions(url: URL) async throws -> EvolutionChain {
        if shouldThrowError {
            throw NetworkError.status(404)
        }
        return mockEvolutionChain
    }
}
