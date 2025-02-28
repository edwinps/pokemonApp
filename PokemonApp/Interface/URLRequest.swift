//
//  URLRequest.swift
//  PokemonApp
//
//  Created by epena on 26/2/25.
//

import Foundation

extension URLRequest {
    static func get(url: URL,
                    queryParams: [URLQueryItem]? = nil) -> URLRequest {
        var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true)
        urlComponents?.queryItems = queryParams
        var request = URLRequest(url: urlComponents?.url ?? url)
        request.timeoutInterval = 60
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        return request
    }
}
