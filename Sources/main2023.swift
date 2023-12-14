//
//  main.swift
//  aoc2023
//
//  Created by Antonin on 20/09/2023.
//

// Bug : can't be named main.swift because of this bug
// https://github.com/apple/swift/issues/55127

import Foundation
import ArgumentParser

@main
struct Program: ParsableCommand {
    @Argument(help: "The day exercises to run.")
    var day: Int
    
    @Option(name: [.customShort("i"), .long], help: "Path of the input file")
    var inputFile: String? = nil
    
    @Option(name: [.customShort("p"), .long], help: "Only part (1, 2) - default runs both parts")
    var part: Int? = nil

    mutating func run() throws {
        // Register the exercises
        let days: [any Day] = [
            Day01(),
            Day02(),
            Day03(),
            Day04(),
            Day05(),
            Day06(),
            Day07(),
            Day08(),
            Day09(),
            Day10(),
            Day11(),
            Day12(),
            Day13(),
            Day14()
        ]
        
        guard let filepath = inputFile else {
            // Early return
            print("ERROR: No input file")
            return
        }
        
        if day <= 0 || day > days.count {
            // Early return
            print("ERROR: No available exercise with tag '\(day)'")
            return
        }
        
        print("🎄 Day \(day)")
        
        if part == nil || part == 1 {
            let resultExercise01 = try days[day - 1].part01(fromFile: filepath)
            print("\t🎁 Part 01: \(resultExercise01)")
        }
        
        if part == nil || part == 2 {
            let resultExercise02 = try days[day - 1].part02(fromFile: filepath)
            print("\t🎁 Part 02: \(resultExercise02)")
        }
    }
}
