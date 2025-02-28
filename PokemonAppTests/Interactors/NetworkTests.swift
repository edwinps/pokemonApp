//
//  NetworkTests.swift
//  PokemonApp
//
//  Created by epena on 28/2/25.
//
import XCTest
@testable import PokemonApp

class NetworkTests: XCTestCase {
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

    func testGetJSON_Success() async throws {
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
        let response = HTTPURLResponse(url: URL(string: "https://pokeapi.co")!,
                                       statusCode: 200,
                                       httpVersion: nil,
                                       headerFields: nil)!

        MockURLProtocol.mockResponse = (jsonData, response)

        let request = URLRequest(url: URL(string: "https://pokeapi.co")!)

        // When
        let pokemon: Pokemon = try await network.getJSON(request: request, type: Pokemon.self)

        // Then
        XCTAssertEqual(pokemon.name, "Pikachu")
        XCTAssertEqual(pokemon.id, 25)
    }

    func testGetJSON_Failure() async {
        // Given
        let response = HTTPURLResponse(url: URL(string: "https://pokeapi.co")!,
                                       statusCode: 404,
                                       httpVersion: nil,
                                       headerFields: nil)!
        MockURLProtocol.mockResponse = (Data(), response)

        let request = URLRequest(url: URL(string: "https://pokeapi.co")!)

        do {
            // When
            _ = try await network.getJSON(request: request, type: Pokemon.self)
            XCTFail("The request should have failed")
        } catch let error as NetworkError {
            // Then
            XCTAssertEqual(error, NetworkError.status(404))
        } catch {
            XCTFail("An unexpected error was thrown: \(error)")
        }
    }
}
