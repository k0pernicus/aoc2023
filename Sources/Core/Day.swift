//
//  Day.swift
//  aoc2023
//
//  Created by Antonin on 12/11/2023.
//

import Foundation

public protocol Day {
    /// Output type for the part1
    associatedtype Output01: CustomStringConvertible = String
    /// Output type for the part2
    associatedtype Output02: CustomStringConvertible = String
    /// Tag name of the exercise
    var tag: String { get set }
    /// Computes and returns the result of the part1
    func part01(fromFile: String) throws -> Output01
    /// Computes and returns the result of the part1 - used principally for testing
    func part01(fromContent: String) throws -> Output01
    /// Computes and returns the result of the part2
    func part02(fromFile: String) throws -> Output02
    /// Computes and returns the result of the part2 - used principally for testing
    func part02(fromContent: String) throws -> Output02
}

extension Day {
    public func part01(fromFile filepath: String) throws -> Output01 {
        let fileContent = try String(contentsOfFile: filepath, encoding: .utf8)
        return try part01(fromContent: fileContent)
    }
    public func part02(fromFile filepath: String) throws -> Output02 {
        let fileContent = try String(contentsOfFile: filepath, encoding: .utf8)
        return try part02(fromContent: fileContent)
    }
}
