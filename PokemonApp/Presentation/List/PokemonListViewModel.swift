//
//  PokemonListViewModel.swift
//  PokemonApp
//
//  Created by epena on 26/2/25.
//

import SwiftUI

final class PokemonListViewModel: ObservableObject {
    private var network: DataInteractor
    private var currentPage = 0
    @Published var pokemons: [PokemonSummary] = []
    @Published var searchText: String = ""
    @Published var sortOrder: SortOrder = .idAscending
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var favorites: Set<String> = []
    private var noMorePages = false

    init(network: DataInteractor = Network()) {
        self.network = network
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
            guard !pokemonListResponse.results.isEmpty || pokemonListResponse.next == nil else {
                noMorePages = true
                return
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
}

private extension PokemonListViewModel {
    func sortPokemons(_ list: [PokemonSummary]) -> [PokemonSummary] {
        switch sortOrder {
        case .idAscending:
            return list.sorted { $0.id < $1.id }
        case .idDescending:
            return list.sorted { $0.id > $1.id }
        case .nameAscending:
            return list.sorted { $0.name < $1.name }
        case .favoritesFirst:
            return list.sorted { favorites.contains($0.name) && !favorites.contains($1.name) }
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
