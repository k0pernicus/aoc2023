//
//  18.swift
//  aoc2023
//
//  Created by Antonin on 12/11/2023.
//

import Foundation

class Day18 : Day {
    
    typealias Output01 = Int
    typealias Output02 = Int
    
    internal var tag = "18"
    
    init() {}
    
    // Used the shoelace formula
    // https://en.wikipedia.org/wiki/Shoelace_formula
    internal func computeArea(coordinates: [Coordinate], perimeter: Int) -> Int {
        var ans = 0
        for i in 0..<coordinates.count - 1 {
            ans += (coordinates[i].x * coordinates[i+1].y) - (coordinates[i].y * coordinates[i+1].x)
        }
        ans += perimeter
        return (ans / 2) + 1
    }
    
    internal func part01(fromContent: String) throws -> Output01 {
        let puzzle = fromContent.components(separatedBy: .newlines).filter({ !$0.isEmpty })
        var currentCoordinate: Coordinate = Coordinate(x: 0, y: 0)
        var allCoordinates: [Coordinate] = [currentCoordinate]
        var perimeter: Int = 0 // Perimeter
        for line in puzzle {
            let components: [String] = line.components(separatedBy: .whitespaces)
            assert(components.count == 3)
            let (direction, number, _) = (components[0], Int(components[1])!, components[2])
            switch direction {
            case "U": currentCoordinate = Coordinate(x: currentCoordinate.x, y: currentCoordinate.y - number)
            case "D": currentCoordinate = Coordinate(x: currentCoordinate.x, y: currentCoordinate.y + number)
            case "L": currentCoordinate = Coordinate(x: currentCoordinate.x - number, y: currentCoordinate.y)
            case "R": currentCoordinate = Coordinate(x: currentCoordinate.x + number, y: currentCoordinate.y)
            default : fatalError("unknown direction \(direction)")
            }
            
            perimeter += number
            allCoordinates.append(currentCoordinate)
        }
        
        return computeArea(coordinates: allCoordinates, perimeter: perimeter)
    }
    
    internal func part02(fromContent: String) throws -> Output02 {
        let puzzle = fromContent.components(separatedBy: .newlines).filter({ !$0.isEmpty })
        var currentCoordinate: Coordinate = Coordinate(x: 0, y: 0)
        var allCoordinates: [Coordinate] = [currentCoordinate]
        var perimeter: Int = 0 // Perimeter
        for line in puzzle {
            let components: [String] = line.components(separatedBy: .whitespaces)
            assert(components.count == 3)
            var encodedValue = components[2] // Only the last value is useful
            encodedValue.removeFirst() // Remove the '(' character
            encodedValue.removeFirst() // Remove the '#' character
            encodedValue.removeLast()  // Remove the ')' character
            let index = encodedValue.index(encodedValue.startIndex, offsetBy: 5) // Get the 5 first characters
            let number = Int(encodedValue[..<index], radix: 16)!
            
            switch encodedValue.last! {
            case "0": currentCoordinate = Coordinate(x: currentCoordinate.x + number, y: currentCoordinate.y)
            case "1": currentCoordinate = Coordinate(x: currentCoordinate.x, y: currentCoordinate.y + number)
            case "2": currentCoordinate = Coordinate(x: currentCoordinate.x - number, y: currentCoordinate.y)
            case "3": currentCoordinate = Coordinate(x: currentCoordinate.x, y: currentCoordinate.y - number)
            default : fatalError("unknown direction...")
            }
            
            perimeter += number
            allCoordinates.append(currentCoordinate)
        }
        
        return computeArea(coordinates: allCoordinates, perimeter: perimeter)
    }
}
