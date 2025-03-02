//
//  Network+Evolutions.swift
//  PokemonApp
//
//  Created by epena on 1/3/25.
//

import Foundation

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
