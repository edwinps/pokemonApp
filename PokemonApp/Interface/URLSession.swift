//
//  URLSession.swift
//  PokemonApp
//
//  Created by epena on 26/2/25.
//

import Foundation

extension URLSession {
    func getData(for url: URLRequest, delegate: (URLSessionTaskDelegate)? = nil) async throws -> (Data, HTTPURLResponse) {
        do {
            let (data, response) = try await self.data(for: url, delegate: delegate)
            guard let response = response as? HTTPURLResponse else {
                throw NetworkError.noHTTP
            }
            return (data, response)
        } catch let error as NetworkError {
            throw error
        } catch {
            throw NetworkError.general(error)
        }
    }
}
