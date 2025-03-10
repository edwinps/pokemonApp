//
//  PokemonListView.swift
//  PokemonApp
//
//  Created by epena on 26/2/25.
//
import SwiftUI

struct PokemonListView: View {
    @StateObject private var viewModel: PokemonListViewModel
    @State private var isLoadingNextPage = false
    @State var path: [NavigationPath] = []

    init(viewModel: PokemonListViewModel)  {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        NavigationStack(path: $path) {
            ScrollView {
                PokemonListContent(viewModel: viewModel,
                                   path: $path,
                                   isLoadingNextPage: $isLoadingNextPage)
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
            LazyVStack(alignment: .leading) {
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

                Button(action: {
                    Task { [viewModel] in
                        await viewModel.toggleFavorite(for: summary)
                    }
                }) {
                    Image(systemName: viewModel.favorites.contains(summary.id) ? "star.fill" : "star")
                        .foregroundColor(viewModel.favorites.contains(summary.id) ? .yellow : .gray)
                        .padding()
                }
            }
            .background(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                    )
            .padding(.horizontal)
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
}
