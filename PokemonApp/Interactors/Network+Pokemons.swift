//
//  Network+Pokemons.swift
//  PokemonApp
//
//  Created by epena on 26/2/25.
//

import Foundation

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
