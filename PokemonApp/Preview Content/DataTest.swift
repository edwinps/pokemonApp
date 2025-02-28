//
//  DataTest.swift
//  PokemonApp
//
//  Created by epena on 28/2/25.
//
import Foundation

extension PokemonListViewModel {
    static let test = PokemonListViewModel(network: DataTest())
}

struct DataTest: DataInteractor {
    let url = Bundle.main.url(forResource: "testSummary", withExtension: "json")!
    let urlDetail = Bundle.main.url(forResource: "testPokemon", withExtension: "json")!

    func getPokemons(page: Int) async throws -> [PokemonSummary] {
        let data = try Data(contentsOf: url)
        return try JSONDecoder().decode(PokemonListResponse.self, from: data).results
    }

    // Search
    func getPokemon(name: String) async throws -> Pokemon? {
        let data = try Data(contentsOf: urlDetail)
        return try JSONDecoder().decode(Pokemon.self, from: data)
    }
}
