//
//  Maths.swift
//
//
//  Created by antonin on 08/12/2023.
//

import Foundation

/// Returns the Greatest Common Divisor value of two numbers
func gcd(_ x: Int, _ y: Int) -> Int {
    var a = 0
    var b = max(x, y)
    var r = min(x, y)
    
    while r != 0 {
        a = b
        b = r
        r = a % b
    }
    return b
}

/// Returns the Least Common Multiple value of two numbers.
func lcm(_ x: Int, _ y: Int) -> Int {
    return x / gcd(x, y) * y
}

/// Returns the Least Common Multiple value of multiple numbers
func lcm(for values: [Int]) -> Int {
    let uniqueValues = Array(Set(values))
    guard uniqueValues.count >= 2 else {
        return uniqueValues.first ?? 0
    }
    var currentLcm = lcm(uniqueValues[0], uniqueValues[1])
    for value in uniqueValues[2 ..< uniqueValues.count] {
        currentLcm = lcm(currentLcm, value)
    }
    return currentLcm
}

extension Sequence where Element: Numeric {
    /// Sum the elements of the Numeric array
    func sum(start at: Int = 0) -> Element { return reduce(0, +) }
}
