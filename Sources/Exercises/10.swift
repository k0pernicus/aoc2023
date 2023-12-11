//
//  10.swift
//  aoc2023
//
//  Created by Antonin on 12/11/2023.
//

import Foundation

class Day10 : Day {
    
    typealias Output01 = Int
    typealias Output02 = Int
    
    internal var tag = "10"
    
    init() {}
    
    static var NO_PIPE: Character = "."
    static var START_POSITION: Character = "S"
    
    enum PipeDirection {
        case north
        case east
        case south
        case west
    }
    
    internal func selectNewCoordinates(at tile: Character, from: PipeDirection) -> (Coordinate, PipeDirection)? {
        switch (tile, from) {
        case ("|", .north):                 return (Coordinate(x: 0, y: 1), .north)
        case ("|", .south):                 return (Coordinate(x: 0, y: -1), .south)
        case ("-", .east):                  return (Coordinate(x: -1, y: 0), .east)
        case ("-", .west):                  return (Coordinate(x: 1, y: 0), .west)
        case ("L", .north):                 return (Coordinate(x: 1, y: 0), .west)
        case ("L", .east):                  return (Coordinate(x: 0, y: -1), .south)
        case ("J", .north):                 return (Coordinate(x: -1, y: 0), .east)
        case ("J", .west):                  return (Coordinate(x: 0, y: -1), .south)
        case ("7", .south):                 return (Coordinate(x: -1, y: 0), .east)
        case ("7", .west):                  return (Coordinate(x: 0, y: 1), .north)
        case ("F", .south):                 return (Coordinate(x: 1, y: 0), .west)
        case ("F", .east):                  return (Coordinate(x: 0, y: 1), .north)
        default:                            return nil
        }
    }
    
    internal func isConnected(from: Character, fromDirection: PipeDirection, to: Character) -> Bool {
        func matchPipeTile(at tile: Character, from: PipeDirection) -> Set<Character>? {
            switch (tile, from) {
            case (Self.START_POSITION, .north): return Set<Character>(["L", "J", "|"])
            case (Self.START_POSITION, .south): return Set<Character>(["7", "F", "|"])
            case (Self.START_POSITION, .east):  return Set<Character>(["L", "F", "-"])
            case (Self.START_POSITION, .west):  return Set<Character>(["J", "7", "-"])
            case ("|", .north):                 return Set<Character>(["L", "J", "|"])
            case ("|", .south):                 return Set<Character>(["7", "F", "|"])
            case ("-", .east):                  return Set<Character>(["L", "F", "-"])
            case ("-", .west):                  return Set<Character>(["J", "7", "-"])
            case ("L", .north):                 return Set<Character>(["J", "7", "-"])
            case ("L", .east):                  return Set<Character>(["F", "7", "|"])
            case ("J", .north):                 return Set<Character>(["F", "L", "-"])
            case ("J", .west):                  return Set<Character>(["F", "7", "|"])
            case ("7", .south):                 return Set<Character>(["F", "L", "-"])
            case ("7", .west):                  return Set<Character>(["L", "J", "|"])
            case ("F", .south):                 return Set<Character>(["J", "7", "-"])
            case ("F", .east):                  return Set<Character>(["L", "J", "|"])
            default:                            return nil
            }
        }
        let matchingPipes: Set<Character>? = matchPipeTile(at: from, from: fromDirection)
        if nil == matchingPipes { return false }
        return matchingPipes!.contains(to)
    }
    
