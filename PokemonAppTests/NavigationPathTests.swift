//
//  UntNavigationPathTestsitled.swift
//  PokemonApp
//
//  Created by epena on 1/3/25.
//
import XCTest
@testable import PokemonApp

class NavigationPathTests: XCTestCase {

    func testNavigationPath_Equality() {
        // Given
        let summary1 = PokemonSummary(name: "Pikachu", url: "https://pokeapi.co/api/v2/pokemon/25/")
        let summary2 = PokemonSummary(name: "Pikachu", url: "https://pokeapi.co/api/v2/pokemon/25/")
        let summary3 = PokemonSummary(name: "Bulbasaur", url: "https://pokeapi.co/api/v2/pokemon/1/")

        let viewModel1 = PokemonDetailViewModel(pokemonSummary: summary1)
        let viewModel2 = PokemonDetailViewModel(pokemonSummary: summary2)
        let viewModel3 = PokemonDetailViewModel(pokemonSummary: summary3)

        let path1 = NavigationPath.detail(viewModel1)
        let path2 = NavigationPath.detail(viewModel2)
        let path3 = NavigationPath.detail(viewModel3)

        // Then
        XCTAssertEqual(path1, path2)
        XCTAssertNotEqual(path1, path3)
    }

    func testNavigationPath_Hashing() {
        // Given
        let summary1 = PokemonSummary(name: "Pikachu", url: "https://pokeapi.co/api/v2/pokemon/25/")
        let summary2 = PokemonSummary(name: "Pikachu", url: "https://pokeapi.co/api/v2/pokemon/25/")
        let summary3 = PokemonSummary(name: "Bulbasaur", url: "https://pokeapi.co/api/v2/pokemon/1/")

        let viewModel1 = PokemonDetailViewModel(pokemonSummary: summary1)
        let viewModel2 = PokemonDetailViewModel(pokemonSummary: summary2)
        let viewModel3 = PokemonDetailViewModel(pokemonSummary: summary3)

        let path1 = NavigationPath.detail(viewModel1)
        let path2 = NavigationPath.detail(viewModel2)
        let path3 = NavigationPath.detail(viewModel3)

        var hashSet: Set<NavigationPath> = []

        // When
        hashSet.insert(path1)
        hashSet.insert(path2)
        hashSet.insert(path3)

        // Then
        XCTAssertEqual(hashSet.count, 2)
        XCTAssertTrue(hashSet.contains(path1))
        XCTAssertTrue(hashSet.contains(path3))
    }
}
