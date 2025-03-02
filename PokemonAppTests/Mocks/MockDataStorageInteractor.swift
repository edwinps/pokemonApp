//
//  MockDataStorageInteractor.swift
//  PokemonApp
//
//  Created by epena on 2/3/25.
//

import XCTest
@testable import PokemonApp

class MockDataStorageInteractor: DataStorageInteractor {
    var favorites: Set<Int> = []
    var addFavoriteCalled = false
    var removeFavoriteCalled = false

    func loadFavorites() async -> Set<Int> {
        return favorites
    }

    func addFavorite(id: Int, name: String) async throws {
        favorites.insert(id)
        addFavoriteCalled = true
    }

    func removeFavorite(id: Int) async throws {
        favorites.remove(id)
        removeFavoriteCalled = true
    }
}
