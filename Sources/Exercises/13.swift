//
//  13.swift
//  aoc2023
//
//  Created by Antonin on 12/11/2023.
//

import Foundation

class Day13 : Day {
    
    typealias Output01 = Int
    typealias Output02 = Int
    
    internal var tag = "13"
    
    init() {}
    
    struct Mirror: Hashable {
        enum Reflection: Int {
            case horizontal = 0, vertical
        }
        let reflection: Reflection
        let index: Int // This indicates the INDEX of the string, and not the position (to get the position add 1)
    }
    
    internal func propagateReflectionPart1(input: [String],
                                      reflection: Mirror.Reflection,
                                      beg: Int,
                                      end: Int,
                                      height: Int,
                                      width: Int) -> Bool {
        if beg < 0 || (end >= height && reflection == .horizontal) { return true }
        switch (reflection) {
        case .horizontal:
            if input[beg] != input[end] { return false }
            else { return propagateReflectionPart1(input: input, reflection: reflection, beg: beg - 1, end: end + 1, height: height, width: width) }
        case .vertical:
            for line in input {
                if beg < 0 || end >= width { continue }
                if line.characterAt(at: beg) != line.characterAt(at: end) { return false }
            }
            return propagateReflectionPart1(input: input, reflection: reflection, beg: beg - 1, end: end + 1, height: height, width: width)
        }
    }
    
    internal func propagateReflectionPart2(input: [String],
                                      reflection: Mirror.Reflection,
                                      beg: Int,
                                      end: Int,
                                      height: Int,
                                      width: Int,
                                      smudge: inout Bool) -> Bool {
        if beg < 0 || (end >= height && reflection == .horizontal) { return true }
        switch (reflection) {
        case .horizontal:
            if input[beg] != input[end] { if smudge || ((zip(input[beg], input[end]).filter { $0 != $1 }.count) > 1) { return false } else { smudge = true } }
            return propagateReflectionPart2(input: input, reflection: reflection, beg: beg - 1, end: end + 1, height: height, width: width, smudge: &smudge)
        case .vertical:
            for line in input {
                if beg < 0 || end >= width { continue }
                if line.characterAt(at: beg) != line.characterAt(at: end) { if smudge { return false } else { smudge = true } }
            }
            return propagateReflectionPart2(input: input, reflection: reflection, beg: beg - 1, end: end + 1, height: height, width: width, smudge: &smudge)
        }
    }
    
    // TODO: Case of multiple Mirrors in same line ?
    internal func findReflections(input: [String], hasSmudge: Bool) -> [Mirror] {
        // Check for vertical mirrors
        if input.isEmpty { return [] }
        let width = input[0].count
        let height = input.count
        var ans: [Mirror] = []
        for y in 0..<height {
            if (y == (height - 1)) { continue }
            let (beg, end) = (y, y + 1)
            if !hasSmudge {
                if propagateReflectionPart1(input: input, reflection: .horizontal, beg: beg, end: end, height: height, width: width) {
                    ans.append(Mirror(reflection: .horizontal, index: beg)); return ans
                }
            } else {
                var smudge = false
                let okPropagation = propagateReflectionPart2(input: input, reflection: .horizontal, beg: beg, end: end, height: height, width: width, smudge: &smudge)
                if okPropagation && smudge { ans.append(Mirror(reflection: .horizontal, index: beg)); return ans }
            }
        }
        for x in 0..<width {
            for _ in input {
                if (x == (width - 1)) { continue }
                if !hasSmudge {
                    if propagateReflectionPart1(input: input, reflection: .vertical, beg: x, end: x + 1, height: height, width: width) {
                        ans.append(Mirror(reflection: .vertical, index: x)); return ans
                    }
                } else {
                    var smudge = false
                    let okPropagation = propagateReflectionPart2(input: input, reflection: .vertical, beg: x, end: x + 1, height: height, width: width, smudge: &smudge)
                    if okPropagation && smudge { ans.append(Mirror(reflection: .vertical, index: x)); return ans }
                }
            }
        }
        
        return ans
    }
    
    internal func part01(fromContent: String) throws -> Output01 {
        let lines = fromContent.components(separatedBy: .newlines)
        var (input, cInput): ([[String]], [String]) = ([], [])
        for line in lines {
            if line.isEmpty { input.append(cInput); cInput = [] }
            else { cInput.append(line) }
        }
        var ans: Int = 0
        for puzzle in input {
            let mirrors = findReflections(input: puzzle, hasSmudge: false)
            // if mirrors.isEmpty { print("Puzzle \(i) -> EMPTY") }
            for mirror in mirrors {
                switch mirror.reflection {
                case .horizontal: ans += 100 * (mirror.index + 1)
                case .vertical:   ans += (mirror.index + 1)
                }
                break
            }
        }
        return ans
    }
    
    internal func part02(fromContent: String) throws -> Output02 {
        let lines = fromContent.components(separatedBy: .newlines)
        var (input, cInput): ([[String]], [String]) = ([], [])
        for line in lines {
            if line.isEmpty { input.append(cInput); cInput = [] }
            else { cInput.append(line) }
        }
        var ans: Int = 0
        for puzzle in input {
            let mirrors = findReflections(input: puzzle, hasSmudge: true)
            // if mirrors.isEmpty { print("Puzzle \(i) -> EMPTY") }
            for mirror in mirrors {
                switch mirror.reflection {
                case .horizontal: ans += 100 * (mirror.index + 1)
                case .vertical:   ans += (mirror.index + 1)
                }
                break
            }
        }
        return ans
    }
}
