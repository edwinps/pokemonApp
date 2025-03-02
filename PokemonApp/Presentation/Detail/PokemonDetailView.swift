//
//  PokemonDetailView.swift
//  PokemonApp
//
//  Created by epena on 28/2/25.
//

import SwiftUI

struct PokemonDetailView: View {
    @ObservedObject var viewModel: PokemonDetailViewModel
    @Binding var path: [NavigationPath]

    var body: some View {
        HStack(alignment: .top) {
            if viewModel.isLoading {
                LoadingIndicator(isLoading: true)
            } else if let pokemon = viewModel.pokemon {
                VStack(alignment: .center, spacing: 8) {
                    AsyncImage(url: URL(string: pokemon.sprites.front_default ?? "")) { image in
                        image.resizable().scaledToFit()
                    } placeholder: {
                        LoadingIndicator(isLoading: true)
                    }
                    .frame(width: 200, height: 200)
                    .padding(.top, 20)

                    Text(pokemon.name.capitalized)
                        .font(.largeTitle)
                        .fontWeight(.bold)

                    HStack {
                        Text("Types:")
                            .font(.headline)
                        ForEach(pokemon.types, id: \ .type.name) { type in
                            Text(type.type.name.capitalized)
                                .padding(6)
                                .background(RoundedRectangle(cornerRadius: 8).fill(Color.blue.opacity(0.7)))
                                .foregroundColor(.white)
                        }
                    }
                    if !viewModel.evolutions.isEmpty {
                        Text("Evolutions")
                            .font(.headline)
                            .padding(.horizontal)

                            HStack {
                                ForEach(viewModel.evolutions, id: \ .self) { evolution in
                                    Button(action: {
                                        let summary = PokemonSummary(name: evolution, url: "")
                                        let newViewModel = PokemonDetailViewModel(pokemonSummary: summary)
                                        path.append(.detail(newViewModel))
                                    }) {
                                        VStack {
                                            Text(evolution.capitalized)
                                                .font(.caption)
                                                .padding(6)
                                                .background(RoundedRectangle(cornerRadius: 8).fill(Color.green.opacity(0.7)))
                                                .foregroundColor(.white)
                                        }
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                }
                            }
                            .padding(.horizontal)
                    }
                    Spacer()
                }
                .padding()
            } else if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
            } else {
                Text(viewModel.pokemonSummary.name.capitalized)
                    .font(.largeTitle)
                    .fontWeight(.bold)
            }
        }
        .onAppear {
            Task { [viewModel] in
                await viewModel.fetchPokemonDetail()
            }
        }
    }
}

#Preview {
    PokemonDetailView(viewModel: .test, path: .constant([]))
}
