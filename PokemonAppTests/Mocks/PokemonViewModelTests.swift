//
//  PokemonViewModelTests.swift
//  PokemonApp
//
//  Created by epena on 2/3/25.
//

import XCTest
@testable import PokemonApp

final class PokemonViewModelTests: XCTestCase {

    func testPokemonSummaryDecoding() throws {
        let data = try Data(contentsOf: Bundle.main.url(forResource: "testSummary", withExtension: "json")!)
        let decoded = try JSONDecoder().decode(PokemonListResponse.self, from: data)

        XCTAssertFalse(decoded.results.isEmpty, "La lista de Pokémon no debería estar vacía")
        XCTAssertEqual(decoded.results.first?.name, "bulbasaur", "El primer Pokémon debería ser Bulbasaur")
    }

    func testPokemonDetailDecoding() throws {
        let data = try Data(contentsOf: Bundle.main.url(forResource: "testPokemon", withExtension: "json")!)
        let decoded = try JSONDecoder().decode(Pokemon.self, from: data)

        XCTAssertEqual(decoded.name, "pikachu", "El Pokémon debería ser Pikachu")
        XCTAssertNotNil(decoded.sprites.front_default, "El sprite del Pokémon no debería ser nulo")
    }

    func testSpeciesDecoding() throws {
        let data = try Data(contentsOf: Bundle.main.url(forResource: "testSpecies", withExtension: "json")!)
        let decoded = try JSONDecoder().decode(PokemonSpecies.self, from: data)

        XCTAssertNotNil(decoded.evolutionChain.url, "La URL de evolución no debería ser nula")
    }

    func testEvolutionsDecoding() throws {
        let data = try Data(contentsOf: Bundle.main.url(forResource: "testEvolutions", withExtension: "json")!)
        let decoded = try JSONDecoder().decode(EvolutionChain.self, from: data)

        XCTAssertNotNil(decoded.chain.species.name, "El nombre de la especie no debería ser nulo")
        XCTAssertFalse(decoded.chain.evolvesTo.isEmpty, "El Pokémon debería tener evoluciones")
    }

    func testPokemonListViewModelFetch() async throws {
        let viewModel = PokemonListViewModel(network: DataTest())

        await viewModel.fetchPokemonList()

        XCTAssertFalse(viewModel.pokemons.isEmpty, "La lista de Pokémon no debería estar vacía")
        XCTAssertEqual(viewModel.pokemons.first?.name, "bulbasaur", "El primer Pokémon debería ser Bulbasaur")
    }

    func testPokemonDetailViewModelFetch() async throws {
        let viewModel = PokemonDetailViewModel(network: DataTest(), pokemonSummary: .testPikachu)

        await viewModel.fetchPokemonDetail()

        XCTAssertNotNil(viewModel.pokemon, "El detalle del Pokémon no debería ser nulo")
        XCTAssertEqual(viewModel.pokemon?.name, "pikachu", "El Pokémon cargado debería ser Pikachu")
    }
}
