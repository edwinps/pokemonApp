//
//  DataInteractorTests.swift
//  PokemonApp
//
//  Created by epena on 28/2/25.
//

import XCTest
@testable import PokemonApp

class DataInteractorTests: XCTestCase {
    var mockInteractor: MockDataInteractor!

    override func setUp() {
        super.setUp()
        mockInteractor = MockDataInteractor()
    }

    override func tearDown() {
        mockInteractor = nil
        super.tearDown()
    }

    func testGetPokemons_Success() async throws {
        // Given
        let expectedPokemons = [PokemonSummary(name: "Pikachu", url: "https://pokeapi.co/pikachu")]
        mockInteractor.mockPokemonSummaries = expectedPokemons

        // When
        let pokemons = try await mockInteractor.getPokemons(page: 1)

        // Then
        XCTAssertEqual(pokemons.count, 1)
        XCTAssertEqual(pokemons.first?.name, "Pikachu")
    }

    func testGetPokemons_Failure() async {
        // Given
        mockInteractor.shouldThrowError = true

        do {
            // When
            _ = try await mockInteractor.getPokemons(page: 1)
            XCTFail("The request should have failed")
        } catch let error as NetworkError {
            // Then
            XCTAssertEqual(error, NetworkError.status(500))
        } catch {
            XCTFail("An unexpected error was thrown: \(error)")
        }
    }

    func testGetPokemon_Success() async throws {
        // Given
        let expectedPokemon = Pokemon(id: 25,
                                      name: "Pikachu",
                                      sprites: Sprites(front_default: ""),
                                      types: [],
                                      stats: [])
        mockInteractor.mockPokemon = expectedPokemon

        // When
        let pokemon = try await mockInteractor.getPokemon(name: "Pikachu")

        // Then
        XCTAssertNotNil(pokemon)
        XCTAssertEqual(pokemon?.name, "Pikachu")
        XCTAssertEqual(pokemon?.id, 25)
    }

    func testGetPokemon_Failure() async {
        // Given
        mockInteractor.shouldThrowError = true

        do {
            // When
            _ = try await mockInteractor.getPokemon(name: "Pikachu")
            XCTFail("The request should have failed")
        } catch let error as NetworkError {
            // Then
            XCTAssertEqual(error, NetworkError.status(404))
        } catch {
            XCTFail("An unexpected error was thrown: \(error)")
        }
    }
}
