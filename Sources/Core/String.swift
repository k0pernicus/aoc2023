//
//  File 2.swift
//  
//
//  Created by antonin on 01/12/2023.
//

import Foundation

extension String {
    public func replaceFirstExpression(of pattern: String, with replacement: String) -> String? {
        if let range = self.range(of: pattern){
            return self.replacingCharacters(in: range, with: replacement)
        }
        return nil
    }
    
    public func indices(of: String) -> [Int] {
            var indices = [Int]()
            var searchStartIndex = self.startIndex

            while searchStartIndex < self.endIndex,
                let range = self.range(of: of, range: searchStartIndex..<self.endIndex),
                !range.isEmpty
            {
                let index = distance(from: self.startIndex, to: range.lowerBound)
                indices.append(index)
                searchStartIndex = range.upperBound
            }

            return indices
        }
}
