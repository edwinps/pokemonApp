//
//  PokemonDetailViewModelTest.swift
//  PokemonApp
//
//  Created by epena on 2/3/25.
//
import XCTest
import Combine
import SwiftUI
@testable import PokemonApp

class PokemonDetailViewModelTests: XCTestCase {
    var viewModel: PokemonDetailViewModel!
    var mockNetwork: MockDataInteractor!
    var cancellables: Set<AnyCancellable> = []

    override func setUp() {
        super.setUp()
        mockNetwork = MockDataInteractor()
        let summary = PokemonSummary(name: "Pikachu", url: "https://pokeapi.co/api/v2/pokemon/25/")
        viewModel = PokemonDetailViewModel(network: mockNetwork, pokemonSummary: summary)
    }

    override func tearDown() {
        viewModel = nil
        mockNetwork = nil
        cancellables.removeAll()
        super.tearDown()
    }

    func testFetchPokemonDetail_Success() async {
        // Given
        let mockPokemon = Pokemon(id: 25,
                                   name: "Pikachu",
                                   sprites: Sprites(front_default: ""),
                                   types: [],
                                   stats: [])
        let mockSpecies = PokemonSpecies(
            evolutionChain: EvolutionChainReference(url: "https://pokeapi.co/api/v2/evolution-chain/10/"),
            evolvesFromSpecies: EvolutionSpecies(name: "Pichu")
        )
        let mockEvolutionChain = EvolutionChain(
            chain: EvolutionChainLink(
                species: EvolutionSpecies(name: "Pichu"),
                evolvesTo: [
                    EvolutionChainLink(species: EvolutionSpecies(name: "Pikachu"), evolvesTo: [
                        EvolutionChainLink(species: EvolutionSpecies(name: "Raichu"), evolvesTo: [])
                    ])
                ]
            )
        )

        mockNetwork.mockPokemon = mockPokemon
        mockNetwork.mockPokemonSpecies = mockSpecies
        mockNetwork.mockEvolutionChain = mockEvolutionChain

        let expectation = XCTestExpectation(description: "Pokémon details should be updated")

        viewModel.$pokemon
            .dropFirst()
            .sink { pokemon in
                if pokemon != nil {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)

        // When
        await viewModel.fetchPokemonDetail()

        // Then
        await fulfillment(of: [expectation], timeout: 2)
        XCTAssertNotNil(viewModel.pokemon)
        XCTAssertEqual(viewModel.pokemon?.name, "Pikachu")
        XCTAssertEqual(viewModel.evolutions, ["Raichu"])
    }

    func testFetchPokemonDetail_Failure() async {
        // Given
        mockNetwork.shouldThrowError = true

        let expectation = XCTestExpectation(description: "Error message should be set")

        viewModel.$errorMessage
            .dropFirst()
            .sink { errorMessage in
                if errorMessage != nil {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)

        // When
        await viewModel.fetchPokemonDetail()

        // Then
        await fulfillment(of: [expectation], timeout: 2)
        XCTAssertNotNil(viewModel.errorMessage)
        XCTAssertEqual(viewModel.errorMessage, "Failed to load Pokémon details.")
        XCTAssertNil(viewModel.pokemon)
        XCTAssertTrue(viewModel.evolutions.isEmpty)
    }

   func testFetchPokemonDetail_PokemonNil() async {
        // Given
        mockNetwork.mockPokemon = nil

        let expectation = XCTestExpectation(description: "Error message should be set due to nil Pokémon response")

        viewModel.$errorMessage
            .dropFirst()
            .sink { errorMessage in
                if errorMessage != nil {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)

        // When
        await viewModel.fetchPokemonDetail()

        // Then
        await fulfillment(of: [expectation], timeout: 2)
        XCTAssertEqual(viewModel.errorMessage, "Failed to load Pokémon details.")
        XCTAssertNil(viewModel.pokemon) // No debe asignarse un Pokémon
    }
}
