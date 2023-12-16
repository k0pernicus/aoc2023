//
//  16.swift
//  aoc2023
//
//  Created by Antonin on 12/11/2023.
//

import Foundation

class Day16 : Day {
    
    typealias Output01 = Int
    typealias Output02 = Int
    
    internal var tag = "16"
    
    enum Direction {
        case north
        case south
        case east
        case west
    }
    
    enum Encounter {
        case empty
        case splitter(Character)
        case mirror(Character)
    }
    
    struct Puzzle {
        let height: Int
        let width: Int
        let grid: [[Encounter]]
        var visited: [Int: [Int: [Direction]]] = [:]
        
        internal mutating func visiting(coordinate: Coordinate, direction: Direction) {
            let (x, y) = (coordinate.x, coordinate.y)
            if let visited = self.visited[x] {
                if let directions = visited[y] {
                    if directions.contains(direction) { return } // Already exists
                    self.visited[x]![y]!.append(direction); return
                }
                self.visited[x]![y] = [direction]; return
            }
            self.visited[x] = [:]; self.visited[x]![y] = [direction]
        }
        
        internal func hasBeenVisited(coordinate: Coordinate, direction: Direction) -> Bool {
            let (x, y) = (coordinate.x, coordinate.y)
            if let visited = self.visited[x] {
                if let directions = visited[y] {
                    return directions.contains(direction)
                } else { return false }
            } else { return false }
        }
        
        internal func nextDirections(coordinate: Coordinate, currentDirection: Direction) -> [(Coordinate, Direction)] {
            var nextDirections: [(Coordinate, Direction)] = []
            
            var nextCoordinate: Coordinate = Coordinate(x: -1, y: -1)
            switch (currentDirection) {
            case .north:
                if coordinate.y == 0 { nextCoordinate = coordinate }
                else { nextCoordinate = Coordinate(x: coordinate.x, y: coordinate.y - 1) }
            case .east:
                if coordinate.x == width - 1 { nextCoordinate = coordinate }
                else { nextCoordinate = Coordinate(x: coordinate.x + 1, y: coordinate.y) }
            case .south:
                if coordinate.y == self.height - 1 { nextCoordinate = coordinate }
                else { nextCoordinate = Coordinate(x: coordinate.x, y: coordinate.y + 1) }
            case .west:
                if coordinate.x == 0 { nextCoordinate = coordinate }
                else { nextCoordinate = Coordinate(x: coordinate.x - 1, y: coordinate.y) }
            }
            
            switch self.grid[nextCoordinate.y][nextCoordinate.x] {
            case .empty: nextDirections = [(nextCoordinate, currentDirection)]
            case let .mirror(mirrorDirection):
                switch (currentDirection, mirrorDirection) {
                    // Upward
                case (.north, "/") : nextDirections = [(nextCoordinate, .east)]
                case (.west, "/")  : nextDirections = [(nextCoordinate, .south)]
                case (.south, "/") : nextDirections = [(nextCoordinate, .west)]
                case (.east, "/")  : nextDirections = [(nextCoordinate, .north)]
                    // Downward
                case (.north, "\\") : nextDirections = [(nextCoordinate, .west)]
                case (.east, "\\")  : nextDirections = [(nextCoordinate, .south)]
                case (.south, "\\") : nextDirections = [(nextCoordinate, .east)]
                case (.west, "\\")  : nextDirections = [(nextCoordinate, .north)]
                default: fatalError("uncountered invalid direction \(currentDirection) & mirror reflection \(mirrorDirection)")
                }
            case let .splitter(splitter):
                switch (currentDirection, splitter) {
                case (.north, "|"), (.south, "|"), (.east, "-"), (.west, "-"): nextDirections = [(nextCoordinate, currentDirection)]
                default:
                    // Most untraditional move : two different directions !
                    if (splitter == "|") { nextDirections = [(nextCoordinate, .north), (nextCoordinate, .south)] }
                    else if (splitter == "-") { nextDirections = [(nextCoordinate, .east), (nextCoordinate, .west)] }
                    else { fatalError("uncountered invalid splitter object \(splitter)") }
                }
            }
            
            // Filter already visited nodes
            return nextDirections.filter({ !self.hasBeenVisited(coordinate: $0.0, direction: $0.1) })
        }
    }
    
    init() {}
    
    internal func part01(fromContent: String) throws -> Output01 {
        let input: [String] = fromContent.components(separatedBy: .newlines).filter{ !$0.isEmpty }
        let grid : [[Encounter]] = input.map({
            $0.map({
                switch ($0) {
                case ".": return .empty
                case "/": return .mirror("/")
                case "\\": return .mirror("\\")
                case "|": return .splitter("|")
                case "-": return .splitter("-")
                default: fatalError("encountered invalid character \($0)")
                }
            })
        })
        
        var puzzle: Puzzle = Puzzle(height: grid.count, width: grid[0].count, grid: grid)
        var moves: [(Coordinate, Direction)] = [(Coordinate(x: -1, y: 0), .east)]
        
        while true {
            if moves.isEmpty { break }
            let currentPoint = moves.removeFirst()
            let (currentCoordinates, currentDirection) = (currentPoint.0, currentPoint.1)
            if !(currentCoordinates.x == -1 && currentCoordinates.y == 0) { puzzle.visiting(coordinate: currentPoint.0, direction: currentPoint.1) }
            let nextPoints: [(Coordinate, Direction)] = puzzle.nextDirections(coordinate: currentCoordinates, currentDirection: currentDirection)
            for nextPoint in nextPoints { moves.append(nextPoint) }
        }
        
        var ans = 0
        for x in puzzle.visited.keys { ans += puzzle.visited[x]!.count }
        
        return ans
    }
    
