//
//  19.swift
//  aoc2023
//
//  Created by Antonin on 12/11/2023.
//

import Foundation

class Day19 : Day {
    
    typealias Output01 = Int
    typealias Output02 = Int
    
    internal var tag = "19"
    
    init() {}
    
    enum Operation {
        case lowerThan
        case greaterThan
    }
    
    enum Output: Equatable {
        case label(String)
        case rejected
        case accepted
        
        internal func toString() -> String {
            switch self {
            case .accepted : return "A"
            case .rejected : return "R"
            case let .label(label) : return label
            }
        }
    }
    
    enum Rule {
        case condition(partName: String, operation: Operation, comparator: Int, then: Output)
        case alwaysTrue(then: Output)
    }
    
    internal func part01(fromContent: String) throws -> Output01 {
        let lines = fromContent.components(separatedBy: .newlines)
        
        var workflows: [String: [Rule]] = [:]
        var initValues: [[(String, Int)]] = []
        
        for line in lines {
            if line.isEmpty { continue }
            // Input
            if line.characterAt(at: 0) == "{" {
                var cValues: [(String, Int)] = []
                var mline = line
                mline.removeFirst()
                mline.removeLast()
                let values: [String] = mline.components(separatedBy: .init(charactersIn: ","))
                for var value in values {
                    let name: String = String(value.removeFirst()); value.removeFirst()
                    cValues.append((name, Int(value)!))
                }
                initValues.append(cValues)
            } else {
                let components: [String] = line.components(separatedBy: .init(charactersIn: "{"))
                assert(components.count == 2)
                var (name, rule): (String, String) = (components[0], components[1])
                rule.removeLast()
                let ruleComponents: [String] = rule.components(separatedBy: .init(charactersIn: ","))
                
                for var component in ruleComponents {
                    if component.contains(":") {
                        let partName: Character = component.removeFirst()
                        let operation: Character = component.removeFirst()
                        let conditionComponents: [String] = component.components(separatedBy: .init(charactersIn: ":"))
                        assert(conditionComponents.count == 2)
                        let (comparator, then): (String, String) = (conditionComponents[0], conditionComponents[1])
                        if let _ = workflows[name] {} else { workflows[name] = [] }
                        workflows[name]!.append(Rule.condition(partName: String(partName),
                                                               operation: operation == ">" ? .greaterThan : .lowerThan,
                                                               comparator: Int(comparator)!,
                                                               then: then == "R" ? .rejected : then == "A" ? .accepted : .label(then)))
                    } else {
                        if let _ = workflows[name] {} else { workflows[name] = [] }
                        workflows[name]!.append(Rule.alwaysTrue(then: component == "R" ? .rejected : component == "A" ? .accepted : .label(component)))
                    }
                }
                
            }
        }
        
        var ans: Int = 0
        
        for toCheck in initValues {
            var workflowToExecute: [Rule] = workflows["in"]!
            var result: Output? = nil
            while !workflowToExecute.isEmpty {
                let cWorkflow = workflowToExecute.removeFirst()
                if result != nil { break }
                switch cWorkflow {
                case let .alwaysTrue(then: then):
                    switch then {
                    case .accepted, .rejected: result = then; continue
                    case let .label(nextRule): workflowToExecute = workflows[nextRule]!
                    }
                case let .condition(partName: partName, operation: operation, comparator: comparator, then: then):
                    var part: (String, Int) = ("", -1)
                    for check in toCheck { if check.0 == partName { part = check; break } }
                    assert(part.1 != -1)
                    
                    switch operation {
                    case .greaterThan:
                        if part.1 > comparator {
                            switch then {
                            case .accepted, .rejected: result = then; continue
                            case let .label(nextRule): workflowToExecute = workflows[nextRule]!
                            }
                        }
                    case .lowerThan:
                        if part.1 < comparator {
                            switch then {
                            case .accepted, .rejected: result = then; continue
                            case let .label(nextRule): workflowToExecute = workflows[nextRule]!
                            }
                        }
                    }
                }
            }
            if result == nil { fatalError("result can't be nil!") }
            switch result! {
            case .accepted: ans += toCheck.map({ $0.1 }).sum()
            default: break
            }
        }
        
        return ans
    }
    
