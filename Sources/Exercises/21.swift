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
        let input = fromContent.components(separatedBy: .newlines).filter({ !$0.isEmpty })
        var puzzle: [Coordinate: Character] = [:]
        var startingPosition: Coordinate? = nil
        for (y, line) in input.enumerated() {
            for (x, tile) in line.enumerated() {
                puzzle[Coordinate(x: x, y: y)] = tile
                if tile == "S" { startingPosition = Coordinate(x: x, y: y) }
            }
        }
        if startingPosition == nil { fatalError("No starting position, should not happen") }
        let puzzleSize: Int = input.count // The puzzle is a square, should work for both height & width
        
        var positions: Set<Coordinate> = Set<Coordinate>([startingPosition!])
        
        // Thanks to AOC Reddit I understood that a solution could be to compute the quadratic progression
        // of the puzzle input (oh god, that was hard to find...)
        var quadraticFactor = 0
        var quadraticProgressionResults: [Int] = [Int].init(repeating: 0, count: 3)
        for step in 1...REMAINING_STEPS_MAIN_PART2 { // 1000 steps is good as we are running this on a 131x131 grid
            var newPositions: Set<Coordinate> = Set<Coordinate>()
            for position in positions {
                let neighbors: [Coordinate] = [
                    Coordinate(x: position.x - 1, y: position.y),
                    Coordinate(x: position.x + 1, y: position.y),
                    Coordinate(x: position.x, y: position.y - 1),
                    Coordinate(x: position.x, y: position.y + 1),
                ]
                for neighbor in neighbors {
                    let x = neighbor.x >= 0 ? neighbor.x : (puzzleSize + (neighbor.x % puzzleSize))
                    let y = neighbor.y >= 0 ? neighbor.y : (puzzleSize + (neighbor.y % puzzleSize))
                    if puzzle[Coordinate(x: x % puzzleSize, y: y % puzzleSize)] != "#" { newPositions.insert(neighbor); continue }
                }
            }
            positions = newPositions
            
            // reminder: puzzleSize / 2 is equals to the position of the Start!
            if step == (puzzleSize / 2) + (puzzleSize * quadraticFactor) {
                quadraticProgressionResults[quadraticFactor] = newPositions.count
                quadraticFactor += 1
                // Compute the next values (quadratic progression - only need the 3 first values)
                if quadraticFactor == 3 {
                    let fst_part = quadraticProgressionResults[0]
                    let snd_part = quadraticProgressionResults[1] - quadraticProgressionResults[0]
                    let trd_part = quadraticProgressionResults[2] - 2 * quadraticProgressionResults[1] + quadraticProgressionResults[0]
                    
                    let ratio: Int = REMAINING_STEPS_MAIN_PART2 / puzzleSize
                    
                    return fst_part + snd_part * ratio + trd_part * (ratio * (ratio - 1) / 2)
                }
                
            }
        }
        
        fatalError("Computation failed !")
        
        return 0
    }
}
