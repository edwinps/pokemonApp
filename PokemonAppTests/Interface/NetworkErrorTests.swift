//
//  NetworkErrorTests.swift
//  PokemonApp
//
//  Created by epena on 1/3/25.
//
import XCTest
@testable import PokemonApp

class NetworkErrorTests: XCTestCase {

    func testNetworkError_Description() {
        // Given
        let generalError = NetworkError.general(NSError(domain: "TestDomain", code: 1, userInfo: [NSLocalizedDescriptionKey: "General failure"]))
        let statusError = NetworkError.status(404)
        let jsonError = NetworkError.json(NSError(domain: "TestDomain", code: 2, userInfo: [NSLocalizedDescriptionKey: "Invalid JSON"]))
        let noHTTPError = NetworkError.noHTTP

        // Then
        XCTAssertEqual(generalError.description, "General Error: General failure")
        XCTAssertEqual(statusError.description, "Status Error: 404")
        XCTAssertEqual(jsonError.description, "JSON error: Error Domain=TestDomain Code=2 \"Invalid JSON\" UserInfo={NSLocalizedDescription=Invalid JSON}")
        XCTAssertEqual(noHTTPError.description, "Not an HTTP call")
    }

    func testNetworkError_Equality() {
        // Given
        let error1 = NetworkError.general(NSError(domain: "TestDomain", code: 1, userInfo: [NSLocalizedDescriptionKey: "Error occurred"]))
        let error2 = NetworkError.general(NSError(domain: "TestDomain", code: 1, userInfo: [NSLocalizedDescriptionKey: "Error occurred"]))
        let error3 = NetworkError.general(NSError(domain: "TestDomain", code: 2, userInfo: [NSLocalizedDescriptionKey: "Different error"]))

        let statusError1 = NetworkError.status(500)
        let statusError2 = NetworkError.status(500)
        let statusError3 = NetworkError.status(404)

        let jsonError1 = NetworkError.json(NSError(domain: "TestDomain", code: 3, userInfo: [NSLocalizedDescriptionKey: "JSON failure"]))
        let jsonError2 = NetworkError.json(NSError(domain: "TestDomain", code: 3, userInfo: [NSLocalizedDescriptionKey: "JSON failure"]))
        let jsonError3 = NetworkError.json(NSError(domain: "TestDomain", code: 4, userInfo: [NSLocalizedDescriptionKey: "Another JSON failure"]))

        let noHTTPError1 = NetworkError.noHTTP
        let noHTTPError2 = NetworkError.noHTTP

        // Then
        XCTAssertEqual(error1, error2)
        XCTAssertNotEqual(error1, error3)

        XCTAssertEqual(statusError1, statusError2)
        XCTAssertNotEqual(statusError1, statusError3)

        XCTAssertEqual(jsonError1, jsonError2)
        XCTAssertNotEqual(jsonError1, jsonError3)

        XCTAssertEqual(noHTTPError1, noHTTPError2)
    }
}
