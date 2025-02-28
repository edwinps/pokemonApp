//
//  Network+Pokemons.swift
//  PokemonApp
//
//  Created by epena on 26/2/25.
//

import Foundation

extension Network: DataInteractor {
    func getPokemons(page: Int) async throws -> [PokemonSummary] {
        let queryParams = [
            URLQueryItem(name: constants.pageLimit, value: "\(constants.itemPerPage)"),
            URLQueryItem(name: constants.offset, value: "\(constants.itemPerPage * page)"),
        ]
        return try await getJSON(request: .get(url: .getPokemonList, queryParams: queryParams),
                                 type: PokemonListResponse.self).results
    }

    func getPokemon(name: String) async throws -> Pokemon? {
        let queryParams = [
            URLQueryItem(name: constants.pageLimit, value: "\(constants.itemPerPage)"),
        ]
        return try await getJSON(request: .get(url: .getPokemonList, queryParams: queryParams),
                          type: Pokemon.self)
    }
}
