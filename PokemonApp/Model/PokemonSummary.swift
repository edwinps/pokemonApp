//
//  PokemonSummary.swift
//  PokemonApp
//
//  Created by epena on 1/3/25.
//

import Foundation

// MARK: - Model Structure
struct PokemonSummary: Codable, Identifiable, Hashable {
    var id: Int { Int(url.split(separator: "/").last ?? "0") ?? 0 }
    let name: String
    let url: String
}

struct PokemonListResponse: Codable {
    let results: [PokemonSummary]
    let next: String?
}
