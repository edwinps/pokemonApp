//
//  MangaNavigation.swift
//  PokemonApp
//
//  Created by epena on 28/2/25.
//

import SwiftUI

enum NavigationPath: Hashable {
    case detail(PokemonDetailViewModel)

    static func == (lhs: NavigationPath, rhs: NavigationPath) -> Bool {
        switch (lhs, rhs) {
        case let (.detail(viewModel1), .detail(viewModel2)):
            return viewModel1.pokemonSummary.id == viewModel2.pokemonSummary.id
        }
    }

    func hash(into hasher: inout Hasher) {
        switch self {
        case .detail(let viewModel):
            return hasher.combine(viewModel.pokemonSummary.id)
        }
    }
}
