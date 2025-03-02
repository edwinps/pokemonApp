//
//  DataStorageTests.swift
//  PokemonApp
//
//  Created by epena on 2/3/25.
//

import XCTest
import SwiftData
@testable import PokemonApp

@MainActor
final class DataStorageTests: XCTestCase {
    var dataStorage: DataStorage!
    var testContainer: ModelContainer!

    override func setUp() {
        super.setUp()
        testContainer = createTestContainer()
        dataStorage = DataStorage(mmodelContainer: testContainer)
    }

    override func tearDown() {
        dataStorage = nil
        testContainer = nil
        super.tearDown()
    }

    func testAddFavorite() async throws {
        // Given
        let id = 25
        let name = "Pikachu"

        // When
        try await dataStorage.addFavorite(id: id, name: name)
        let favorites = await dataStorage.loadFavorites()

        // Then
        XCTAssertTrue(favorites.contains(id), "Pikachu should be added to favorites")
    }

    func testRemoveFavorite() async throws {
        // Given
        let id = 25
        let name = "Pikachu"
        try await dataStorage.addFavorite(id: id, name: name)
        var favorites = await dataStorage.loadFavorites()
        XCTAssertTrue(favorites.contains(id))

        // When
        try await dataStorage.removeFavorite(id: id)
        favorites = await dataStorage.loadFavorites()

        // Then
        XCTAssertFalse(favorites.contains(id), "Pikachu should be removed from favorites")
    }

    func testLoadFavorites_Empty() async {
        // When
        let favorites = await dataStorage.loadFavorites()

        // Then
        XCTAssertTrue(favorites.isEmpty, "Favorites should be empty initially")
    }
}
