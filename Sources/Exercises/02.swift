//
//  02.swift
//  aoc2023
//
//  Created by Antonin on 12/11/2023.
//

import Foundation

class Day02 : Day {
    
    typealias Output01 = Int
    typealias Output02 = Int
    
    internal var tag = "02"
    
    init() {}
    
    internal func part01(fromContent: String) throws -> Output01 {
        // Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green
        let limit = [14, 13, 12] // B, G, R
        var ok_games = 0
        let lines = fromContent.components(separatedBy: .newlines)
        for (game_id, var line) in lines.enumerated() {
            if line.isEmpty { continue }
            // Skip until ':'
            if let gameNumberRange = line.range(of: ":") {
                line.removeSubrange(line.startIndex..<gameNumberRange.upperBound)
            }
            // Separate by subgame
            let subgames = line.components(separatedBy: .init(charactersIn: ";"))
            var valid_subgame = true
            for subgame in subgames {
                // Separate by comma
                var cubes = subgame.components(separatedBy: .init(charactersIn: ","))
                cubes = cubes.map { $0.trimmingCharacters(in: .whitespaces) }
                for cube in cubes {
                    // The first component is **always** the number
                    // The second component is **always** the color / type of cube
                    let cube_information = cube.components(separatedBy: .whitespaces)
                    let nb_cubes = Int(cube_information[0]) ?? 0
                    switch cube_information[1] {
                        case "blue" : if nb_cubes > limit[0] { valid_subgame = false; break }
                        case "green" : if nb_cubes > limit[1] { valid_subgame = false; break }
                        case "red" : if nb_cubes > limit[2] { valid_subgame = false; break }
                        default: print("ERROR: Something goes wrong - missing cube identity!");
                    }
                }
                if (!valid_subgame) { break }
            }
            if (valid_subgame) { ok_games += (game_id + 1) }
        }
        return ok_games
    }
    
    internal func part02(fromContent: String) throws -> Output02 {
        // Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green
        var ans = 0
        let lines = fromContent.components(separatedBy: .newlines)
        for var line in lines {
            if line.isEmpty { continue }
            // Skip until ':'
            if let gameNumberRange = line.range(of: ":") {
                line.removeSubrange(line.startIndex..<gameNumberRange.upperBound)
            }
            // Separate by subgame
            let subgames = line.components(separatedBy: .init(charactersIn: ";"))
            var fewest_nb_cubes = [0, 0, 0]
            for subgame in subgames {
                // Separate by comma
                var cubes = subgame.components(separatedBy: .init(charactersIn: ","))
                cubes = cubes.map { $0.trimmingCharacters(in: .whitespaces) }
                for cube in cubes {
                    // The first component is **always** the number
                    // The second component is **always** the color / type of cube
                    let cube_information = cube.components(separatedBy: .whitespaces)
                    let nb_cubes = Int(cube_information[0]) ?? 0
                    switch cube_information[1] {
                        case "blue" : if nb_cubes > fewest_nb_cubes[0] { fewest_nb_cubes[0] = nb_cubes; break }
                        case "green" : if nb_cubes > fewest_nb_cubes[1] { fewest_nb_cubes[1] = nb_cubes; break }
                        case "red" : if nb_cubes > fewest_nb_cubes[2] { fewest_nb_cubes[2] = nb_cubes; break }
                        default: print("ERROR: Something goes wrong - missing cube identity!");
                    }
                }
            }
            ans += fewest_nb_cubes.reduce(1, { $0 * $1 })
        }
        return ans
    }
}

