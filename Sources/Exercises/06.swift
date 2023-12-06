//
//  06.swift
//  aoc2023
//
//  Created by Antonin on 12/11/2023.
//

import Foundation

class Day06 : Day {
    
    typealias Output01 = Int
    typealias Output02 = Int
    
    internal var tag = "06"
    
    init() {}
    
    internal func part01(fromContent: String) throws -> Output01 {
        let lines: [String] = fromContent.components(separatedBy: .newlines)
        var times: [Int] = []
        var distances: [Int] = []
        for (index, line) in lines.enumerated() {
            if line.isEmpty { continue }
            if index == 0 {
                times = line.components(separatedBy: .init(charactersIn: ":"))[1]
                    .trimmingCharacters(in: .whitespacesAndNewlines)
                    .components(separatedBy: .whitespaces)
                    .filter { !$0.isEmpty }
                    .map { Int($0) ?? 0}
            }
            else {
                distances = line.components(separatedBy: .init(charactersIn: ":"))[1]
                    .trimmingCharacters(in: .whitespacesAndNewlines)
                    .components(separatedBy: .whitespaces)
                    .filter { !$0.isEmpty }
                    .map { Int($0) ?? 0}
            }
        }
        var ans: [Int] = []
        for i in 0..<times.count {
            let beg : Int = Int(ceil(Double(distances[i] / times[i])))
            var prevValues: (Int, Int) = (0, 0)
            var cValue: Int = beg
            while true {
                let result = (times[i] - cValue) * cValue
                if (prevValues.1 > result) && (cValue < distances[i]) { break }
                else if result > distances[i] { prevValues.0 += 1 }
                cValue += 1
            }
            ans.append(prevValues.0)
        }
        return ans.reduce(1, { $0 * $1 })
    }
    
    internal func part02(fromContent: String) throws -> Output02 {
        let lines: [String] = fromContent.components(separatedBy: .newlines)
        var time: Int = 0
        var distance: Int = 0
        for (index, line) in lines.enumerated() {
            if line.isEmpty { continue }
            if index == 0 {
                let value = line.components(separatedBy: .init(charactersIn: ":"))[1]
                    .trimmingCharacters(in: .whitespacesAndNewlines)
                    .replacingOccurrences(of: " ", with: "")
                time = Int(value) ?? 0
            }
            else {
                let value = line.components(separatedBy: .init(charactersIn: ":"))[1]
                    .trimmingCharacters(in: .whitespacesAndNewlines)
                    .replacingOccurrences(of: " ", with: "")
                distance = Int(value) ?? 0
            }
        }
        
        var beg : Int = Int(ceil(Double(distance / time)))
        var prevValues: (Int, Int) = (0, 0)
        while true {
            let result = (time - beg) * beg
            if (prevValues.1 > result) { break } // Early return
            else if result > distance { prevValues.0 += 1 }
            beg += 1; prevValues.1 = result
        }
        
        return prevValues.0 * 2 - 1 // Function "bell"
    }
}
