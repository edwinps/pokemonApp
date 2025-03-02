//
//  PokemonListView.swift
//  PokemonApp
//
//  Created by epena on 26/2/25.
//
import SwiftUI

struct PokemonListView: View {
    @Environment(\.modelContext) private var modelContext
    @StateObject private var viewModel: PokemonListViewModel
    @State private var isLoadingNextPage = false
    @State var path: [NavigationPath] = []

    init(viewModel: PokemonListViewModel = PokemonListViewModel()) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        NavigationStack(path: $path) {
            ScrollView {
                LazyVStack {
                    ForEach(viewModel.filteredPokemons) { summary in
                        PokemonListContent(viewModel: viewModel,
                                           path: $path,
                                           isLoadingNextPage: $isLoadingNextPage)
                    }
                }
                .overlay(
                    LoadingIndicator(isLoading: viewModel.isLoading),
                    alignment: .bottom
                )
            }
            .navigationTitle("Pokémon List")
            .searchable(text: $viewModel.searchText, prompt: "Search Pokémon")
            .toolbar { sortingMenu }
            .alert("Error", isPresented: .constant(viewModel.errorMessage != nil)) {
                Button("OK") { viewModel.errorMessage = nil }
            } message: {
                Text(viewModel.errorMessage ?? "")
            }
            .navigationDestination(for: NavigationPath.self) { screen in
                destinationView(for: screen)
            }
        }
        .task { [viewModel] in
            await viewModel.fetchPokemonList()
        }
    }
}

private extension PokemonListView {
    struct PokemonListContent: View {
        @ObservedObject var viewModel: PokemonListViewModel
        @Binding var path: [NavigationPath]
        @Binding var isLoadingNextPage: Bool

        var body: some View {
            LazyVStack {
                ForEach(viewModel.filteredPokemons) { summary in
                    Button(action: {
                        let viewModel = PokemonDetailViewModel(pokemonSummary: summary)
                        path.append(.detail(viewModel))
                    }) {
                        pokemonRow(for: summary)
                            .onAppear {
                                loadNextPageIfNeeded(for: summary)
                            }
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .overlay(
                LoadingIndicator(isLoading: viewModel.isLoading),
                alignment: .bottom
            )
        }

        func loadNextPageIfNeeded(for summary: PokemonSummary) {
            guard summary == viewModel.filteredPokemons.last,
                  !isLoadingNextPage else { return }
            isLoadingNextPage = true
            Task { [viewModel] in
                await viewModel.loadNextPage()
            }
            isLoadingNextPage = false
        }

        func pokemonRow(for summary: PokemonSummary) -> some View {
            HStack {
                Text(summary.name.capitalized)
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)

                Button(action: { toggleFavorite(for: summary) }) {
                    Image(systemName: viewModel.favorites.contains(summary.name) ? "star.fill" : "star")
                        .foregroundColor(viewModel.favorites.contains(summary.name) ? .yellow : .gray)
                        .padding()
                }
            }
            .background(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                    )
            .padding(.horizontal)
        }

        func toggleFavorite(for summary: PokemonSummary) {
            if viewModel.favorites.contains(summary.name) {
                viewModel.favorites.remove(summary.name)
            } else {
                viewModel.favorites.insert(summary.name)
            }
        }
    }
    var sortingMenu: some View {
        Menu("Sort") {
            Button("ID Ascending") { viewModel.sortOrder = .idAscending }
            Button("ID Descending") { viewModel.sortOrder = .idDescending }
            Button("Name Ascending") { viewModel.sortOrder = .nameAscending }
            Button("Favorites") { viewModel.sortOrder = .favoritesFirst }
        }
    }

    func destinationView(for screen: NavigationPath) -> some View {
        switch screen {
        case .detail(let viewModel):
            return AnyView(PokemonDetailView(viewModel: viewModel, path: $path))
        }
    }
}

#Preview {
    PokemonListView(viewModel: PokemonListViewModel.test)
        .modelContainer(for: Item.self, inMemory: true)
}
