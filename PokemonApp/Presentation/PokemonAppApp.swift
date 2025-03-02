//
//  PokemonAppApp.swift
//  PokemonApp
//
//  Created by epena on 26/2/25.
//

import SwiftUI
import SwiftData

@main
struct PokemonAppApp: App {
    var body: some Scene {
        WindowGroup {
            let storageService = DataStorage(isStoredInMemoryOnly: false)
            let viewModel = PokemonListViewModel(storage: storageService)
            PokemonListView(viewModel: viewModel)
        }
    }
}
