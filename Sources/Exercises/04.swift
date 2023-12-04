//
//  04.swift
//  aoc2023
//
//  Created by Antonin on 12/11/2023.
//

import Foundation

class Day04 : Day {
    
    typealias Output01 = Int
    typealias Output02 = Int
    
    internal var tag = "04"
    
    init() {}
    
    internal func part01(fromContent: String) throws -> Output01 {
        var ans = 0
        let lines = fromContent.components(separatedBy: .newlines)
        for (var line) in lines {
            // Card 1: 41 48 83 86 17 | 83 86  6 31 17  9 48 53
            if line.isEmpty { continue }
            line = line.components(separatedBy: .init(charactersIn: ":"))[1]
            
            let cards: [String] = line.components(separatedBy: .init(charactersIn: "|"))
            let winningCards: [Int] = cards[0].components(separatedBy: .whitespaces).map { Int($0) ?? 0}.filter { $0 > 0 }
            let playerCards: [Int] = cards[1].components(separatedBy: .whitespaces).map { Int($0) ?? 0}.filter { $0 > 0 }
            let countCommonCards = Set(winningCards).intersection(Set(playerCards)).count
            
            if (countCommonCards == 0) { continue }
            ans += Int(pow(Double(2), Double(countCommonCards - 1)))
        }
        return ans
    }
    
    internal func part02(fromContent: String) throws -> Output02 {
        let lines = fromContent.components(separatedBy: .newlines).filter{ !$0.isEmpty }
        var copies: [Int] = [Int].init(repeating: 1, count: lines.count)
        for (index, var line) in lines.enumerated() {
            // Card 1: 41 48 83 86 17 | 83 86  6 31 17  9 48 53
            if line.isEmpty { continue }
            line = line.components(separatedBy: .init(charactersIn: ":"))[1]
            
            let cards: [String] = line.components(separatedBy: .init(charactersIn: "|"))
            let winningCards: [Int] = cards[0].components(separatedBy: .whitespaces).map { Int($0) ?? 0}.filter { $0 > 0 }
            let playerCards: [Int] = cards[1].components(separatedBy: .whitespaces).map { Int($0) ?? 0}.filter { $0 > 0 }
            let countCommonCards = Set(winningCards).intersection(Set(playerCards)).count
            
            for i in 0..<countCommonCards {
                copies[index + i + 1] += copies[index]
            }
        }
        return copies.reduce(0, { $0 + $1 })
    }
}
