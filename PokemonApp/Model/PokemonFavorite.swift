//
//  Item.swift
//  PokemonApp
//
//  Created by epena on 26/2/25.
//

import Foundation
import SwiftData

@Model
final class PokemonFavorite {
    @Attribute(.unique) var id: Int
    var name: String

    init (id: Int, name: String) {
        self.id = id
        self.name = name
    }
}
extension KeyPath<PokemonFavorite, Int>: @unchecked @retroactive Sendable {}
