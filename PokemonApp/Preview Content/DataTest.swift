//
//  DataTest.swift
//  PokemonApp
//
//  Created by epena on 28/2/25.
//
import Foundation

#if DEBUG
extension PokemonSummary {
    static let testPikachu: PokemonSummary = PokemonSummary(name: "Pikachu", url: "https://pokeapi.co/api/v2/pokemon/25/")
}

extension PokemonListViewModel {
    static let test = PokemonListViewModel(network: DataTest())
}

extension PokemonDetailViewModel {
    static let test = PokemonDetailViewModel(network: DataTest(), pokemonSummary: .testPikachu)
}

struct DataTest: DataInteractor {
    let url = Bundle.main.url(forResource: "testSummary", withExtension: "json")!
    let urlDetail = Bundle.main.url(forResource: "testPokemon", withExtension: "json")!
    let urlSpecies = Bundle.main.url(forResource: "testSpecies", withExtension: "json")!
    let urlEvolutions = Bundle.main.url(forResource: "testEvolutions", withExtension: "json")!

    func getPokemons(page: Int) async throws -> PokemonListResponse {
        let data = try Data(contentsOf: url)
        return try JSONDecoder().decode(PokemonListResponse.self, from: data)
    }

    func getPokemon(name: String) async throws -> Pokemon? {
        let data = try Data(contentsOf: urlDetail)
        return try JSONDecoder().decode(Pokemon.self, from: data)
    }

    func getSpecies(name: String) async throws -> PokemonSpecies {
        let data = try Data(contentsOf: urlSpecies)
        return try JSONDecoder().decode(PokemonSpecies.self, from: data)
    }

    func getEvolutions(url: URL) async throws -> EvolutionChain {
        let data = try Data(contentsOf: urlEvolutions)
        return try JSONDecoder().decode(EvolutionChain.self, from: data)
    }
}
#endif
