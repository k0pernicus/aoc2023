//
//  Array.swift
//  
//
//  Created by antonin on 12/12/2023.
//

import Foundation

extension Array {
    var combinationsWithoutRepetition: [[Element]] {
        guard !isEmpty else { return [[]] }
        return Array(self[1...]).combinationsWithoutRepetition.flatMap { [$0, [self[0]] + $0] }
    }
}

// -90 degrees
func transpose(_ input: [[Int]]) -> [[Int]] {
    let columns = input.count
    let rows = input.reduce(0) { max($0, $1.count) }

    var result: [[Int]] = []

    for row in 0 ..< rows {
        result.append([])
        for col in 0 ..< columns {
            if row < input[col].count { result[row].append(input[col][row]) }
            else { result[row].append(0) }
        }
    }

    return result
}
