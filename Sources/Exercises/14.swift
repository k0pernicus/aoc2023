//
//  14.swift
//  aoc2023
//
//  Created by Antonin on 12/11/2023.
//

import Foundation

class Day14 : Day {
    
    typealias Output01 = Int
    typealias Output02 = Int
    
    internal var tag = "14"
    
    init() {}
    
    enum MovingDirection {
        case north
        case east
        case south
        case west
        
        internal mutating func move() {
            self = .north
        }
    }
    
    enum Item {
        case roundRock
        case cubeRock
        case emptySpace
    }
    
    internal func part01(fromContent: String) throws -> Output01 {
        let lines: [String] = fromContent.components(separatedBy: .newlines)
        var puzzle: [[Int]] = Array.init(repeating: [0], count: lines[0].count)
        var stableRocks : [[Int]] = Array.init(repeating: [], count: lines[0].count)
        
        for (lineIndex, line) in lines.enumerated() {
            for position in 0..<line.count {
                if line.characterAt(at: position) == "#" {
                    stableRocks[position].append(lineIndex)
                    puzzle[position].append(0)
                }
                else if line.characterAt(at: position) == "O" {
                    var lastPuzzlePosition = puzzle[position].count - 1
                    if lastPuzzlePosition == -1 { puzzle[position].append(0); lastPuzzlePosition += 1 }
                    puzzle[position][lastPuzzlePosition] += 1
                }
            }
        }
        
        let (height, width) = (lines.count, lines[0].count)
        var ans = 0
        
        for j in 0..<height {
            var sum = 0
            for i in 0..<width {
                if stableRocks[i].count > 0 && j == stableRocks[i].first! {
                    let _ = stableRocks[i].removeFirst()
                    if !puzzle[i].isEmpty { let _ = puzzle[i].removeFirst() }
                    continue
                }
                if puzzle[i].isEmpty || puzzle[i].first! == 0 { continue }
                puzzle[i][0] -= 1; sum += 1
            }
            ans += sum * (height - j - 1)
        }
        
        return ans
    }
    
    internal func getLineUsing(rocks: [Int], puzzleLine: [Int], len: Int) -> String {
        var currentLine = String.init(repeating: ".", count: len)
        if rocks.count == 0 && puzzleLine.count == 0 { return currentLine }
        for rockPosition in rocks { currentLine.replaceCharacter(at: rockPosition, with: "#") }
        var index = 0
        var rocksPositions = rocks
        for roundedRock in puzzleLine {
            if roundedRock > 0 {
                for _ in 0..<roundedRock {
                    currentLine.replaceCharacter(at: index, with: "O")
                    index += 1
                }
                if rocksPositions.count > 0 {
                    index = rocksPositions.removeFirst() + 1
                }
            } else if roundedRock == 0 {
                if rocksPositions.count > 0 {
                    index = rocksPositions.removeFirst() + 1
                }
            }
        }
        return String(currentLine.reversed())
    }
    
