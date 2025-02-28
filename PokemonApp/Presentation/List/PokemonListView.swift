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

    init(viewModel: PokemonListViewModel = PokemonListViewModel()) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack {
                    ForEach(viewModel.filteredPokemons) { summary in
                        pokemonRow(for: summary)
                            .onAppear {
                                if summary == viewModel.filteredPokemons.last, !isLoadingNextPage {
                                    isLoadingNextPage = true
                                    Task { [viewModel] in
                                        await viewModel.loadNextPage()
                                    }
                                    isLoadingNextPage = false
                                }
                            }
                    }
                }
                .overlay(
                    LoadingIndicator(isLoading: viewModel.isLoading),
                    alignment: .bottom
                )
            }
            .navigationTitle("Pokémon List")
            .searchable(text: $viewModel.searchText, prompt: "Search Pokémon")
            .toolbar {
                Menu("Sort") {
                    Button("ID Ascending") { viewModel.sortOrder = .idAscending }
                    Button("ID Descending") { viewModel.sortOrder = .idDescending }
                    Button("Name Ascending") { viewModel.sortOrder = .nameAscending }
                    Button("Favorites") { viewModel.sortOrder = .favoritesFirst }
                }
            }
            .alert("Error", isPresented: .constant(viewModel.errorMessage != nil)) {
                Button("OK") { viewModel.errorMessage = nil }
            } message: {
                Text(viewModel.errorMessage ?? "")
            }
        }
        .task { [viewModel] in
            await viewModel.fetchPokemonList()
        }
    }
}

private extension PokemonListView {
    func pokemonRow(for summary: PokemonSummary) -> some View {
        HStack {
            Text(summary.name.capitalized)
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)

            Button(action: {
                // favorites
            }) {
                Image(systemName: viewModel.favorites.contains(summary.name) ? "star.fill" : "star")
                    .foregroundColor(viewModel.favorites.contains(summary.name) ? .yellow : .gray)
                    .padding()
            }
        }
        .background(RoundedRectangle(cornerRadius: 10).fill(Color.blue.opacity(0.8)))
        .padding(.horizontal)
    }
}

#Preview {
    PokemonListView(viewModel: PokemonListViewModel.test)
        .modelContainer(for: Item.self, inMemory: true)
}
