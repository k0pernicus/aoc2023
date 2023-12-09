//
//  09.swift
//  aoc2023
//
//  Created by Antonin on 12/11/2023.
//

import Foundation

class Day09 : Day {
    
    typealias Output01 = Int
    typealias Output02 = Int
    
    internal var tag = "09"
    
    init() {}
    
    internal func parseInput(input: String) -> [[Int]] {
        let lines = input.components(separatedBy: .newlines)
        return lines.map { $0.components(separatedBy: .whitespaces)
                             .filter { !$0.isEmpty }
                             .map { Int($0)!
                          }
        }
    }
    
    internal func solvePuzzle(input: [[Int]], inReverse: Bool) -> Int {
        var ans: Int = 0
        for var history in input {
            if history.isEmpty { continue } // Why this still happens after parseInput ?
            if (inReverse) { history = history.reversed() }
            var currentDepth: [Int] = history
            var depthValues: [Int] = []
            var nextIncrease: Int? = nil
            while (true) {
                let diff = currentDepth[1..<currentDepth.count].enumerated().map { $0.1 - currentDepth[$0.0] }
                depthValues.append(currentDepth[currentDepth.count - 1])
                if Set<Int>(diff).count == 1 { nextIncrease = diff[0]; break }
                currentDepth = diff
            }
            while (!depthValues.isEmpty) {
                guard let value: Int = depthValues.popLast() else { break }
                nextIncrease = value + nextIncrease!
            }
            // nextIncrease is our value
            ans += nextIncrease!
        }
        return ans
    }
    
    internal func part01(fromContent: String) throws -> Output01 {
        let input: [[Int]] = parseInput(input: fromContent)
        return solvePuzzle(input: input, inReverse: false)
    }
    
    internal func part02(fromContent: String) throws -> Output02 {
        let input: [[Int]] = parseInput(input: fromContent)
        return solvePuzzle(input: input, inReverse: true)
    }
}
