//
//  23.swift
//  aoc2023
//
//  Created by Antonin on 12/11/2023.
//

import Foundation

class Day23 : Day {
    
    typealias Output01 = Int
    typealias Output02 = Int
    
    internal var tag = "23"
    
    init() {}
    
    enum Tile {
        case path
        case slope(kind: Character)
    }
    
    internal func puzzleTraversalWithSlopes(currentCoordinate: Coordinate,
                                  end: Coordinate,
                                  grid: [Coordinate: Tile],
                                  visited: Set<Coordinate>,
                                  currentAns: Int) -> Int? {
        if currentCoordinate == end { return currentAns }
        if grid[currentCoordinate] == nil { return nil }
        if visited.contains(currentCoordinate) { return nil }
        var newVisiting = visited
        newVisiting.insert(currentCoordinate)
        switch grid[currentCoordinate] {
        case let .slope(kind: kind):
            switch kind {
            case ">" : return puzzleTraversalWithSlopes(currentCoordinate: Coordinate(x: currentCoordinate.x + 1, y: currentCoordinate.y),
                                              end: end,
                                              grid: grid,
                                              visited: newVisiting,
                                              currentAns: currentAns + 1)
            case "<" : return puzzleTraversalWithSlopes(currentCoordinate: Coordinate(x: currentCoordinate.x - 1, y: currentCoordinate.y),
                                              end: end,
                                              grid: grid,
                                              visited: newVisiting,
                                              currentAns: currentAns + 1)
            case "^" : return puzzleTraversalWithSlopes(currentCoordinate: Coordinate(x: currentCoordinate.x, y: currentCoordinate.y - 1),
                                              end: end,
                                              grid: grid,
                                              visited: newVisiting,
                                              currentAns: currentAns + 1)
            case "v" : return puzzleTraversalWithSlopes(currentCoordinate: Coordinate(x: currentCoordinate.x, y: currentCoordinate.y + 1),
                                              end: end,
                                              grid: grid,
                                              visited: newVisiting,
                                              currentAns: currentAns + 1)
            default: fatalError("unknown kind of slope (got \(kind)")
            }
        case .path:
            let neighbors: [Coordinate] = [Coordinate(x: currentCoordinate.x - 1, y: currentCoordinate.y),
                                           Coordinate(x: currentCoordinate.x + 1, y: currentCoordinate.y),
                                           Coordinate(x: currentCoordinate.x, y: currentCoordinate.y - 1),
                                           Coordinate(x: currentCoordinate.x, y: currentCoordinate.y + 1)].filter({ !newVisiting.contains($0) })
            if neighbors.count == 0 { return currentAns }
            var maxRes: Int = 0
            for neighbor in neighbors {
                let neighborTraversal = puzzleTraversalWithSlopes(currentCoordinate: neighbor, end: end, grid: grid, visited: newVisiting, currentAns: currentAns + 1)
                guard let neighborResult = neighborTraversal else { continue }
                maxRes = max(maxRes, neighborResult)
            }
            return maxRes
        default: fatalError("unknown grid tile at coordinates \(currentCoordinate)")
        }
    }
    
    internal func measure(edges : [Coordinate: [(Int, Coordinate)]], start: Coordinate, head: Coordinate) -> (Int, Coordinate) {
        var count = 1
        var currentNode = start
        var nextNode = head
        while edges[nextNode]!.count == 2 {
            count += 1
            let next = edges[nextNode]!.map({ $0.1 }).filter({ $0 != currentNode })[0]
            currentNode = nextNode
            nextNode = next
        }
        return (count, nextNode)
    }
    
