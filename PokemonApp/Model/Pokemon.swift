//
//  Pokemon.swift
//  PokemonApp
//
//  Created by epena on 26/2/25.
//



struct Pokemon: Codable, Identifiable {
    let id: Int
    let name: String
    let sprites: Sprites
    let types: [PokemonType]
    let stats: [PokemonStat]
}

struct Sprites: Codable {
    let front_default: String?
}

struct PokemonType: Codable {
    let type: TypeDetail
}

struct TypeDetail: Codable {
    let name: String
}

struct PokemonStat: Codable {
    let base_stat: Int
    let stat: StatDetail
}

struct StatDetail: Codable {
    let name: String
}

struct PokemonResponse: Codable {
    let results: [Pokemon]
}
