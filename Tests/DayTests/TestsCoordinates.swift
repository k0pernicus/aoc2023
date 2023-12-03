//
//  TestsCoordinates.swift
//
//
//  Created by antonin on 03/12/2023.
//

@testable import aoc2023
import XCTest

final class CoordinateTests: XCTestCase {
    func testGenerateCoordinatesWithoutLimit() {
        let coordinates = generatePossibleCoordinates(coordinate: Coordinate(x: 1, y: 1), maxHeight: 10, maxWidth: 10)
        XCTAssert(coordinates.count == 8)
        XCTAssert(Set(coordinates) == Set([
            Coordinate(x: 0, y: 0),
            Coordinate(x: 1, y: 0),
            Coordinate(x: 0, y: 1),
            Coordinate(x: 2, y: 0),
            Coordinate(x: 0, y: 2),
            Coordinate(x: 2, y: 1),
            Coordinate(x: 2, y: 2),
            Coordinate(x: 1, y: 2),
        ]))
    }
    func testGenerateCoordinatesWithLimit() {
        let coordinates = generatePossibleCoordinates(coordinate: Coordinate(x: 1, y: 1), maxHeight: 1, maxWidth: 1)
        XCTAssert(coordinates.count == 3)
        XCTAssert(Set(coordinates) == Set([
            Coordinate(x: 0, y: 0),
            Coordinate(x: 1, y: 0),
            Coordinate(x: 0, y: 1)
        ]))
    }
    func testGenerateCoordinatesNoExpend() {
        let coordinates = generatePossibleCoordinates(coordinate: Coordinate(x: 0, y: 0), maxHeight: 1, maxWidth: 1)
        XCTAssert(coordinates.count == 0)
    }
}
