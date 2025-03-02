//
//  NetworkDataInteractorTests.swift
//  PokemonApp
//
//  Created by epena on 28/2/25.
//

import XCTest
@testable import PokemonApp

class NetworkDataInteractorTests: XCTestCase {
    var network: Network!

    override func setUp() {
        super.setUp()

        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockURLProtocol.self] 
        let session = URLSession(configuration: config)

        network = Network(session: session)
    }

    override func tearDown() {
        network = nil
        super.tearDown()
    }

    func testGetPokemons_Success() async throws {
        // Given
        let jsonString = """
        {
            "results": [
                { "name": "Pikachu", "url": "https://pokeapi.co/api/v2/pokemon/25/" },
                { "name": "Bulbasaur", "url": "https://pokeapi.co/api/v2/pokemon/1/" }
            ]
        }
        """
        let jsonData = jsonString.data(using: .utf8)!
        let response = HTTPURLResponse(url: URL(string: "https://pokeapi.co/api/v2/pokemon")!,
                                       statusCode: 200,
                                       httpVersion: nil,
                                       headerFields: nil)!

        MockURLProtocol.mockResponse = (jsonData, response)

        // When
        let pokemons = try await network.getPokemons(page: 1).results

        // Then
        XCTAssertEqual(pokemons.count, 2)
        XCTAssertEqual(pokemons.first?.name, "Pikachu")
        XCTAssertEqual(pokemons.last?.name, "Bulbasaur")
    }

    func testGetPokemons_Failure() async {
        // Given
        let response = HTTPURLResponse(url: URL(string: "https://pokeapi.co/api/v2/pokemon")!,
                                       statusCode: 500,
                                       httpVersion: nil,
                                       headerFields: nil)!
        MockURLProtocol.mockResponse = (Data(), response)

        do {
            // When
            _ = try await network.getPokemons(page: 1)
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
        let jsonString = """
        {
            "name": "Pikachu",
            "id": 25,
            "sprites": {
                "front_default": "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/25.png"
            },
            "types": [
                {
                    "slot": 1,
                    "type": {
                        "name": "electric",
                        "url": "https://pokeapi.co/api/v2/type/13/"
                    }
                }
            ],
            "stats": [
                {
                    "base_stat": 35,
                    "effort": 0,
                    "stat": {
                        "name": "hp",
                        "url": "https://pokeapi.co/api/v2/stat/1/"
                    }
                }
            ]
        }
        """
        let jsonData = jsonString.data(using: .utf8)!
        let response = HTTPURLResponse(url: URL(string: "https://pokeapi.co/api/v2/pokemon/pikachu")!,
                                       statusCode: 200,
                                       httpVersion: nil,
                                       headerFields: nil)!

        MockURLProtocol.mockResponse = (jsonData, response)

        // When
        let pokemon = try await network.getPokemon(name: "pikachu")

        // Then
        XCTAssertNotNil(pokemon)
        XCTAssertEqual(pokemon?.name, "Pikachu")
        XCTAssertEqual(pokemon?.id, 25)
    }

    func testGetPokemon_Failure() async {
        // Given
        let response = HTTPURLResponse(url: URL(string: "https://pokeapi.co/api/v2/pokemon/unknown")!,
                                       statusCode: 404,
                                       httpVersion: nil,
                                       headerFields: nil)!
        MockURLProtocol.mockResponse = (Data(), response)

        do {
            // When
            _ = try await network.getPokemon(name: "unknown")
            XCTFail("The request should have failed")
        } catch let error as NetworkError {
            // Then
            XCTAssertEqual(error, NetworkError.status(404))
        } catch {
            XCTFail("An unexpected error was thrown: \(error)")
        }
    }

    func testGetSpecies_Success() async throws {
            // Given
            let jsonString = """
            {
                "evolution_chain": {
                    "url": "https://pokeapi.co/api/v2/evolution-chain/10/"
                },
                "evolves_from_species": {
                    "name": "pichu"
                }
            }
            """
            let jsonData = jsonString.data(using: .utf8)!
            let response = HTTPURLResponse(url: URL(string: "https://pokeapi.co/api/v2/pokemon-species/pikachu")!,
                                           statusCode: 200,
                                           httpVersion: nil,
                                           headerFields: nil)!

            MockURLProtocol.mockResponse = (jsonData, response)

            // When
            let species = try await network.getSpecies(name: "pikachu")

            // Then
            XCTAssertNotNil(species)
            XCTAssertEqual(species.evolutionChain.url, "https://pokeapi.co/api/v2/evolution-chain/10/")
            XCTAssertEqual(species.evolvesFromSpecies?.name, "pichu") // Verifica preevolución
        }

        func testGetSpecies_Failure() async {
            // Given
            let response = HTTPURLResponse(url: URL(string: "https://pokeapi.co/api/v2/pokemon-species/unknown")!,
                                           statusCode: 404,
                                           httpVersion: nil,
                                           headerFields: nil)!
            MockURLProtocol.mockResponse = (Data(), response)

            do {
                // When
                _ = try await network.getSpecies(name: "unknown")
                XCTFail("The request should have failed")
            } catch let error as NetworkError {
                // Then
                XCTAssertEqual(error, NetworkError.status(404))
            } catch {
                XCTFail("An unexpected error was thrown: \(error)")
            }
        }

        func testGetEvolutions_Success() async throws {
            // Given
            let jsonString = """
            {
                "chain": {
                    "species": { "name": "pichu" },
                    "evolves_to": [
                        {
                            "species": { "name": "pikachu" },
                            "evolves_to": [
                                {
                                    "species": { "name": "raichu" },
                                    "evolves_to": []
                                }
                            ]
                        }
                    ]
                }
            }
            """
            let jsonData = jsonString.data(using: .utf8)!
            let response = HTTPURLResponse(url: URL(string: "https://pokeapi.co/api/v2/evolution-chain/10")!,
                                           statusCode: 200,
                                           httpVersion: nil,
                                           headerFields: nil)!

            MockURLProtocol.mockResponse = (jsonData, response)

            // When
            let evolutionChain = try await network.getEvolutions(url: URL(string: "https://pokeapi.co/api/v2/evolution-chain/10")!)

            // Then
            XCTAssertNotNil(evolutionChain)
            XCTAssertEqual(evolutionChain.chain.species.name, "pichu") // Primera evolución
            XCTAssertEqual(evolutionChain.chain.evolvesTo.first?.species.name, "pikachu") // Segunda evolución
            XCTAssertEqual(evolutionChain.chain.evolvesTo.first?.evolvesTo.first?.species.name, "raichu") // Última evolución
        }

        func testGetEvolutions_Failure() async {
            // Given
            let response = HTTPURLResponse(url: URL(string: "https://pokeapi.co/api/v2/evolution-chain/999")!,
                                           statusCode: 500,
                                           httpVersion: nil,
                                           headerFields: nil)!
            MockURLProtocol.mockResponse = (Data(), response)

            do {
                // When
                _ = try await network.getEvolutions(url: URL(string: "https://pokeapi.co/api/v2/evolution-chain/999")!)
                XCTFail("The request should have failed")
            } catch let error as NetworkError {
                // Then
                XCTAssertEqual(error, NetworkError.status(500))
            } catch {
                XCTFail("An unexpected error was thrown: \(error)")
            }
        }
}
