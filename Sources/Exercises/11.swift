//
//  11.swift
//  aoc2023
//
//  Created by Antonin on 12/11/2023.
//

import Foundation

class Day11 : Day {
    
    typealias Output01 = Int
    typealias Output02 = Int
    
    internal var tag = "11"
    
    init() {}
    
    internal func findEmptyRowsAndCols(input: [String]) -> (Set<Int>, Set<Int>) {
        var emptyRows: Set<Int> = Set<Int>()
        var emptyCols: Set<Int> = Set<Int>()
        let input = input.filter { !$0.isEmpty }
        for (rowIndex, line) in input.enumerated() {
            if !line.contains("#") { emptyRows.insert(rowIndex) }
        }
        for colIndex in 0..<input[0].count {
            if !input.map({ $0.characterAt(at: colIndex) }).contains("#") { emptyCols.insert(colIndex) }
        }
        return (emptyRows, emptyCols)
    }
    
    internal func lookFor(input: [String], char: Character) -> Array<Coordinate> {
        var coordinates: Array<Coordinate> = Array<Coordinate>()
        for (rowIndex, line) in input.enumerated() {
            for colIndex in line.indices(of: String(char)) {
                coordinates.append(Coordinate(x: colIndex, y: rowIndex))
            }
        }
        return coordinates
    }
    
    internal func solvePuzzle(input: [String], multiplier: Int) -> Int {
        let (emptyRows, emptyCols) = findEmptyRowsAndCols(input: input)
        
        // Look for galaxies
        let galaxies = lookFor(input: input, char: "#")
        
        var ans = 0
        
        for i in 0..<galaxies.count {
            for j in (i+1)..<galaxies.count {
                
                let galaxyA = galaxies[i]
                let galaxyB = galaxies[j]
                
                let (ax, bx) = (min(galaxyA.x, galaxyB.x), max(galaxyA.x, galaxyB.x))
                let (ay, by) = (min(galaxyA.y, galaxyB.y), max(galaxyA.y, galaxyB.y))
                
                let xrange: Set<Int> = Set<Int>(ax...bx)
                let yrange: Set<Int> = Set<Int>(ay...by)
                
                var count = (bx - ax) + (emptyCols.intersection(xrange).count * multiplier)
                count += (by - ay) + (emptyRows.intersection(yrange).count * multiplier)
                
                ans += count
            }
        }
        
        return ans
    }
    
    internal func part01(fromContent: String) throws -> Output01 {
        let input = fromContent.components(separatedBy: .newlines)
        return solvePuzzle(input: input, multiplier: 1)
    }
    
    internal func part02(fromContent: String) throws -> Output02 {
        let input = fromContent.components(separatedBy: .newlines)
        return solvePuzzle(input: input, multiplier: 1000000 - 1)
    }
}
