//
//  File.swift
//  
//
//  Created by Antonin on 12/11/2023.
//

import Foundation

public enum Core {
    /// Custom file data structure
    public struct File<Element> {
        let filepath: String
    }
}

extension Core.File {
    /// Read file and parse the content
    func loadAndParseUsingSeparator(transform: (String) -> Element, separator: CharacterSet = .whitespacesAndNewlines) -> [Element]? {
        do {
            let fileContent = try String(contentsOfFile: self.filepath, encoding: .utf8)
            let tokens = fileContent.components(separatedBy: separator)
            // Reserve capacity for the final array - is there a better way to perform this operation in one call?
            var finalTokens = [Element]()
            finalTokens.reserveCapacity(tokens.count)
            // Transform the tokens
            for i in 0..<tokens.count {
                finalTokens[i] = transform(tokens[i])
            }
            return finalTokens
        } catch let error as NSError {
            print("ERROR: loadAndParseUsingSeparator has not been executed properly - \(error)")
            return nil
        }
    }
}

extension Core.File where Element == String {
    /// Read file and parse the content
    func loadAndParseUsingSeparator(separator: CharacterSet = .whitespacesAndNewlines) -> [Element]? {
        do {
            let fileContent = try String(contentsOfFile: self.filepath, encoding: .utf8)
            return fileContent.components(separatedBy: separator)
        } catch let error as NSError {
            print("ERROR: loadAndParseUsingSeparator has not been executed properly - \(error)")
            return nil
        }
    }
}
