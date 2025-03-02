//
//  SwiftDataError.swift
//  PokemonApp
//
//  Created by epena on 2/3/25.
//

import Foundation

enum SwiftDataError: Error, CustomStringConvertible, Equatable {
    case saveError(Error)
    case deleteError(Error)
    case fetchError(Error)

    var description: String {
        switch self {
        case .saveError(let error):
            return "Failed to save data: \(error.localizedDescription)"
        case .deleteError(let error):
            return "Failed to delete data: \(error.localizedDescription)"
        case .fetchError(let error):
            return "Failed to fetch data: \(error.localizedDescription)"
        }
    }

    static func == (lhs: SwiftDataError, rhs: SwiftDataError) -> Bool {
        switch (lhs, rhs) {
        case (.saveError(let error1), .saveError(let error2)),
             (.deleteError(let error1), .deleteError(let error2)),
             (.fetchError(let error1), .fetchError(let error2)):
            return error1.localizedDescription == error2.localizedDescription
        default:
            return false
        }
    }
}