    internal class ValidRange {
        let name: String
        var ranges: [String: ClosedRange<Int>]

        init(name: String, ranges: [String : ClosedRange<Int>]) {
            self.name = name
            self.ranges = ranges
        }

        var matches: Int {
            ranges.values.map { $0.upperBound - $0.lowerBound + 1 }.reduce(1, *)
        }
    }
    
    internal func solveWorkflow(workflows: [String: [Rule]], _ range: ValidRange) -> [ValidRange] {
        guard let rules: [Rule] = workflows[range.name] else { return [] }
        
        var remainingRanges = range.ranges
        var result : [ValidRange] = []
        for rule in rules {
            switch rule {
            case let .alwaysTrue(then: then):
                result.append(ValidRange(name: then.toString(), ranges: remainingRanges))
            case let .condition(partName: prop, operation: ope, comparator: comp, then: then):
                let range = remainingRanges[prop]!
                let newRange: ValidRange = ValidRange(name: then.toString(), ranges: remainingRanges)
                switch ope {
                case .lowerThan:
                    newRange.ranges[prop] = range.lowerBound ... comp - 1
                    remainingRanges[prop] = comp ... range.upperBound
                case .greaterThan:
                    newRange.ranges[prop] = comp + 1 ... range.upperBound
                    remainingRanges[prop] = range.lowerBound ... comp
                }
                result.append(newRange)
            }
        }
        return result
    }
    
    internal func part02(fromContent: String) throws -> Output02 {
        let lines = fromContent.components(separatedBy: .newlines)
        
        var workflows: [String: [Rule]] = [:]
        
        for line in lines {
            if line.isEmpty { continue }
            // Input
            if line.characterAt(at: 0) == "{" { continue }
            else {
                let components: [String] = line.components(separatedBy: .init(charactersIn: "{"))
                assert(components.count == 2)
                var (name, rule): (String, String) = (components[0], components[1])
                rule.removeLast()
                let ruleComponents: [String] = rule.components(separatedBy: .init(charactersIn: ","))
                
                for var component in ruleComponents {
                    if component.contains(":") {
                        let partName: Character = component.removeFirst()
                        let operation: Character = component.removeFirst()
                        let conditionComponents: [String] = component.components(separatedBy: .init(charactersIn: ":"))
                        assert(conditionComponents.count == 2)
                        let (comparator, then): (String, String) = (conditionComponents[0], conditionComponents[1])
                        if let _ = workflows[name] {} else { workflows[name] = [] }
                        workflows[name]!.append(Rule.condition(partName: String(partName),
                                                               operation: operation == ">" ? .greaterThan : .lowerThan,
                                                               comparator: Int(comparator)!,
                                                               then: then == "R" ? .rejected : then == "A" ? .accepted : .label(then)))
                    } else {
                        if let _ = workflows[name] {} else { workflows[name] = [] }
                        workflows[name]!.append(Rule.alwaysTrue(then: component == "R" ? .rejected : component == "A" ? .accepted : .label(component)))
                    }
                }
                
            }
        }
        
        let root = ValidRange(name: "in", ranges: [
            "x": 1...4000,
            "m": 1...4000,
            "a": 1...4000,
            "s": 1...4000
        ])

        var queue = [root]
        var accepted = [ValidRange]()
        while let range = queue.popLast() {
            let splits = solveWorkflow(workflows: workflows, range)
            accepted.append(contentsOf: splits.filter { $0.name == "A" }) // Only take the Accepted
            queue.append(contentsOf: splits)
        }

        return accepted.map { $0.matches }.reduce(0, +)
    }
}
