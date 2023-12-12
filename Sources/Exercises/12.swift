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
    
    struct SearchCache: Hashable {
        let i: Int
        let j: Int
        let countGroup: Int
    }
    
    // Process with memoization
    internal func deepSearch(recordIndex: Int, groupIndex: Int, countGroup: Int, record: String, groups: [Int], cache: inout [SearchCache: Int]) -> Int {
        if let value = cache[SearchCache(i: recordIndex, j: groupIndex, countGroup: countGroup)] { // Found in map - return the memoized value
            return value
        }
        if recordIndex == record.count { // Final character
            if (groupIndex == (groups.count - 1) && groups[groupIndex] == countGroup) { // New alternative
                cache[SearchCache(i: recordIndex, j: groupIndex, countGroup: countGroup)] = 1
                return 1
            }
            if (groupIndex == groups.count && countGroup == 0) { // New alternative
                cache[SearchCache(i: recordIndex, j: groupIndex, countGroup: countGroup)] = 1
                return 1
            }
            // Not an alternative
            cache[SearchCache(i: recordIndex, j: groupIndex, countGroup: countGroup)] = 0
            return 0
        }
        var ans = 0
        // Each character can be "#" or "." -> "?" can have 2 values there, let explore the two options !
        //
        // Option A: Explore the fact that it can be a new group
        if Array(["#", "?"]).contains(record.characterAt(at: recordIndex)) {
            // New group !
            let count = deepSearch(recordIndex: recordIndex + 1, 
                                   groupIndex: groupIndex,
                                   countGroup: countGroup + 1,
                                   record: record,
                                   groups: groups,
                                   cache: &cache)
            cache[SearchCache(i: recordIndex + 1, j: groupIndex, countGroup: countGroup + 1)] = count
            ans += count
        }
        // Option B: Explore the fact that it can be a no-group
        if Array([".", "?"]).contains(record.characterAt(at: recordIndex)) {
            if countGroup == 0 {
                let count = deepSearch(recordIndex: recordIndex + 1, 
                                       groupIndex: groupIndex,
                                       countGroup: 0,
                                       record: record,
                                       groups: groups,
                                       cache: &cache)
                cache[SearchCache(i: recordIndex + 1, j: groupIndex, countGroup: 0)] = count
                ans += count
            }
            else if countGroup > 0 && groupIndex < groups.count && groups[groupIndex] == countGroup {
                let count = deepSearch(recordIndex: recordIndex + 1, 
                                       groupIndex: groupIndex + 1,
                                       countGroup: 0,
                                       record: record,
                                       groups: groups,
                                       cache: &cache)
                cache[SearchCache(i: recordIndex + 1, j: groupIndex + 1, countGroup: 0)] = count
                ans += count
            }
        }
        // Cache & return
        cache[SearchCache(i: recordIndex, j: groupIndex, countGroup: countGroup)] = ans
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
            let countTotalGoodCombinations: Int = deepSearch(recordIndex: 0,
                                                             groupIndex: 0,
                                                             countGroup: 0,
                                                             record: record,
                                                             groups: groupsToFind,
                                                             cache: &cache)
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
            let countTotalGoodCombinations: Int = deepSearch(recordIndex: 0,
                                                             groupIndex: 0,
                                                             countGroup: 0,
                                                             record: fiveRecord,
                                                             groups: groupsToFind,
                                                             cache: &cache)
            ans += countTotalGoodCombinations
        }
        
        return ans
    }
}
