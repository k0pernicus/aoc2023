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
    
    // includes smudge
    internal func propagateReflection(input: [String],
                                      reflection: Mirror.Reflection,
                                      beg: Int,
                                      end: Int,
                                      height: Int,
                                      width: Int,
                                      smudge: inout Int) -> Bool {
        if beg < 0 || (end >= height && reflection == .horizontal) { return true }
        switch (reflection) {
        case .horizontal:
            if input[beg] != input[end] { if smudge == 0 || ((zip(input[beg], input[end]).filter { $0 != $1 }.count) > smudge) { return false } else { smudge -= 1 } }
            return propagateReflection(input: input,
                                            reflection: reflection,
                                            beg: beg - 1, end: end + 1,
                                            height: height, width: width,
                                            smudge: &smudge)
        case .vertical:
            for line in input {
                if beg < 0 || end >= width { continue }
                if line.characterAt(at: beg) != line.characterAt(at: end) { if smudge == 0 { return false } else { smudge -= 1 } }
            }
            return propagateReflection(input: input,
                                            reflection: reflection,
                                            beg: beg - 1, end: end + 1,
                                            height: height, width: width,
                                            smudge: &smudge)
        }
    }
    
    // hasSmudge defines is part2 (true)
    internal func findReflections(input: [String], smudgeNb: Int) -> Mirror? {
        if input.isEmpty { return nil }
        // Check for vertical mirrors
        let width = input[0].count
        let height = input.count
        // Begins with horizontal
        for y in 0..<height {
            if (y == (height - 1)) { continue }
            var smudge = smudgeNb
            let okPropagation = propagateReflection(input: input,
                                                    reflection: .horizontal,
                                                    beg: y, end: y + 1,
                                                    height: height, width: width,
                                                    smudge: &smudge)
            if okPropagation && smudge == 0 { return Mirror(reflection: .horizontal, index: y) }
        }
        // Ends with vertical
        for x in 0..<width {
            for _ in input {
                if (x == (width - 1)) { continue }
                var smudge = smudgeNb
                let okPropagation = propagateReflection(input: input,
                                                        reflection: .vertical,
                                                        beg: x, end: x + 1,
                                                        height: height, width: width,
                                                        smudge: &smudge)
                if okPropagation && smudge == 0 { return Mirror(reflection: .vertical, index: x) }
            }
        }
        // Should not happen - fatalError will be thrown later
        return nil
    }
    
    internal func solvePuzzles(fromContent: String, smudgeNb: Int) -> Int {
        let lines = fromContent.components(separatedBy: .newlines)
        var (input, cInput): ([[String]], [String]) = ([], [])
        for line in lines {
            if line.isEmpty { input.append(cInput); cInput = [] }
            else { cInput.append(line) }
        }
        var ans = 0
        for (i, puzzle) in input.enumerated() {
            guard let mirror = findReflections(input: puzzle, smudgeNb: smudgeNb) else { fatalError("Cannot find any reflection on puzzle \(i)") }
            switch mirror.reflection {
            case .horizontal: ans += 100 * (mirror.index + 1)
            case .vertical:   ans += (mirror.index + 1)
            }
        }
        return ans
    }
    
    internal func part01(fromContent: String) throws -> Output01 {
        return solvePuzzles(fromContent: fromContent, smudgeNb: 0)
    }
    
    internal func part02(fromContent: String) throws -> Output02 {
        return solvePuzzles(fromContent: fromContent, smudgeNb: 1)
    }
}