    internal func part01(fromContent: String) throws -> Output01 {
        var initCoordinates: Coordinate? = nil
        let lines = fromContent.components(separatedBy: .newlines)
        // Look for START_POSITION first
        for (lineIndex, line) in lines.enumerated() {
            if let i = line.firstIndex(of: Self.START_POSITION) {
                let index: Int = line.distance(from: line.startIndex, to: i)
                initCoordinates = Coordinate(x: index, y: lineIndex)
                break
            }
        }
        
        var toVisit: [(PipeDirection, Coordinate, Coordinate)] = []
        // START_POSITION found
        let start_x = initCoordinates!.x
        let start_y = initCoordinates!.y
        if (start_x > 0) { toVisit.append( (PipeDirection.east, Coordinate(x: start_x - 1, y: start_y), initCoordinates!) ) }
        if (start_x < lines[0].count - 1) { toVisit.append( (PipeDirection.west, Coordinate(x: start_x + 1, y: start_y), initCoordinates!) ) }
        if (start_y > 0) { toVisit.append( (PipeDirection.south, Coordinate(x: start_x, y: start_y - 1), initCoordinates!) ) }
        if (start_y < lines.count - 1) { toVisit.append( (PipeDirection.north, Coordinate(x: start_x, y: start_y + 1), initCoordinates!) ) }
        
        toVisit = toVisit.filter { isConnected(from: Self.START_POSITION, fromDirection: $0.0, to: lines[$0.1.y].characterAt(at: $0.1.x)) }
        
        var visitedPlaces: [Coordinate: Int] = [:]
        visitedPlaces[initCoordinates!] = 0
        
        while (!toVisit.isEmpty) {
            let (fromDirection, visiting, fromCoordinate): (PipeDirection, Coordinate, Coordinate) = toVisit.removeFirst()
            if let value = visitedPlaces[visiting] { return value }
            else { visitedPlaces[visiting] = visitedPlaces[fromCoordinate]! + 1 }
            
            let cTile: Character = lines[visiting.y].characterAt(at: visiting.x)
            let coordinateToAdd: (Coordinate, PipeDirection)? = selectNewCoordinates(at: cTile, from: fromDirection)
            if nil == coordinateToAdd {
                continue
            }
            
            let (toAdd, fromNewDirection) = coordinateToAdd!
        
            let newCoordinate = Coordinate(x: visiting.x + toAdd.x, y: visiting.y + toAdd.y)
            toVisit.append(( fromNewDirection, newCoordinate, visiting ))
        }
        
        return 0
    }
    
    internal func part02(fromContent: String) throws -> Output02 {
        var initCoordinates: Coordinate? = nil
        let lines = fromContent.components(separatedBy: .newlines)
        // Look for START_POSITION first
        for (lineIndex, line) in lines.enumerated() {
            if let i = line.firstIndex(of: Self.START_POSITION) {
                let index: Int = line.distance(from: line.startIndex, to: i)
                initCoordinates = Coordinate(x: index, y: lineIndex)
                break
            }
        }
        var toVisit: [(PipeDirection, Coordinate, Coordinate)] = []
        // START_POSITION found
        let start_x = initCoordinates!.x
        let start_y = initCoordinates!.y
        if (start_x > 0) { toVisit.append( (PipeDirection.east, Coordinate(x: start_x - 1, y: start_y), initCoordinates!) ) }
        if (start_x < lines[0].count - 1) { toVisit.append( (PipeDirection.west, Coordinate(x: start_x + 1, y: start_y), initCoordinates!) ) }
        if (start_y > 0) { toVisit.append( (PipeDirection.south, Coordinate(x: start_x, y: start_y - 1), initCoordinates!) ) }
        if (start_y < lines.count - 1) { toVisit.append( (PipeDirection.north, Coordinate(x: start_x, y: start_y + 1), initCoordinates!) ) }
        
        toVisit = toVisit.filter { isConnected(from: Self.START_POSITION, fromDirection: $0.0, to: lines[$0.1.y].characterAt(at: $0.1.x)) }
        
        toVisit = [toVisit[0]] // Take the first point only
        
        var visitedPlaces: [Coordinate: Int] = [:]
        visitedPlaces[initCoordinates!] = 0
        
        while (!toVisit.isEmpty) {
            let (fromDirection, visiting, fromCoordinate): (PipeDirection, Coordinate, Coordinate) = toVisit.removeFirst()
            if lines[visiting.y].characterAt(at: visiting.x) == Self.START_POSITION { break }
            else { visitedPlaces[visiting] = visitedPlaces[fromCoordinate]! + 1 }
            
            let cTile: Character = lines[visiting.y].characterAt(at: visiting.x)
            let coordinateToAdd: (Coordinate, PipeDirection)? = selectNewCoordinates(at: cTile, from: fromDirection)
            if nil == coordinateToAdd { continue }
            
            let (toAdd, fromNewDirection) = coordinateToAdd!
            toVisit.append(( fromNewDirection, Coordinate(x: visiting.x + toAdd.x, y: visiting.y + toAdd.y), visiting ))
        }
        
        var ans: Int = 0 // inside points
        var crossing: Int = 0 // everything at 0 is an external point
        
        // Nonzero-rule application
        // Tracing from North to South
        for y in 0..<lines.count {
            for x in 0..<lines[y].count {
                let point = Coordinate(x: x, y: y)
                if let value = visitedPlaces[point] {
                    if let stepBelow = visitedPlaces[Coordinate(x: x, y: y + 1)] { // Moving to south one-step ahead (y+1)
                        if stepBelow == ((value + 1) % visitedPlaces.count) { crossing += 1 } // Following the same path
                        if value == ((stepBelow + 1) % visitedPlaces.count) { crossing -= 1 } // Steping accross a path
                    }
                }
                else {
                    if crossing != 0 { ans += 1 } // Found an insider !
                }
            }
        }
        
        return ans
    }
}
