//
//  SwiftDataError.swift
//  PokemonApp
//
//  Created by epena on 2/3/25.
//

import XCTest
@testable import PokemonApp

final class SwiftDataErrorTests: XCTestCase {

    func testSaveErrorDescription() {
        let underlyingError = NSError(domain: "Test", code: 1, userInfo: [NSLocalizedDescriptionKey: "Save failed"])
        let error = SwiftDataError.saveError(underlyingError)

        XCTAssertEqual(error.description, "Failed to save data: Save failed")
    }

    func testDeleteErrorDescription() {
        let underlyingError = NSError(domain: "Test", code: 2, userInfo: [NSLocalizedDescriptionKey: "Delete failed"])
        let error = SwiftDataError.deleteError(underlyingError)

        XCTAssertEqual(error.description, "Failed to delete data: Delete failed")
    }

    func testFetchErrorDescription() {
        let underlyingError = NSError(domain: "Test", code: 3, userInfo: [NSLocalizedDescriptionKey: "Fetch failed"])
        let error = SwiftDataError.fetchError(underlyingError)

        XCTAssertEqual(error.description, "Failed to fetch data: Fetch failed")
    }

    func testSwiftDataErrorEquality() {
        let error1 = SwiftDataError.saveError(NSError(domain: "Test", code: 1, userInfo: [NSLocalizedDescriptionKey: "Error"]))
        let error2 = SwiftDataError.saveError(NSError(domain: "Test", code: 1, userInfo: [NSLocalizedDescriptionKey: "Error"]))
        let error3 = SwiftDataError.deleteError(NSError(domain: "Test", code: 2, userInfo: [NSLocalizedDescriptionKey: "Different error"]))

        XCTAssertEqual(error1, error2, "Errors with the same message should be equal")
        XCTAssertNotEqual(error1, error3, "Different errors should not be equal")
    }
}
