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
        
        var ranges = [
            Range<Int>(1...4000), // x
            Range<Int>(1...4000), // m
            Range<Int>(1...4000), // a
            Range<Int>(1...4000)  // s
        ]
        
        var workflowsToCheck: Set<String> = []
        var visitedWorkflows: Set<String> = []
        
        // TODO
        
        for (name, rules) in workflows {
            for rule in rules {
                switch rule {
                case let .alwaysTrue(then: then): if then == .accepted { workflowsToCheck.insert(name) }
                case let .condition(partName: _, operation: _, comparator: _, then: then): if then == .accepted { workflowsToCheck.insert(name) }
                }
            }
        }
        
        while !workflowsToCheck.isEmpty {
            let workflow = workflowsToCheck.removeFirst()
            if visitedWorkflows.contains(workflow) { continue }
        }
        
        // Now, begin with ranges and add check on values to retrieve the other rules
        
        var ans: Int = 0
        return ans
    }
}