    internal func part02(fromContent: String) throws -> Output02 {
        var lines: [String] = fromContent.components(separatedBy: .newlines).filter{ !$0.isEmpty }
        
        var puzzle: [[Int]] = Array.init(repeating: [0], count: lines[0].count)
        var stableRocks : [[Int]] = Array.init(repeating: [], count: lines[0].count)
        
        var cycleChecker: [[String]: Int] = [:]
        var cycleCount  : [Int] = []
        
        for i in 0...1000000000 {
            
            // NORTH
            
            puzzle      = Array.init(repeating: [0], count: lines[0].count)
            stableRocks = Array.init(repeating: [], count: lines[0].count)
            
            for (lineIndex, line) in lines.enumerated() {
                for position in 0..<line.count {
                    if line.characterAt(at: position) == "#" {
                        stableRocks[position].append(lineIndex)
                        puzzle[position].append(0)
                    }
                    else if line.characterAt(at: position) == "O" {
                        var lastPuzzlePosition = puzzle[position].count - 1
                        if lastPuzzlePosition == -1 { puzzle[position].append(0); lastPuzzlePosition += 1 }
                        puzzle[position][lastPuzzlePosition] += 1
                    }
                }
            }
            
            var newPuzzleLines: [String] = []
            for position in 0..<lines[0].count {
                newPuzzleLines.append(getLineUsing(rocks: stableRocks[position], puzzleLine: puzzle[position], len: lines.count))
            }
            lines = newPuzzleLines
            
            // WEST
            
            puzzle      = Array.init(repeating: [0], count: lines[0].count)
            stableRocks = Array.init(repeating: [], count: lines[0].count)
            
            for (lineIndex, line) in lines.enumerated() {
                for position in 0..<line.count {
                    if line.characterAt(at: position) == "#" {
                        stableRocks[position].append(lineIndex)
                        puzzle[position].append(0)
                    }
                    else if line.characterAt(at: position) == "O" {
                        var lastPuzzlePosition = puzzle[position].count - 1
                        if lastPuzzlePosition == -1 { puzzle[position].append(0); lastPuzzlePosition += 1 }
                        puzzle[position][lastPuzzlePosition] += 1
                    }
                }
            }
            
            
            newPuzzleLines = []
            for position in 0..<lines[0].count {
                newPuzzleLines.append(getLineUsing(rocks: stableRocks[position], puzzleLine: puzzle[position], len: lines.count))
            }
            lines = newPuzzleLines
            
            // SOUTH
            
            puzzle      = Array.init(repeating: [0], count: lines[0].count)
            stableRocks = Array.init(repeating: [], count: lines[0].count)
            
            for (lineIndex, line) in lines.enumerated() {
                for position in 0..<line.count {
                    if line.characterAt(at: position) == "#" {
                        stableRocks[position].append(lineIndex)
                        puzzle[position].append(0)
                    }
                    else if line.characterAt(at: position) == "O" {
                        var lastPuzzlePosition = puzzle[position].count - 1
                        if lastPuzzlePosition == -1 { puzzle[position].append(0); lastPuzzlePosition += 1 }
                        puzzle[position][lastPuzzlePosition] += 1
                    }
                }
            }
            
            
            newPuzzleLines = []
            for position in 0..<lines[0].count {
                newPuzzleLines.append(getLineUsing(rocks: stableRocks[position], puzzleLine: puzzle[position], len: lines.count))
            }
            lines = newPuzzleLines
            
            // EAST
            
            puzzle      = Array.init(repeating: [0], count: lines[0].count)
            stableRocks = Array.init(repeating: [], count: lines[0].count)
            
            for (lineIndex, line) in lines.enumerated() {
                for position in 0..<line.count {
                    if line.characterAt(at: position) == "#" {
                        stableRocks[position].append(lineIndex)
                        puzzle[position].append(0)
                    }
                    else if line.characterAt(at: position) == "O" {
                        var lastPuzzlePosition = puzzle[position].count - 1
                        if lastPuzzlePosition == -1 { puzzle[position].append(0); lastPuzzlePosition += 1 }
                        puzzle[position][lastPuzzlePosition] += 1
                    }
                }
            }
            
            newPuzzleLines = []
            for position in 0..<lines[0].count {
                newPuzzleLines.append(getLineUsing(rocks: stableRocks[position], puzzleLine: puzzle[position], len: lines.count))
            }
            lines = newPuzzleLines
            
            // COMPUTE CYCLE
            
            if let _ = cycleChecker[lines] { break }
            
            var ans: Int = 0
            let height = lines.count
            // Keep stableRocks as north's option
            for j in 0..<height {
                ans += (lines[j].components(separatedBy: "O").count - 1) * (height - j)
            }

            cycleCount.append(ans)   // Save the computation (maybe too expensive ?)
            cycleChecker[lines] = i  // Save the cycle
        }
        
        var index: Int = cycleChecker[lines]!
        index = (1000000000 - cycleChecker.count - 1) % (cycleChecker.count - index) + index
        return cycleCount[index] // Get the computation at the right cycle
    }
}
