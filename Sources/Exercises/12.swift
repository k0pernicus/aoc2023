//
//  12.swift
//  aoc2023
//
//  Created by Antonin on 12/11/2023.
//

import Foundation

class Day12 : Day {
    
    typealias Output01 = Int
    typealias Output02 = Int
    
    internal var tag = "12"
    
    init() {}
    
    internal func countGroups(s: String) -> [Int] {
        var groups: [Int] = []
        var count = 0
        for c in s {
            if c == "." || c == "?" { if count == 0 { continue } else { groups.append(count); count = 0; continue; } }
            else { count += 1 }
        }
        if count != 0 { groups.append(count) }
        return groups
    }
    
    struct SearchCache: Hashable {
        let i: Int
        let j: Int
        let countGroup: Int
    }
    
    // Process with memoization
    internal func deepSearch(i: Int, j: Int, countGroup: Int, record: String, groups: [Int], cache: inout [SearchCache: Int]) -> Int {
        if let value = cache[SearchCache(i: i, j: j, countGroup: countGroup)] { // Found in map - return the memoized value
            return value
        }
        if i == record.count { // Final character
            if (j == (groups.count - 1) && groups[j] == countGroup) { // New alternative
                cache[SearchCache(i: i, j: j, countGroup: countGroup)] = 1
                return 1
            }
            if (j == groups.count && countGroup == 0) { // New alternative
                cache[SearchCache(i: i, j: j, countGroup: countGroup)] = 1
                return 1
            }
            // Not an alternative
            cache[SearchCache(i: i, j: j, countGroup: countGroup)] = 0
            return 0
        }
        var ans = 0
        if Array(["#", "?"]).contains(record.characterAt(at: i)) {
            // New group !
            let count = deepSearch(i: i + 1, j: j, countGroup: countGroup + 1, record: record, groups: groups, cache: &cache)
            cache[SearchCache(i: i + 1, j: j, countGroup: countGroup + 1)] = count
            ans += count
        }
        if Array([".", "?"]).contains(record.characterAt(at: i)) {
            if countGroup == 0 {
                let count = deepSearch(i: i+1, j: j, countGroup: 0, record: record, groups: groups, cache: &cache)
                cache[SearchCache(i: i + 1, j: j, countGroup: 0)] = count
                ans += count
            }
            else if countGroup > 0 && j < groups.count && groups[j] == countGroup {
                let count = deepSearch(i: i+1, j: j + 1, countGroup: 0, record: record, groups: groups, cache: &cache)
                cache[SearchCache(i: i + 1, j: j + 1, countGroup: 0)] = count
                ans += count
            }
        }
        cache[SearchCache(i: i, j: j, countGroup: countGroup)] = ans
        return ans
    }
    
    internal func part01(fromContent: String) throws -> Output01 {
        let input = fromContent.components(separatedBy: .newlines)
        var ans = 0
        for var line in input {
            if line.isEmpty { continue }
            line = line.trimmingCharacters(in: .whitespaces)
            let components = line.components(separatedBy: .whitespaces)
            assert(components.count == 2)
            let (record, damagedGroup) = (components[0], components[1])
            
            let damagedGroupIndices = record.indices(of: "?")
            if damagedGroupIndices.isEmpty { continue }
            
            let groupsToFind = damagedGroup.components(separatedBy: .init(charactersIn: ","))
                .filter({ !$0.isEmpty })
                .map({ Int($0)! })
            
            var cache: [SearchCache: Int] = [:]
            let countTotalGoodCombinations: Int = deepSearch(i: 0, j: 0, countGroup: 0, record: record, groups: groupsToFind, cache: &cache)
            ans += countTotalGoodCombinations
        }
        
        return ans
    }
    
    internal func part02(fromContent: String) throws -> Output02 {
        let input = fromContent.components(separatedBy: .newlines)
        var ans = 0
        for var line in input {
            if line.isEmpty { continue }
            line = line.trimmingCharacters(in: .whitespaces)
            let components = line.components(separatedBy: .whitespaces)
            assert(components.count == 2)
            let (record, damagedGroup) = (components[0], components[1])
            
            let fiveRecord = record + "?" + record + "?" + record + "?" + record + "?" + record
            let fiveDamagedGroup = damagedGroup + "," + damagedGroup + "," + damagedGroup + "," + damagedGroup + "," + damagedGroup
            
            let damagedGroupIndices = fiveRecord.indices(of: "?")
            if damagedGroupIndices.isEmpty { continue }
            
            let groupsToFind = fiveDamagedGroup.components(separatedBy: .init(charactersIn: ","))
                .filter({ !$0.isEmpty })
                .map({ Int($0)! })
            
            var cache: [SearchCache: Int] = [:]
            let countTotalGoodCombinations: Int = deepSearch(i: 0, j: 0, countGroup: 0, record: fiveRecord, groups: groupsToFind, cache: &cache)
            ans += countTotalGoodCombinations
        }
        
        return ans
    }
}
