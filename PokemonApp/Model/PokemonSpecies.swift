//
//  PokemonSpecies.swift
//  PokemonApp
//
//  Created by epena on 1/3/25.
//

import Foundation

struct PokemonSpecies: Codable {
    let evolutionChain: EvolutionChainReference
    let evolvesFromSpecies: EvolutionSpecies?
    enum CodingKeys: String, CodingKey {
        case evolutionChain = "evolution_chain"
        case evolvesFromSpecies = "evolves_from_species"
    }
}

struct EvolutionChainReference: Codable {
    let url: String
}

struct EvolutionChain: Codable {
    let chain: EvolutionChainLink
}

struct EvolutionChainLink: Codable {
    let species: EvolutionSpecies
    let evolvesTo: [EvolutionChainLink]

    enum CodingKeys: String, CodingKey {
        case species
        case evolvesTo = "evolves_to"
    }
}

struct EvolutionSpecies: Codable {
    let name: String
}