    internal func computeTrails(height: Int, width: Int, grid: [Coordinate: Tile]) -> [Coordinate: [(Int, Coordinate)]] {
        var edges : [Coordinate: [(Int, Coordinate)]]  = [:]
        for y in 0..<height {
            for x in 0..<width {
                if grid[Coordinate(x: x, y: y)] == nil { continue }
                let currentCoordinate = Coordinate(x: x, y: y)
                let neighbors: [Coordinate] = [Coordinate(x: currentCoordinate.x - 1, y: currentCoordinate.y),
                                               Coordinate(x: currentCoordinate.x + 1, y: currentCoordinate.y),
                                               Coordinate(x: currentCoordinate.x, y: currentCoordinate.y - 1),
                                               Coordinate(x: currentCoordinate.x, y: currentCoordinate.y + 1)].filter({ return grid[$0] != nil })
                edges[currentCoordinate] = []
                for neighbor in neighbors {
                    edges[currentCoordinate]?.append((1, neighbor))
                }
            }
        }
        // Collapse all "segments" into a single trail
        var ans: [Coordinate: [(Int, Coordinate)]]  = [:]
        for (k, v) in edges {
            if v.count != 2 {
                ans[k] = v.map({ measure(edges: edges, start: k, head: $0.1) })
            }
        }
        return ans
    }
    
    internal func puzzleTraversalNoSlopes(currentCoordinate: Coordinate,
                                          end: Coordinate,
                                          trails: [Coordinate: [(Int, Coordinate)]]) -> Int {
        var visitedNodes: Set<Coordinate> = Set<Coordinate>([currentCoordinate])
        var stack: [(Coordinate, Int, Set<Coordinate>)] = [(currentCoordinate, 0, visitedNodes)]
        var ans = 0
        
        while !stack.isEmpty {
            let (currentCoordinate, distance, visited) = stack.removeLast()
            if currentCoordinate == end {
                ans = max(ans, distance)
                continue
            }
            for (deltaDistance, nextNode) in trails[currentCoordinate]! {
                if visited.contains(nextNode) { continue }
                stack.append((nextNode, distance + deltaDistance, visited.union([nextNode])))
            }
        }
        
        return ans
    }
    
    internal func part01(fromContent: String) throws -> Output01 {
        let input = fromContent.components(separatedBy: .newlines).filter({ !$0.isEmpty })
        var start  : Coordinate? = nil
        var end    : Coordinate? = nil
        var puzzle : [Coordinate: Tile] = [:]
        for (y, line) in input.enumerated() {
            for (x, tile) in line.enumerated() {
                switch tile {
                case "#": break
                case ".":
                    puzzle[Coordinate(x: x, y: y)] = .path;
                    if (y == 0 && start == nil) { start = Coordinate(x: x, y: y) }
                    if (y == input.count - 1 && end == nil) { end = Coordinate(x: x, y: y) }
                case ">", "<", "^", "v": puzzle[Coordinate(x: x, y: y)] = .slope(kind: tile)
                default: fatalError("cannot parse the tile entry (unknown tile \(tile)")
                }
            }
        }
        guard start != nil && end != nil else { fatalError("No start and / or no end - should not happen (parser issue)") }
        
        let traversalResult = puzzleTraversalWithSlopes(currentCoordinate: start!, end: end!, grid: puzzle, visited: Set<Coordinate>(), currentAns: 0)
        guard let answer = traversalResult else { fatalError("error traversing the grid : no result") }
        return answer
    }
    
    internal func part02(fromContent: String) throws -> Output02 {
        let input = fromContent.components(separatedBy: .newlines).filter({ !$0.isEmpty })
        var start  : Coordinate? = nil
        var end    : Coordinate? = nil
        var puzzle : [Coordinate: Tile] = [:]
        for (y, line) in input.enumerated() {
            for (x, tile) in line.enumerated() {
                switch tile {
                case "#": break
                case ".":
                    puzzle[Coordinate(x: x, y: y)] = .path;
                    if (y == 0 && start == nil) { start = Coordinate(x: x, y: y) }
                    if (y == input.count - 1 && end == nil) { end = Coordinate(x: x, y: y) }
                case ">", "<", "^", "v": puzzle[Coordinate(x: x, y: y)] = .path // Ignore the slopes !
                default: fatalError("cannot parse the tile entry (unknown tile \(tile)")
                }
            }
        }
        guard start != nil && end != nil else { fatalError("No start and / or no end - should not happen (parser issue)") }
        
        let trails = computeTrails(height: input.count, width: input[0].count, grid: puzzle)
        let result = puzzleTraversalNoSlopes(currentCoordinate: start!,
                                             end: end!,
                                             trails: trails)
        return result
    }
}
