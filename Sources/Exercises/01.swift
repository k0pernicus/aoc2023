//
//  01.swift
//  aoc2023
//
//  Created by Antonin on 12/11/2023.
//

import Foundation

class Day01 : Day {
    
    typealias Output01 = Int
    typealias Output02 = Int
    
    internal var tag = "01"
    
    init() {}
    
    internal func part01(fromContent content: String) throws -> Output01 {
        let input = content.components(separatedBy: .newlines)
        var sum: Int = 0
        for line in input {
            var calibration_value: String = ""
            for char in line {
                if char.isNumber { calibration_value = calibration_value + String(char); break }
            }
            for char in line.reversed() {
                if char.isNumber { calibration_value = calibration_value + String(char); break }
            }
            if calibration_value.isEmpty { break }
            sum += Int(calibration_value) ?? 0
        }
        return sum
    }
    
    internal func part02(fromContent content: String) throws -> Output02 {
        let input = content.components(separatedBy: .newlines)
        let correspondances: [String: String] = [
            "one" : "o1e",
            "two" : "t2o",
            "six" : "s6x",
            "four" : "f4r",
            "five" : "f5e",
            "nine" : "n9e",
            "three" : "t3e",
            "seven" : "s7n",
            "eight" : "e8t",
        ]
        var sum: Int = 0
        for var line in input {
            var calibration_value: String = ""
            // Replace
            var pattern_to_replace: [Int:String] = [:]
            for (of, _) in correspondances {
                let indices: [Int] = line.indices(of: of)
                if !indices.isEmpty {
                    for index in indices {
                        pattern_to_replace[index] = of
                    }
                }
            }
            for (_, of) in pattern_to_replace.sorted(by: { $0.0 < $1.0 }) {
                if let line_with_replacement = line.replaceFirstExpression(of: of, with: correspondances[of]!) {
                    line = line_with_replacement
                }
            }
            // Count
            for char in line {
                if char.isNumber { calibration_value = calibration_value + String(char); break }
            }
            for char in line.reversed() {
                if char.isNumber { calibration_value = calibration_value + String(char); break }
            }
            if calibration_value.isEmpty { break }
            sum += Int(calibration_value) ?? 0
        }
        return sum
    }
}
