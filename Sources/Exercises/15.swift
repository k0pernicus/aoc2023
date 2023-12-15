//
//  15.swift
//  aoc2023
//
//  Created by Antonin on 12/11/2023.
//

import Foundation

class Day15 : Day {
    
    typealias Output01 = Int
    typealias Output02 = Int
    
    internal var tag = "15"
    
    init() {}
    
    internal func getHash(label: String) -> Int {
        var currentValue = 0
        for character in label {
            currentValue += Int(character.asciiValue!)
            currentValue = currentValue * 17
            currentValue = currentValue % 256
        }
        return currentValue
    }
    
    internal func part01(fromContent: String) throws -> Output01 {
        var ans: Int = 0
        for input in fromContent.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: .init(charactersIn: ",")) {
            ans += getHash(label: input)
        }
        return ans
    }
    
    enum Operation {
        case Add(Int)
        case Remove
    }
    
    struct Lens {
        let label: String
        var focal: Int
    }
    
    internal func part02(fromContent: String) throws -> Output02 {
        var boxes: [[Lens]] = Array.init(repeating: [], count: 256)
        // var ans: Int = 0
        for input in fromContent.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: .init(charactersIn: ",")) {
            var label: String? = nil
            var operation: Operation? = nil
            if input.contains("-") { operation = Operation.Remove; label = input.substring(to: input.count - 1) }
            else { operation = Operation.Add(Int(String(input.characterAt(at: input.count - 1)))!); label = input.substring(to: input.count - 2) }
            
            if label == nil || operation == nil {
                fatalError("Error at part 2, failed to parse label and / or operation")
            }
            
            let boxNb = getHash(label: label!)
            
            switch operation {
            case .Remove:
                let focalLenses = boxes[boxNb]
                if focalLenses.isEmpty { continue }
                for (index, lens) in focalLenses.enumerated() {
                    if lens.label == label { boxes[boxNb].remove(at: index); break }
                }
            case let .Add(focal):
                let focalLenses = boxes[boxNb]
                var found = false
                for (index, lens) in focalLenses.enumerated() {
                    if lens.label == label {
                        boxes[boxNb][index].focal = focal
                        found = true
                        break
                    }
                }
                if !found { boxes[boxNb].append(Lens(label: label!, focal: focal)) }
            default: fatalError("unknown operation!")
            }
        }
        
        var ans = 0
        for (index, box) in boxes.enumerated() {
            let nIndex = index + 1
            for (slot, lens) in box.enumerated() {
                ans += nIndex * (slot + 1) * lens.focal
            }
        }
        
        return ans
    }
}
