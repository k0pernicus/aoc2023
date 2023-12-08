//
//  08.swift
//  aoc2023
//
//  Created by Antonin on 12/11/2023.
//

import Foundation

enum Direction: Int {
    case L = 0, R
}

class Day08 : Day {
    
    typealias Output01 = Int
    typealias Output02 = Int
    
    internal var tag = "08"
    internal var FINAL_ENTRYPOINT: String = "ZZZ"
    internal var INIT_ENTRYPOINT : String = "AAA"
    
    init() {}
    
    internal func parseMap(input: String) -> ([Direction], [String: (String, String)]) {
        var directions : [Direction]
        var map: [String: (String, String)] = [:]
        let lines = input.components(separatedBy: .newlines)
        
        // Read the direction at first line
        directions = lines[0].trimmingCharacters(in: .whitespaces)
                             .map {
                                 switch ($0) {
                                 case "L" : return Direction.L
                                 case "R" : return Direction.R
                                 default  : fatalError("cannot have more than 2 different directions (L or R)")
                             }
        }
        for line in lines[1...] {
            if line.isEmpty { continue }
            let components: [String] = line.components(separatedBy: "=")
            let entrypoint: String   = components[0].trimmingCharacters(in: .whitespaces)
            let choices   : String   = components[1].trimmingCharacters(in: .whitespaces)
            // Now, parse the choices
            let parsedChoices = choices.components(separatedBy: .init(charactersIn: ","))
                                       .map { $0.trimmingCharacters(in: .whitespaces) }
                                       .map { $0.replacingOccurrences(of: "(", with: "") }
                                       .map { $0.replacingOccurrences(of: ")", with: "") }
            assert(parsedChoices.count == 2)
            map[entrypoint] = (parsedChoices[0], parsedChoices[1])
        }
        return (directions, map)
    }
    
    internal func part01(fromContent: String) throws -> Output01 {
        let (directions, map) = parseMap(input: fromContent)
        let nbDirections: Int = directions.count
        var currentPoint: String = INIT_ENTRYPOINT
        var points : Int = 0
        var currentLoopIndex: Int = 0
        while (FINAL_ENTRYPOINT != currentPoint) {
            let currentDirection: Int = directions[currentLoopIndex].rawValue
            switch currentDirection {
                case 0 : currentPoint = map[currentPoint]!.0
                case 1: currentPoint = map[currentPoint]!.1
                default: fatalError("cannot have more than 2 options")
            }
            currentLoopIndex += 1
            if currentLoopIndex == nbDirections { currentLoopIndex = 0 }
            points += 1
        }
        return points
    }
    
    internal func part02(fromContent: String) throws -> Output02 {
        let (directions, map) = parseMap(input: fromContent)
        let nbDirections: Int = directions.count
        var entrypoints: [String] = map.keys.filter { $0.last == "A" } // An entrypoing is a String that finished by "A"
        var matchingIndices : [Int] = [Int].init(repeating: 0, count: entrypoints.count)
        var currentLoop = 0
        var disabled: [Bool] = [Bool].init(repeating: false, count: entrypoints.count)
        while true {
            if (entrypoints.isEmpty) { break }
            for (index, entrypoint) in entrypoints.enumerated() {
                if (disabled[index]) { continue } // If we reached the end then no need to continue this one
                let currentDirection: Int = directions[currentLoop % nbDirections].rawValue
                switch currentDirection {
                    case 0 : entrypoints[index] = map[entrypoint]!.0
                    case 1:  entrypoints[index] = map[entrypoint]!.1
                    default: fatalError("cannot have more than 2 options")
                }
                if entrypoints[index].last == "Z" { disabled[index] = true; matchingIndices[index] = currentLoop + 1}
            }
            currentLoop += 1
            if (disabled.filter { $0 == false }.count == 0) { break } // Stop once all the entrypoints have been processed
        }
        
        return lcm(for: matchingIndices)
    }
}
