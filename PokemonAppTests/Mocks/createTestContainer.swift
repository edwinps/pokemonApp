//
//  Untitled.swift
//  PokemonApp
//
//  Created by epena on 2/3/25.
//
import XCTest
import SwiftData
@testable import PokemonApp

func createTestContainer() -> ModelContainer {
    let schema = Schema([PokemonFavorite.self])
    let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)

    do {
        return try ModelContainer(for: schema, configurations: [modelConfiguration])
    } catch {
        fatalError("Could not create ModelContainer for tests: \(error)")
    }
}
