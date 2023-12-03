//
//  03.swift
//  aoc2023
//
//  Created by Antonin on 12/11/2023.
//

import Foundation

class Day03 : Day {
    
    typealias Output01 = Int
    typealias Output02 = Int
    
    internal var tag = "03"
    
    init() {}
    
    internal func part01(fromContent: String) throws -> Output01 {
        var ans = 0
        // Replace all '.' by whitespaces to not confound with symbols
        let modifiedContent = fromContent.replacingOccurrences(of: ".", with: " ")
        let lines = modifiedContent.components(separatedBy: .newlines)
        let (maxHeight, maxWidth): (Int, Int) = (lines.count, lines[0].count)
        var mapScan: [Coordinate: Bool] = [:]
        for (yIndex, line) in lines.enumerated() {
            if line.isEmpty { continue }
            var startIndexNumber: Int? = nil
            var validNumber = false
            for (xIndex, character) in line.enumerated() {
                if (character.isNumber) {
                    if startIndexNumber == nil { startIndexNumber = xIndex }
                    if (validNumber) { continue }
                    // Look for any symbol
                    let coordinates = generatePossibleCoordinates(coordinate: Coordinate(x: xIndex, y: yIndex),
                                                                  maxHeight: maxHeight - 1, // Take care at the whiteline at the end of the file
                                                                  maxWidth: maxWidth)
                    for coordinate in coordinates {
                        if mapScan[coordinate] == nil {
                            let (x, y) = (coordinate.x, coordinate.y)
                            let symbolIndex = lines[y].index(line.startIndex, offsetBy: x)
                            mapScan[coordinate] = !(lines[y][symbolIndex].isWhitespace || lines[y][symbolIndex].isNewline || lines[y][symbolIndex].isNumber)
                        }
                        validNumber = validNumber || mapScan[coordinate]!
                    }
                    continue
                }
                if (validNumber && startIndexNumber != nil) {
                    let subString = line.substring(with: startIndexNumber!..<xIndex)
                    ans += (Int(subString) ?? 0)
                }
                startIndexNumber = nil
                validNumber = false
            }
            if (validNumber && startIndexNumber != nil) {
                let subString = line.substring(with: startIndexNumber!..<maxWidth)
                ans += (Int(subString) ?? 0)
            }
            validNumber = false
            startIndexNumber = nil
        }
        return ans
    }
    
    internal func part02(fromContent: String) throws -> Output02 {
        // Replace all '.' by whitespaces to not confound with symbols
        let modifiedContent = fromContent.replacingOccurrences(of: ".", with: " ")
        let lines = modifiedContent.components(separatedBy: .newlines)
        let (maxHeight, maxWidth): (Int, Int) = (lines.count, lines[0].count)
        var gears: [Coordinate: [Int]] = [:]
        for (yIndex, line) in lines.enumerated() {
            if line.isEmpty { continue }
            var startIndexNumber: Int? = nil
            var foundGear: Coordinate? = nil
            for (xIndex, character) in line.enumerated() {
                if (character.isNumber) {
                    if startIndexNumber == nil { startIndexNumber = xIndex }
                    if (foundGear != nil) { continue }
                    // Look for any symbol
                    let coordinates = generatePossibleCoordinates(coordinate: Coordinate(x: xIndex, y: yIndex),
                                                                  maxHeight: maxHeight - 1, // Take care at the whiteline at the end of the file
                                                                  maxWidth: maxWidth)
                    for coordinate in coordinates {
                        let (x, y) = (coordinate.x, coordinate.y)
                        if (lines[y].characterAt(at: x) == "*") { foundGear = coordinate }
                    }
                    continue
                }
                if (foundGear != nil && startIndexNumber != nil) {
                    let subString = line.substring(with: startIndexNumber!..<xIndex)
                    let value = Int(subString) ?? 0
                    if let _ = gears[foundGear!] {
                        gears[foundGear!]!.append(value)
                    } else {
                        gears[foundGear!] = [value]
                    }
                }
                startIndexNumber = nil
                foundGear = nil
            }
            if (foundGear != nil && startIndexNumber != nil) {
                let subString = line.substring(with: startIndexNumber!..<maxWidth)
                let value = Int(subString) ?? 0
                if let _ = gears[foundGear!] {
                    gears[foundGear!]!.append(value)
                } else {
                    gears[foundGear!] = [value]
                }
            }
            foundGear = nil
            startIndexNumber = nil
        }
        gears = gears.filter { $0.value.count == 2 }
        return gears.reduce(0, { $0 + ($1.value[0] * $1.value[1]) })
    }
}
