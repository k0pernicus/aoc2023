//
//  05.swift
//  aoc2023
//
//  Created by Antonin on 12/11/2023.
//

import Foundation

class Day05 : Day {
    
    typealias Output01 = Int
    typealias Output02 = Int
    
    internal var tag = "05"
    
    init() {}
    
    struct MapInformation: Hashable, Equatable {
        let destination: Int
        let range: Int
    }
    
    internal func parseInput(input: [String]) -> ([Int], [[Int : MapInformation]]) {
        var currentMapping: [Int : MapInformation] = [:]
        var ans: [[Int : MapInformation]] = []
        let seeds: [Int] = input[0].components(separatedBy: ":")[1]
                                   .components(separatedBy: .whitespaces)
                                   .map { Int($0) ?? 0}
                                   .filter { $0 > 0}
        for line in input[1...] {
            if line.isEmpty {
                if !currentMapping.isEmpty { ans.append(currentMapping); currentMapping = [:] }
                continue
            }
            if line.contains("map") { continue }
            let map = line.components(separatedBy: .whitespaces)
            if map.count != 3 { fatalError("The line \(line) does not seem to be consistent") }
            let destination = Int(map[0])!
            let source = Int(map[1])!
            let nbSeeds = Int(map[2])!
            currentMapping[source] = MapInformation(destination: destination, range: nbSeeds)
        }
        return (seeds, ans)
    }
    
    internal func part01(fromContent: String) throws -> Output01 {
        let (seeds, maps) = parseInput(input: fromContent.components(separatedBy: .newlines))
        var lowestMapParcel: Int? = nil
        for seed in seeds {
            var destinationSeed = seed
            for map in maps {
                let sortedKeys = map.keys.sorted()
                for key in sortedKeys {
                    if key > destinationSeed { break }
                    if key <= destinationSeed && (key + map[key]!.range - 1) >= destinationSeed {
                        destinationSeed = map[key]!.destination + (destinationSeed - key)
                        break
                    }
                }
            }
            if lowestMapParcel == nil { lowestMapParcel = destinationSeed }
            else if lowestMapParcel! > destinationSeed { lowestMapParcel = destinationSeed }
        }
        return lowestMapParcel!
    }
    
    internal func part02(fromContent: String) throws -> Output02 {
        let (seeds, maps) = parseInput(input: fromContent.components(separatedBy: .newlines))
        let orderedMaps = maps.map { $0.keys.sorted() }
        var lowestMapParcel: Int? = nil
        var done: [Int: Bool] = [:] // It can happen that multiple values can be computed multiple times
        for i in 0..<seeds.count {
            if (i % 2 == 0) {
                let beg = seeds[i]
                let end = seeds[i+1]
                for seed in beg..<(beg+end) {
                    if done[seed] != nil { continue }
                    done[seed] = true
                    var destinationSeed = seed
                    for (mapIndex, map) in maps.enumerated() {
                        for key in orderedMaps[mapIndex] {
                            if key > destinationSeed { break }
                            if key <= destinationSeed && (key + map[key]!.range - 1) >= destinationSeed {
                                destinationSeed = map[key]!.destination + (destinationSeed - key)
                                break
                            }
                        }
                    }
                    if lowestMapParcel == nil { lowestMapParcel = destinationSeed }
                    else if lowestMapParcel! > destinationSeed { lowestMapParcel = destinationSeed }
                }
            }
            else { continue }
        }
        return lowestMapParcel!
    }
}
