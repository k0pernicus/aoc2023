//
//  17.swift
//  aoc2023
//
//  Created by Antonin on 12/11/2023.
//

import Foundation

class Day17 : Day {
    
    typealias Output01 = Int
    typealias Output02 = Int
    
    internal var tag = "17"
    
    init() {}
    
    struct D17Visited: Hashable {
        let x : Int
        let y : Int
        let px: Int
        let py: Int
    }
    
    struct D17Priority : Comparable {
        static func < (lhs: Day17.D17Priority, rhs: Day17.D17Priority) -> Bool {
            if (lhs.heat != rhs.heat) { return lhs.heat >= rhs.heat }
            if (lhs.coordinate != rhs.coordinate ) { return lhs.coordinate.x >= rhs.coordinate.x && lhs.coordinate.y >= rhs.coordinate.y }
            return lhs.px >= rhs.py
        }
        
        let coordinate: Coordinate
        let heat: Int
        let px: Int
        let py: Int
    }
    
    internal func solvePuzzle(puzzle: [[Int]], start: Coordinate, end: Coordinate, leastMoves: Int, mostMoves: Int) -> Int {
        let queue: HeapQ<D17Priority> = HeapQ<D17Priority>()
        var visited: Set<D17Visited> = Set()
        
        let height : Int = puzzle.count
        let width  : Int = puzzle[0].count
        
        queue.insert(D17Priority(coordinate: start, heat: 0, px: 0, py: 0))
        
        while !queue.isEmpty {
            let node = queue.remove()!
            let (currentCoordinates, heat, px, py) = (node.coordinate, node.heat, node.px, node.py)
            
            if (currentCoordinates == end) {
                return heat
            }
            let visiting: D17Visited = D17Visited(
                x: currentCoordinates.x,
                y: currentCoordinates.y,
                px: px,
                py: py)
            if visited.contains(visiting) { continue }
            visited.insert(visiting)

            let toVisit: Set<Coordinate> = Set([Coordinate(x: 0, y: 1),
                                                Coordinate(x: 1, y: 0),
                                                Coordinate(x: 0, y: -1),
                                                Coordinate(x: -1, y: 0)])
                .subtracting(Set([ Coordinate(x: px, y: py), Coordinate(x: -px, y: -py) ]))
            
            for coordinate in toVisit {
                let (dx, dy) = (coordinate.x, coordinate.y)
                var newHeat = heat
                var (newX, newY): (Int, Int) = (currentCoordinates.x, currentCoordinates.y)
                for i in 1...mostMoves {
                    newX += dx; newY += dy
                    
                    if !(newX >= 0 && newX < height && newY >= 0 && newY < width) { continue }
                    
                    newHeat += puzzle[newX][newY]
                    if i >= leastMoves {
                        queue.insert(D17Priority(coordinate: Coordinate(x: newX, y: newY), heat: newHeat, px: dx, py: dy))
                    }
                }
            }
        }
        
        return 0
    }
    
    internal func part01(fromContent: String) throws -> Output01 {
        let puzzle: [[Int]] = fromContent.components(separatedBy: .newlines)
            .filter{ !$0.isEmpty }
            .map({ $0.map({ Int(String($0))! })})
        
        let height : Int = puzzle.count
        let width  : Int = puzzle[0].count
        let endCase: Coordinate = Coordinate(x: width - 1, y: height - 1)
        return solvePuzzle(puzzle: puzzle, start: Coordinate(x: 0, y: 0), end: endCase, leastMoves: 1, mostMoves: 3)
    }
    
    internal func part02(fromContent: String) throws -> Output02 {
        let puzzle: [[Int]] = fromContent.components(separatedBy: .newlines)
            .filter{ !$0.isEmpty }
            .map({ $0.map({ Int(String($0))! })})
        
        let height : Int = puzzle.count
        let width  : Int = puzzle[0].count
        let endCase: Coordinate = Coordinate(x: width - 1, y: height - 1)
        return solvePuzzle(puzzle: puzzle, start: Coordinate(x: 0, y: 0), end: endCase, leastMoves: 4, mostMoves: 10)
    }
}
