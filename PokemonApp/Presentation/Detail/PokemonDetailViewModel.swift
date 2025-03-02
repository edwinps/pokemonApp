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

    func fetchPokemonDetail() async {
        await setLoading(true)
        do {
            guard let pokemon = try await network.getPokemon(name: pokemonSummary.name) else {
                await setErrorMessage("Failed to load Pokémon details.")
                return
            }
            await setpokemon(pokemon)
            let pokemonSpecie = try await network.getSpecies(name: pokemon.name)
            var removeSpecies = [pokemon.name]
            removeSpecies.append(pokemonSpecie.evolvesFromSpecies?.name ?? "")
            let evolutionURLString = pokemonSpecie.evolutionChain.url
            guard  let evolutionURL = URL(string: evolutionURLString) else {
                return
            }
            let evolutions = extractEvolutionNames(from: try await network.getEvolutions(url: evolutionURL).chain)
            await setEvolutions(evolutions, removeSpecie: removeSpecies)
        } catch {
            await setErrorMessage("Failed to load Pokémon details.")
        }
        await setLoading(false)
    }
}

private extension PokemonDetailViewModel {
    @MainActor
    private func setLoading(_ loading: Bool) {
        self.isLoading = loading
    }

    @MainActor
    private func setpokemon(_ pokemon: Pokemon?) {
        self.pokemon = pokemon
    }

    @MainActor
    private func setErrorMessage(_ message: String) {
        self.errorMessage = message
    }

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
