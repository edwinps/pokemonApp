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

    init(network: DataInteractor = Network(), storage: DataStorageInteractor) {
        self.network = network
        self.storage = storage
        Task { [weak self] in await self?.loadFavorites() }
    }

    enum SortOrder {
        case idAscending, idDescending, nameAscending, favoritesFirst
    }

    var filteredPokemons: [PokemonSummary] {
        let filtered = searchText.isEmpty ? pokemons : pokemons.filter { $0.name.lowercased().contains(searchText.lowercased()) }
        let uniqueFiltered = Array(Set(filtered))
        return sortPokemons(uniqueFiltered)
    }

    func fetchPokemonList() async {
        await setLoading(true)
        do {
            let pokemonListResponse = try await network.getPokemons(page: currentPage)
            if pokemonListResponse.results.isEmpty || pokemonListResponse.next == nil {
                noMorePages = true
            }
            let newPokemons = pokemonListResponse.results
            await updatePokemons(with: newPokemons)
        } catch {
            await setErrorMessage("Error fetching Pokémon list: \(error.localizedDescription)")
        }
        await setLoading(false)
    }

    func loadNextPage() async {
        guard !noMorePages else {
            return
        }
        currentPage += 1
        await fetchPokemonList()
    }

    func toggleFavorite(for summary: PokemonSummary) async {
        do {
            if favorites.contains(summary.id) {
                try await storage.removeFavorite(id: summary.id)
                await MainActor.run { [weak self] in
                    guard let self else { return }
                    _ = self.favorites.remove(summary.id) }
            } else {
                try await storage.addFavorite(id: summary.id, name: summary.name)
                await MainActor.run { [weak self] in
                    guard let self else { return }
                    _ = self.favorites.insert(summary.id)
                }
            }
        } catch {
            print("Error managing favorite: \(error.localizedDescription)")
        }
    }
}

private extension PokemonListViewModel {
    func loadFavorites() async {
        let storedFavorites = await storage.loadFavorites()
        await MainActor.run { [weak self] in
            guard let self else { return }
            self.favorites = storedFavorites
        }
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

    @MainActor
    private func setLoading(_ loading: Bool) {
        self.isLoading = loading
    }

    @MainActor
    private func updatePokemons(with newPokemons: [PokemonSummary]) {
        self.pokemons.append(contentsOf: newPokemons)
    }

    @MainActor
    private func setErrorMessage(_ message: String) {
        self.errorMessage = message
    }
}