    internal func part02(fromContent: String) throws -> Output02 {
        let input: [String] = fromContent.components(separatedBy: .newlines).filter{ !$0.isEmpty }
        let grid : [[Encounter]] = input.map({
            $0.map({
                switch ($0) {
                case ".": return .empty
                case "/": return .mirror("/")
                case "\\": return .mirror("\\")
                case "|": return .splitter("|")
                case "-": return .splitter("-")
                default: fatalError("encountered invalid character \($0)")
                }
            })
        })
        
        let height: Int = grid.count
        let width : Int = grid[0].count
        
        var ans = 0
        
        // TODO if time : multi-core solution
        
        // To bottom
        for x in 0..<width {
            var puzzle: Puzzle = Puzzle(height: height, width: width, grid: grid)
            let firstMove: (Coordinate, Direction) = (Coordinate(x: x, y: -1), .south)
            
            var moves = puzzle.nextDirections(coordinate: firstMove.0, currentDirection: firstMove.1)
            
            while true {
                if moves.isEmpty { break }
                let currentPoint = moves.removeFirst()
                let (currentCoordinates, currentDirection) = (currentPoint.0, currentPoint.1)
                if !(currentCoordinates.x == -1 && currentCoordinates.y == 0) { puzzle.visiting(coordinate: currentPoint.0, direction: currentPoint.1) }
                let nextPoints: [(Coordinate, Direction)] = puzzle.nextDirections(coordinate: currentCoordinates, currentDirection: currentDirection)
                for nextPoint in nextPoints { moves.append(nextPoint) }
            }
            
            var currentPoints = 0
            for x in puzzle.visited.keys { currentPoints += puzzle.visited[x]!.count }
            
            ans = max(ans, currentPoints)
        }
        
        // To up
        for x in 0..<width {
            var puzzle: Puzzle = Puzzle(height: height, width: width, grid: grid)
            let firstMove: (Coordinate, Direction) = (Coordinate(x: x, y: height), .north)
            
            var moves = puzzle.nextDirections(coordinate: firstMove.0, currentDirection: firstMove.1)
            
            while true {
                if moves.isEmpty { break }
                let currentPoint = moves.removeFirst()
                let (currentCoordinates, currentDirection) = (currentPoint.0, currentPoint.1)
                puzzle.visiting(coordinate: currentPoint.0, direction: currentPoint.1)
                let nextPoints: [(Coordinate, Direction)] = puzzle.nextDirections(coordinate: currentCoordinates, currentDirection: currentDirection)
                for nextPoint in nextPoints { moves.append(nextPoint) }
            }
            
            var currentPoints = 0
            for x in puzzle.visited.keys { currentPoints += puzzle.visited[x]!.count }
            
            ans = max(ans, currentPoints)
        }
        
        // To east
        for y in 0..<height {
            var puzzle: Puzzle = Puzzle(height: height, width: width, grid: grid)
            let firstMove: (Coordinate, Direction) = (Coordinate(x: -1, y: y), .east)
            
            var moves = puzzle.nextDirections(coordinate: firstMove.0, currentDirection: firstMove.1)
            
            while true {
                if moves.isEmpty { break }
                let currentPoint = moves.removeFirst()
                let (currentCoordinates, currentDirection) = (currentPoint.0, currentPoint.1)
                puzzle.visiting(coordinate: currentPoint.0, direction: currentPoint.1)
                let nextPoints: [(Coordinate, Direction)] = puzzle.nextDirections(coordinate: currentCoordinates, currentDirection: currentDirection)
                for nextPoint in nextPoints { moves.append(nextPoint) }
            }
            
            var currentPoints = 0
            for x in puzzle.visited.keys { currentPoints += puzzle.visited[x]!.count }
            
            ans = max(ans, currentPoints)
        }
        
        // To west
        for y in 0..<height {
            var puzzle: Puzzle = Puzzle(height: height, width: width, grid: grid)
            let firstMove: (Coordinate, Direction) = (Coordinate(x: height, y: y), .west)
            
            var moves = puzzle.nextDirections(coordinate: firstMove.0, currentDirection: firstMove.1)
            
            while true {
                if moves.isEmpty { break }
                let currentPoint = moves.removeFirst()
                let (currentCoordinates, currentDirection) = (currentPoint.0, currentPoint.1)
                puzzle.visiting(coordinate: currentPoint.0, direction: currentPoint.1)
                let nextPoints: [(Coordinate, Direction)] = puzzle.nextDirections(coordinate: currentCoordinates, currentDirection: currentDirection)
                for nextPoint in nextPoints { moves.append(nextPoint) }
            }
            
            var currentPoints = 0
            for x in puzzle.visited.keys { currentPoints += puzzle.visited[x]!.count }
            
            ans = max(ans, currentPoints)
        }
        
        return ans
    }
}
