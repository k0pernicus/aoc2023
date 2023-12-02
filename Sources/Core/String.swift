//
//  File 2.swift
//  
//
//  Created by antonin on 01/12/2023.
//

import Foundation

extension String {
    /// Replace the first occurence of a pattern
    public func replaceFirstExpression(of pattern: String, with replacement: String) -> String? {
        if let range = self.range(of: pattern){
            return self.replacingCharacters(in: range, with: replacement)
        }
        return nil
    }
    
    /// Returns all the indices where the string pattern appears in the original string
    public func indices(of pattern: String) -> [Int] {
            var indices = [Int]()
            var searchStartIndex = self.startIndex

            while searchStartIndex < self.endIndex,
                let range = self.range(of: pattern, range: searchStartIndex..<self.endIndex),
                !range.isEmpty
            {
                let index = distance(from: self.startIndex, to: range.lowerBound)
                indices.append(index)
                searchStartIndex = range.upperBound
            }

            return indices
        }
}
