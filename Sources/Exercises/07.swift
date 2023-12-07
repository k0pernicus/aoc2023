//
//  07.swift
//  aoc2023
//
//  Created by Antonin on 12/11/2023.
//

import Foundation

struct Tag: RawRepresentable {
    var rawValue: String
}

extension Tag: Comparable {
    static func <(lhs: Tag, rhs: Tag) -> Bool {
        for i in 0..<lhs.rawValue.count {
            let lhsOffset = String.Index(utf16Offset: i, in: lhs.rawValue)
            let rhsOffset = String.Index(utf16Offset: i, in: rhs.rawValue)
            if (lhs.rawValue[lhsOffset].isNumber && rhs.rawValue[rhsOffset].isNumber) || (lhs.rawValue[lhsOffset].isLetter && rhs.rawValue[rhsOffset].isLetter) {
                if lhs.rawValue[lhsOffset] == rhs.rawValue[rhsOffset] { continue }
                if (lhs.rawValue[lhsOffset].isLetter) {
                    switch (lhs.rawValue[lhsOffset], rhs.rawValue[rhsOffset]) {
                    // Priority is A, K, Q, J, T, X
                    case ("A", _): return true
                    case (_, "A"): return false
                    case ("K", _): return true
                    case (_, "K"): return false
                    case ("Q", _): return true
                    case (_, "Q"): return false
                    case ("J", _): return true
                    case (_, "J"): return false
                    case ("T", _): return true
                    case (_, "T"): return false
                    case ("X", _): return false // Replacement for "J" - part02
                    case (_, "X"): return true  // Replacement for "J" - part02
                    default: return false
                    }
                }
                return lhs.rawValue[lhsOffset] >= rhs.rawValue[rhsOffset]
            }
            switch (lhs.rawValue[lhsOffset], rhs.rawValue[rhsOffset]) {
            case ("X", _): return false
            case (_, "X"): return true
            default: return lhs.rawValue[lhsOffset].isLetter && rhs.rawValue[rhsOffset].isNumber
            }
        }
        return false
    }
}

class Day07 : Day {
    
    typealias Output01 = Int
    typealias Output02 = Int
    
    internal var tag = "07"
    
    init() {}
    
    enum Hand: Int {
        case fiveOfAKind = 0,
        fourOfAKind,
        fullHouse,
        threeOfAKind,
        twoPair,
        onePair,
        highCard
    }
    
    internal func toHand(hand: String, handleJokerCard: Bool) -> Hand {
        var occurences: [Character: Int] = [:]
        for c in hand {
            if let val = occurences[c] { occurences[c] = val + 1 } 
            else { occurences[c] = 1 }
        }
        
        var cardsToAdd: Int = 0 // Preparation for Part2
        
        // Preprocess for part2
        if (handleJokerCard) {
            if let nbCards = occurences["J"] { occurences.removeValue(forKey: "J"); cardsToAdd = nbCards }
        }
        
        var orderedOccurences = occurences.values.sorted(by: { $0 >= $1 })
        
        // Preprocess for part2
        if (handleJokerCard) {
            if orderedOccurences.count > 0 { orderedOccurences[0] += cardsToAdd }
            else { orderedOccurences.append(cardsToAdd) }
        }
        
        
        switch orderedOccurences[0] {
        case 5 : return .fiveOfAKind
        case 4 : return .fourOfAKind
        case 3 : if orderedOccurences[1] == 2 { return .fullHouse } else { return .threeOfAKind  }
        case 2 : if orderedOccurences[1] == 2 { return .twoPair } else { return .onePair }
        default: return .highCard
        }
    }
    
    internal func part01(fromContent: String) throws -> Output01 {
        let lines = fromContent.components(separatedBy: .newlines)
        
        var hands: [Hand: [String]] = [:]
        var bids : [String: Int] = [:]
        
        for line in lines {
            if line.isEmpty { continue }
            let components: [String] = line.components(separatedBy: .whitespaces)
            let (cards, bid) = (components[0], components[1])
            
            let hand: Hand  = toHand(hand: cards, handleJokerCard: false)
            if let _ = hands[hand] { hands[hand]?.append(cards) }
            else { hands[hand] = [cards] }
            bids[cards] = Int(bid) ?? 0
        }
        
        var (ans, rank) = (0, 1)
        
        for handKey in hands.keys.sorted(by: { $0.rawValue >= $1.rawValue }) {
            let values = hands[handKey]?.sorted { Tag(rawValue: $0) >= Tag(rawValue: $1) }
            for value in values! { ans = ans + (rank * bids[value]!); rank += 1 }
        }
        
        return ans
    }
    
    internal func part02(fromContent: String) throws -> Output02 {
        let lines = fromContent.components(separatedBy: .newlines)
        
        var hands: [Hand: [String]] = [:]
        var bids : [String: Int] = [:]
        
        for line in lines {
            if line.isEmpty { continue }
            let components: [String] = line.components(separatedBy: .whitespaces)
            var (cards, bid) = (components[0], components[1])
            
            let hand: Hand  = toHand(hand: cards, handleJokerCard: true)
            cards = cards.replacingOccurrences(of: "J", with: "X") // X is weaker than anything else
            if let _ = hands[hand] { hands[hand]?.append(cards) }
            else { hands[hand] = [cards] }
            bids[cards] = Int(bid) ?? 0
        }
        
        var (ans, rank) = (0, 1)
        
        for handKey in hands.keys.sorted(by: { $0.rawValue >= $1.rawValue }) {
            let values = hands[handKey]?.sorted { Tag(rawValue: $0) >= Tag(rawValue: $1) }
            for value in values! { ans = ans + (rank * bids[value]!);  rank += 1 }
        }
        
        return ans
    }
}
