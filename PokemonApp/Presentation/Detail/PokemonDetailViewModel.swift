//
//  PokemonDetailViewModel.swift
//  PokemonApp
//
//  Created by epena on 28/2/25.
//

import SwiftUI

final class PokemonDetailViewModel: ObservableObject {
    private var network: DataInteractor
    let pokemonSummary: PokemonSummary
    @Published var pokemon: Pokemon?
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var evolutions: [String] = []

    init(network: DataInteractor = Network(),
         pokemonSummary: PokemonSummary) {
        self.network = network
        self.pokemonSummary = pokemonSummary
    }

    @MainActor
    func fetchPokemonDetail() async {
        self.isLoading = true
        do {
            guard let pokemon = try await network.getPokemon(name: pokemonSummary.name) else {
                self.errorMessage = "Failed to load Pokémon details."
                return
            }
            self.pokemon = pokemon
            let pokemonSpecie = try await network.getSpecies(name: pokemon.name)
            var removeSpecies = [pokemon.name]
            removeSpecies.append(pokemonSpecie.evolvesFromSpecies?.name ?? "")
            let evolutionURLString = pokemonSpecie.evolutionChain.url
            guard  let evolutionURL = URL(string: evolutionURLString) else {
                return
            }
            let evolutions = extractEvolutionNames(from: try await network.getEvolutions(url: evolutionURL).chain)
            setEvolutions(evolutions, removeSpecie: removeSpecies)
        } catch {
            self.errorMessage = "Failed to load Pokémon details."
        }
        self.isLoading = false
    }
}

private extension PokemonDetailViewModel {
    @MainActor
    private func setEvolutions(_ evolutions: [String], removeSpecie: [String]) {
        self.evolutions = evolutions
        self.evolutions.removeAll(where: removeSpecie.contains)
    }

    private func extractEvolutionNames(from chain: EvolutionChainLink) -> [String] {
        var evolutions: [String] = []

        var current = chain.evolvesTo
        while !current.isEmpty {
            let nextEvolutions = current.map { $0.species.name }
            evolutions.append(contentsOf: nextEvolutions)
            current = current.flatMap { $0.evolvesTo }
        }

        return evolutions
    }
}
