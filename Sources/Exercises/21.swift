//
//  21.swift
//  aoc2023
//
//  Created by Antonin on 12/11/2023.
//

import Foundation

class Day21 : Day {
    
    typealias Output01 = Int
    typealias Output02 = Int
    
    internal var tag = "21"
    
    init() {}
    
    let REMAINING_STEPS_TEST_PART1 = 6
    let REMAINING_STEPS_MAIN_PART1 = 64
    let REMAINING_STEPS_MAIN_PART2 = 26501365
    
    internal func part01(fromContent: String) throws -> Output01 {
        let input = fromContent.components(separatedBy: .newlines).filter({ !$0.isEmpty })
        var puzzle: [Coordinate: Int] = [:]
        var startingPosition: Coordinate? = nil
        for (y, line) in input.enumerated() {
            for (x, tile) in line.enumerated() {
                if tile == "#" { continue }
                else if tile == "S" { startingPosition = Coordinate(x: x, y: y); puzzle[Coordinate(x: x, y: y)] = -1; continue }
                else { // garden plot
                    puzzle[Coordinate(x: x, y: y)] = -1
                }
            }
        }
        if startingPosition == nil { fatalError("No starting position, should not happen") }
        var visitedCoordinates: Set<Coordinate> = Set<Coordinate>()
        
        var positions: [Coordinate] = [startingPosition!]
        for step in 1...REMAINING_STEPS_MAIN_PART1 {
            var newPositions: [Coordinate] = []
            while !positions.isEmpty {
                let currentPosition = positions.removeFirst()
                let neighbors: [Coordinate] = [
                    Coordinate(x: currentPosition.x - 1, y: currentPosition.y),
                    Coordinate(x: currentPosition.x + 1, y: currentPosition.y),
                    Coordinate(x: currentPosition.x, y: currentPosition.y - 1),
                    Coordinate(x: currentPosition.x, y: currentPosition.y + 1),
                ].filter({ puzzle[$0] != nil && !visitedCoordinates.contains($0) })
                for neighbor in neighbors {
                    visitedCoordinates.insert(neighbor)
                    if puzzle[neighbor] == -1 { puzzle[neighbor] = step }
                    newPositions.append(neighbor)
                }
            }
            positions = newPositions
        }
        
        let remainingHash = puzzle.filter({ $0.value != -1 }).filter({ $0.value % 2 == 0 }).count
        
        return remainingHash
    }
    
    internal func part02(fromContent: String) throws -> Output02 {
        return 0
    }
}
