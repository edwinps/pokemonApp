//
//  URLSessionExtensionTests.swift
//  PokemonApp
//
//  Created by epena on 1/3/25.
//

import XCTest
@testable import PokemonApp

class URLSessionExtensionTests: XCTestCase {

    var session: URLSession!

    override func setUp() {
        super.setUp()
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockURLProtocol.self] 
        session = URLSession(configuration: config)
    }

    override func tearDown() {
        session = nil
        MockURLProtocol.mockError = nil
        super.tearDown()
    }

    func testGetData_NetworkFailure() async {
        // Given
        let networkError = NSError(domain: NSURLErrorDomain, code: NSURLErrorNotConnectedToInternet, userInfo: nil)
        MockURLProtocol.mockError = networkError

        let request = URLRequest(url: URL(string: "https://example.com")!)

        do {
            // When
            _ = try await session.getData(for: request)
            XCTFail("The request should have failed with a general network error")
        } catch let error as NetworkError {
            // Then
            if case .general(let underlyingError) = error {
                XCTAssertEqual(underlyingError.localizedDescription, networkError.localizedDescription)
            } else {
                XCTFail("Expected a general NetworkError but got \(error)")
            }
        } catch {
            XCTFail("An unexpected error was thrown: \(error)")
        }
    }
}
