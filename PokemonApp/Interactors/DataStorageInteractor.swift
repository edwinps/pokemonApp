//
//  DataStorageInteractor.swift
//  PokemonApp
//
//  Created by epena on 2/3/25.
//
import Foundation

protocol DataStorageInteractor {
    func loadFavorites() async -> Set<Int>
    func addFavorite(id: Int, name: String) async throws
    func removeFavorite(id: Int) async throws
}
