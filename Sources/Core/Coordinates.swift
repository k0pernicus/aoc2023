//
//  Coordinates.swift
//
//
//  Created by antonin on 03/12/2023.
//

import Foundation

struct Coordinate: Hashable {
    let x: Int
    let y: Int
}

func generatePossibleCoordinates(coordinate: Coordinate, maxHeight: Int, maxWidth: Int) -> [Coordinate] {
    var candidates: Set<Coordinate> = Set<Coordinate>()
    let (x, y) = (coordinate.x, coordinate.y)
    // SIDED
    candidates.insert(Coordinate(x: x > 0 ? x - 1 : x, y: y))
    candidates.insert(Coordinate(x: x < (maxWidth - 1) ? x + 1 : x, y: y))
    // DIAGONALS
    candidates.insert(Coordinate(x: x > 0 ? x - 1 : x, y: y > 0 ? y - 1 : y))
    candidates.insert(Coordinate(x: x < (maxWidth - 1) ? x + 1 : x, y: y < (maxHeight - 1) ? y + 1 : y))
    candidates.insert(Coordinate(x: x > 0 ? x - 1 : x, y: y < (maxHeight - 1) ? y + 1 : y))
    candidates.insert(Coordinate(x: x < (maxWidth - 1) ? x + 1 : x, y: y > 0 ? y - 1 : y))
    // UP AND DOWN
    candidates.insert(Coordinate(x: x, y: y < (maxHeight - 1) ? y + 1 : y))
    candidates.insert(Coordinate(x: x, y: y > 0 ? y - 1 : y))
    // Do not include Self
    if candidates.contains(coordinate) { candidates.remove(coordinate) }
    return Array(candidates)
}
