//
//  MockURLProtocol.swift
//  PokemonApp
//
//  Created by epena on 28/2/25.
//

import XCTest
@testable import PokemonApp

class MockURLProtocol: URLProtocol {
    static var mockResponse: (Data, HTTPURLResponse)?
    static var mockError: Error?

    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }

    override func startLoading() {
        if let error = MockURLProtocol.mockError {
            client?.urlProtocol(self, didFailWithError: error)
        } else if let (mockData, response) = MockURLProtocol.mockResponse {
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            client?.urlProtocol(self, didLoad: mockData)
        }
        client?.urlProtocolDidFinishLoading(self)
    }

    override func stopLoading() {}
}
