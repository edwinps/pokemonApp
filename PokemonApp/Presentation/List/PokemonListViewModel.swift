//
//  PokemonListViewModel.swift
//  PokemonApp
//
//  Created by epena on 26/2/25.
//

import SwiftUI
import SwiftData

final class PokemonListViewModel: ObservableObject {
    private var network: DataInteractor
    private let storage: DataStorageInteractor
    private var currentPage = 0

    @Published var pokemons: [PokemonSummary] = []
    @Published var searchText: String = ""
    @Published var sortOrder: SortOrder = .idAscending
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var favorites: Set<Int> = []
    private var noMorePages = false

    @MainActor
    init(network: DataInteractor = Network(), storage: DataStorageInteractor) {
        self.network = network
        self.storage = storage
        Task { @MainActor [weak self] in
            await self?.loadFavorites()
        }
    }

    enum SortOrder {
        case idAscending, idDescending, nameAscending, favoritesFirst
    }

    var filteredPokemons: [PokemonSummary] {
        let filtered = searchText.isEmpty
        ? pokemons
        : pokemons.filter { $0.name.lowercased().contains(searchText.lowercased()) }
        let uniqueFiltered = Array(Set(filtered))
        return sortPokemons(uniqueFiltered)
    }

    @MainActor
    func firstPage() async {
        await fetchPokemonList()
    }

    @MainActor
    func loadNextPage() async {
        guard !noMorePages else {
            return
        }
        currentPage += 1
        await fetchPokemonList()
    }

    @MainActor
    func toggleFavorite(for summary: PokemonSummary) async {
        do {
            if favorites.contains(summary.id) {
                try await storage.removeFavorite(id: summary.id)
                _ = self.favorites.remove(summary.id)
            } else {
                try await storage.addFavorite(id: summary.id, name: summary.name)
                _ = self.favorites.insert(summary.id)
            }
        } catch {
            print("Error managing favorite: \(error.localizedDescription)")
        }
    }
}

private extension PokemonListViewModel {
    @MainActor
    func fetchPokemonList() async {
        isLoading =  true
        do {
            let pokemonListResponse = try await network.getPokemons(page: currentPage)
            if pokemonListResponse.results.isEmpty || pokemonListResponse.next == nil {
                noMorePages = true
            }
            let newPokemons = pokemonListResponse.results
            updatePokemons(with: newPokemons)
        } catch {
            errorMessage = "Error fetching Pokémon list: \(error.localizedDescription)"
        }
        isLoading = false
    }

    @MainActor
    func loadFavorites() async {
        let storedFavorites = await storage.loadFavorites()
        self.favorites = storedFavorites
    }

    func sortPokemons(_ list: [PokemonSummary]) -> [PokemonSummary] {
        switch sortOrder {
        case .idAscending:
            return list.sorted { $0.id < $1.id }
        case .idDescending:
            return list.sorted { $0.id > $1.id }
        case .nameAscending:
            return list.sorted { $0.name < $1.name }
        case .favoritesFirst:
            return list.sorted { (pokemon1, pokemon2) -> Bool in
                let fav1 = favorites.contains(pokemon1.id)
                let fav2 = favorites.contains(pokemon2.id)
                if fav1 == fav2 {
                    return pokemon1.name < pokemon2.name
                }
                return fav1
            }
        }
    }

    private func updatePokemons(with newPokemons: [PokemonSummary]) {
        self.pokemons.append(contentsOf: newPokemons)
    }

}
