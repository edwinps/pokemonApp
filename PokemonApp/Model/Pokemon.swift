//
//  Pokemon.swift
//  PokemonApp
//
//  Created by epena on 26/2/25.
//

import Foundation

// MARK: - Model Structure
struct PokemonSummary: Codable, Identifiable, Hashable {
    var id: String { url }
    let name: String
    let url: String
}

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

struct PokemonListResponse: Codable {
    let results: [PokemonSummary]
}

struct PokemonResponse: Codable {
    let results: [Pokemon]
}
