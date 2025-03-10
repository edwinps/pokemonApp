//
//  DataStorage.swift
//  PokemonApp
//
//  Created by epena on 2/3/25.
//
import SwiftUI
import SwiftData

@MainActor
final class DataStorage: DataStorageInteractor {
    private let modelContext: ModelContext?
    private let modelContainer: ModelContainer

    struct Constants {
        static let modelName = "PokemonFavorite"
    }

    init(mmodelContainer: ModelContainer) {
        self.modelContainer = mmodelContainer
        self.modelContext = mmodelContainer.mainContext
    }

    init(isStoredInMemoryOnly: Bool = false) {

        let schema = Schema([PokemonFavorite.self])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: isStoredInMemoryOnly)

        do {
            let container = try ModelContainer(for: schema, configurations: [modelConfiguration])
            modelContainer = container
            modelContext = container.mainContext
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }

    func loadFavorites() async -> Set<Int> {
        let fetchDescriptor = FetchDescriptor<PokemonFavorite>()
        do {
            let storedFavorites = try modelContext?.fetch(fetchDescriptor) ?? []
            return Set(storedFavorites.map { $0.id })
        } catch {
            print("Error fetching favorites: \(error.localizedDescription)")
            return []
        }
    }

    func addFavorite(id: Int, name: String) async throws {
        let favorite = PokemonFavorite(id: id, name: name)
        modelContext?.insert(favorite)
        do {
            try modelContext?.save()
        } catch {
            throw SwiftDataError.saveError(error)
        }
    }

    func removeFavorite(id: Int) async throws {
        let fetchDescriptor = FetchDescriptor<PokemonFavorite>(predicate: #Predicate { $0.id == id })
        do {
            if let favorite = try modelContext?.fetch(fetchDescriptor).first {
                modelContext?.delete(favorite)
                try modelContext?.save()
            }
        } catch {
            throw SwiftDataError.deleteError(error)
        }
    }
}
