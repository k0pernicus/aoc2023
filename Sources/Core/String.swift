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
    
    public func index(from: Int) -> Index {
        return self.index(startIndex, offsetBy: from)
    }

    public func substring(from: Int) -> String {
        let fromIndex = index(from: from)
        return String(self[fromIndex...])
    }

    public func substring(to: Int) -> String {
        let toIndex = index(from: to)
        return String(self[..<toIndex])
    }

    public func substring(with r: Range<Int>) -> String {
        let startIndex = index(from: r.lowerBound)
        let endIndex = index(from: r.upperBound)
        return String(self[startIndex..<endIndex])
    }

}
