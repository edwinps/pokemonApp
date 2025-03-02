//
//  PokemonListViewModelTests.swift
//  PokemonApp
//
//  Created by epena on 28/2/25.
//

import XCTest
import Combine
@testable import PokemonApp

class PokemonListViewModelTests: XCTestCase {
    var viewModel: PokemonListViewModel!
    var mockNetwork: MockDataInteractor!
    var mockStorage: MockDataStorageInteractor!
    var cancellables: Set<AnyCancellable> = []

    @MainActor
    override func setUp() {
        super.setUp()
        mockNetwork = MockDataInteractor()
        mockStorage = MockDataStorageInteractor()
        viewModel = PokemonListViewModel(network: mockNetwork, storage: mockStorage)
    }

    override func tearDown() {
        viewModel = nil
        mockNetwork = nil
        cancellables.removeAll()
        super.tearDown()
    }

    func testFetchPokemonList_Success() async {
        // Given
        let expectedPokemons = [
            PokemonSummary(name: "Pikachu", url: "https://pokeapi.co/api/v2/pokemon/25/"),
            PokemonSummary(name: "Bulbasaur", url: "https://pokeapi.co/api/v2/pokemon/1/")
        ]
        let expectedResponse = PokemonListResponse(results: expectedPokemons, next: "https://pokeapi.co/api/v2/pokemon?page=2")
        mockNetwork.mockPokemonListResponse = expectedResponse

        let expectation = XCTestExpectation(description: "Pokemon list should be updated")

        viewModel.$pokemons
            .dropFirst()
            .sink { pokemons in
                if !pokemons.isEmpty {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)

        // When
        await viewModel.fetchPokemonList()

        // Then
        await fulfillment(of: [expectation], timeout: 2)
        XCTAssertEqual(viewModel.pokemons.count, 2)
        XCTAssertEqual(viewModel.pokemons.first?.name, "Pikachu")
        XCTAssertFalse(viewModel.pokemons.isEmpty)
    }

    func testFetchPokemonList_Failure() async {
        // Given
        mockNetwork.shouldThrowError = true

        let expectation = XCTestExpectation(description: "Error message should be set")

        viewModel.$errorMessage
            .dropFirst()
            .sink { errorMessage in
                if errorMessage != nil {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)

        // When
        await viewModel.fetchPokemonList()

        // Then
        await fulfillment(of: [expectation], timeout: 2)
        XCTAssertNotNil(viewModel.errorMessage)
        XCTAssertTrue(viewModel.pokemons.isEmpty)
    }

    func testLoadNextPage_NoMorePages() async {
        // Given
        viewModel.pokemons = []

        // When
        await viewModel.loadNextPage()

        // Then
        XCTAssertEqual(viewModel.pokemons.count, 0)

        // When
        await viewModel.loadNextPage()

        // Then
        XCTAssertEqual(viewModel.pokemons.count, 0)
    }

    func testLoadNextPage() async {
        // Given
        let firstPagePokemons = [
            PokemonSummary(name: "Charmander", url: "https://pokeapi.co/api/v2/pokemon/4/")
        ]
        let secondPagePokemons = [
            PokemonSummary(name: "Squirtle", url: "https://pokeapi.co/api/v2/pokemon/7/")
        ]

        mockNetwork.mockPokemonListResponse = PokemonListResponse(results: firstPagePokemons, next: "next-url")
        await viewModel.fetchPokemonList()

        XCTAssertEqual(viewModel.pokemons.count, 1)
        XCTAssertEqual(viewModel.pokemons.first?.name, "Charmander")

        mockNetwork.mockPokemonListResponse = PokemonListResponse(results: secondPagePokemons, next: nil)
        await viewModel.loadNextPage()

        XCTAssertEqual(viewModel.pokemons.count, 2)
        XCTAssertEqual(viewModel.pokemons.last?.name, "Squirtle")
    }

    func testFilteredPokemons_SearchFilter() {
        // Given
        viewModel.pokemons = [
            PokemonSummary(name: "Pikachu", url: ""),
            PokemonSummary(name: "Bulbasaur", url: ""),
            PokemonSummary(name: "Charmander", url: "")
        ]

        // When
        viewModel.searchText = "char"

        // Then
        XCTAssertEqual(viewModel.filteredPokemons.count, 1)
        XCTAssertEqual(viewModel.filteredPokemons.first?.name, "Charmander")
    }

    func testSortPokemons() {
        // Given
        viewModel.pokemons = [
            PokemonSummary(name: "Bulbasaur", url: "https://pokeapi.co/api/v2/pokemon/1/"),
            PokemonSummary(name: "Charmander", url: "https://pokeapi.co/api/v2/pokemon/4/"),
            PokemonSummary(name: "Pikachu", url: "https://pokeapi.co/api/v2/pokemon/25/")
        ]
        viewModel.favorites = [25]

        viewModel.sortOrder = .idAscending
        XCTAssertEqual(viewModel.filteredPokemons.first?.name, "Bulbasaur")

        viewModel.sortOrder = .idDescending
        XCTAssertEqual(viewModel.filteredPokemons.first?.name, "Pikachu")

        viewModel.sortOrder = .nameAscending
        XCTAssertEqual(viewModel.filteredPokemons.first?.name, "Bulbasaur")

        viewModel.sortOrder = .favoritesFirst
        XCTAssertEqual(viewModel.filteredPokemons.first?.name, "Pikachu")
    }

    func testFavorites_AddAndRemove() {
        // Given
        let pikachu = PokemonSummary(name: "Pikachu", url: "https://pokeapi.co/api/v2/pokemon/25/")
        viewModel.pokemons = [pikachu]

        // When - Adding favorite
        viewModel.favorites.insert(25)

        // Then
        XCTAssertTrue(viewModel.favorites.contains(25))

        // When - Removing favorite
        viewModel.favorites.remove(25)

        // Then
        XCTAssertFalse(viewModel.favorites.contains(25))
    }

    func testSortPokemons_FavoritesFirst() {
        // Given
        let bulbasaur = PokemonSummary(name: "Bulbasaur", url: "https://pokeapi.co/api/v2/pokemon/1/")
        let charmander = PokemonSummary(name: "Charmander", url: "https://pokeapi.co/api/v2/pokemon/4/")
        let pikachu = PokemonSummary(name: "Pikachu", url: "https://pokeapi.co/api/v2/pokemon/25/")

        viewModel.pokemons = [bulbasaur, charmander, pikachu]
        viewModel.favorites = [25]

        // When
        viewModel.sortOrder = .favoritesFirst

        // Then
        XCTAssertEqual(viewModel.filteredPokemons.first?.name, "Pikachu")
    }

    func testToggleFavorite_AddsFavorite() async {
        // Given
        let pokemon = PokemonSummary(name: "Pikachu", url: "https://pokeapi.co/api/v2/pokemon/25/")

        // When
        await viewModel.toggleFavorite(for: pokemon)

        // Then
        XCTAssertTrue(viewModel.favorites.contains(pokemon.id), "Pikachu should be added to favorites")
        XCTAssertTrue(mockStorage.addFavoriteCalled, "addFavorite should have been called")
    }

    func testToggleFavorite_RemovesFavorite() async {
        // Given
        let pokemon = PokemonSummary(name: "Pikachu", url: "https://pokeapi.co/api/v2/pokemon/25/")
        await viewModel.toggleFavorite(for: pokemon)
        XCTAssertTrue(viewModel.favorites.contains(pokemon.id))

        // When
        await viewModel.toggleFavorite(for: pokemon)

        // Then
        XCTAssertFalse(viewModel.favorites.contains(pokemon.id), "Pikachu should be removed from favorites")
        XCTAssertTrue(mockStorage.removeFavoriteCalled, "removeFavorite should have been called")
    }
}
