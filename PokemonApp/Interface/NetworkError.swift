//
//  NetworkError.swift
//  PokemonApp
//
//  Created by epena on 26/2/25.
//

import Foundation

enum NetworkError: Error, CustomStringConvertible, Equatable {
    case general(Error)
    case status(Int)
    case json(Error)
    case noHTTP

    public var description: String {
        switch self {
        case .general(let error):
            return "General Error: \(error.localizedDescription)"
        case .status(let int):
            return "Status Error: \(int)"
        case .json(let error):
            return "JSON error: \(error)"
        case .noHTTP:
            return "Not an HTTP call"
        }
    }

    static func == (lhs: NetworkError, rhs: NetworkError) -> Bool {
        switch (lhs, rhs) {
        case (.general(let error1), .general(let error2)):
            return error1.localizedDescription == error2.localizedDescription
        case (.status(let code1), .status(let code2)):
            return code1 == code2
        case (.json(let error1), .json(let error2)):
            return error1.localizedDescription == error2.localizedDescription
        case (.noHTTP, .noHTTP):
            return true
        default:
            return false
        }
    }
}
