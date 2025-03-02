//
//  URL.swift
//  PokemonApp
//
//  Created by epena on 26/2/25.
//

import Foundation

let api = URL(string: "https://pokeapi.co/api/v2/")!

extension URL {
    static let getPokemonList = api.appending(path: "pokemon")
    static let getPokemon = api.appending(path: "pokemon")
    static let getPokemonSpecies = api.appending(path: "pokemon-species")
}
