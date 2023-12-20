//
//  20.swift
//  aoc2023
//
//  Created by Antonin on 12/11/2023.
//

import Foundation

class Day20 : Day {
    
    typealias Output01 = Int
    typealias Output02 = Int
    
    internal var tag = "20"
    
    init() {}
    
    enum Pulse {
        case low
        case high
    }
    
    enum Module {
        case flipflop(label: String, on: Bool = false) // false -> off, true -> on
        case conjunction(label: String)
        case broadcaster(label: String)
        
        internal mutating func propagate(pulse: Pulse,
                                         conjunctionMapping: [String: [String]],
                                         states: [Module],
                                         pulsePerModule: [String: [String: Pulse]]) -> Pulse? {
            switch self {
            case .broadcaster(_): return pulse // return the same pulse
            case let .flipflop(label: _, on: on):
                if pulse == .high { return nil }
                self = .flipflop(label: label, on: !on)
                if on { return .low } else { return .high }
            case let .conjunction(label: label):
                for module in conjunctionMapping[label]! {
                    if pulsePerModule[label]![module] == .low { return .high }
                }
                return .low
            }
        }
        
        internal mutating func flip(with pulse: Pulse) {
            if pulse == .high { return }
            switch self {
            case let .flipflop(label: label, on: on): self = .flipflop(label: label, on: !on)
            default: break
            }
        }
        
        internal var label: String { 
            switch self {
            case let .broadcaster(label: label) : return label
            case let .conjunction(label: label) : return label
            case let .flipflop(label: label, on: _) : return label
            }
        }
    }
    
    internal func part01(fromContent: String) throws -> Output01 {
        var circuit: [String: [String]] = [:]
        var states : [Module] = []
        var conjunctionMapping : [String: [String]] = [:]
        var pulsePerModule: [String: [String: Pulse]] = [:]
        
        let lines = fromContent.components(separatedBy: .newlines).filter({ !$0.isEmpty })
        for line in lines {
            let components: [String] = line.components(separatedBy: " -> ")
            assert(components.count == 2)
            var (inModule, outModules) = (components[0], components[1])
            var sModule: Module
            switch inModule.first {
            case "%": inModule.removeFirst(); sModule = .flipflop(label: inModule, on: false);
            case "&": inModule.removeFirst(); sModule = .conjunction(label: inModule)
            case nil: fatalError("found inModule \(inModule), which can't happen")
            default : sModule = .broadcaster(label: inModule)
            }
            let modules: [String] = outModules.components(separatedBy: .init(charactersIn: ",")).map({ $0.trimmingCharacters(in: .whitespaces) })
            circuit[inModule] = modules
            states.append(sModule)
        }
        
        // Now, do the conjunction mapping
        var toMap : Set<String> = Set<String>()
        for module in states {
            switch module {
            case let .conjunction(label: label): toMap.insert(label)
            default: continue
            }
        }
        for circuitInput in circuit.keys {
            let circuitDestination: Set<String> = Set<String>(circuit[circuitInput]!).intersection(toMap)
            if circuitDestination.isEmpty { continue }
            for dest in circuitDestination {
                if let _ = conjunctionMapping[dest] { conjunctionMapping[dest]!.append(circuitInput) }
                else { conjunctionMapping[dest] = [circuitInput] }
            }
        }
        for (key, values) in conjunctionMapping {
            pulsePerModule[key] = [:]
            for value in values { pulsePerModule[key]![value] = .low }
        }
        
        var countPulses: [Pulse: Int] = [.low: 0, .high: 0]
        for _ in 0..<1000 {
            // Propagate - always begin with broadcaster
            var propagationValues: [(String, Pulse)] = [("broadcaster", .low)]
            // print("button -low-> broadcaster")
            while !propagationValues.isEmpty {
                let cValue: (String, Pulse) = propagationValues.removeFirst()
                let (moduleName, pulse) = cValue
                countPulses[pulse]! += 1
                for (index, var module) in states.enumerated() {
                    if module.label == moduleName {
                        let newPulse = module.propagate(pulse: pulse, 
                                                        conjunctionMapping: conjunctionMapping,
                                                        states: states,
                                                        pulsePerModule: pulsePerModule)
                        states[index] = module
                        if newPulse == nil { continue }
                        for dest in circuit[moduleName]! {
                            if let _ = pulsePerModule[dest] { pulsePerModule[dest]![moduleName] = newPulse }
                            propagationValues.append((dest, newPulse!))
                        }
                        break
                    }
                }
            }
            
            // print("\(countPulses)")
        }
        
        return countPulses[.high]! * countPulses[.low]!
    }
    
    internal func part02(fromContent: String) throws -> Output02 {
        var circuit: [String: [String]] = [:]
        var states : [Module] = []
        var conjunctionMapping : [String: [String]] = [:]
        var pulsePerModule: [String: [String: Pulse]] = [:]
        
        let lines = fromContent.components(separatedBy: .newlines).filter({ !$0.isEmpty })
        for line in lines {
            let components: [String] = line.components(separatedBy: " -> ")
            assert(components.count == 2)
            var (inModule, outModules) = (components[0], components[1])
            var sModule: Module
            switch inModule.first {
            case "%": inModule.removeFirst(); sModule = .flipflop(label: inModule, on: false);
            case "&": inModule.removeFirst(); sModule = .conjunction(label: inModule)
            case nil: fatalError("found inModule \(inModule), which can't happen")
            default : sModule = .broadcaster(label: inModule)
            }
            let modules: [String] = outModules.components(separatedBy: .init(charactersIn: ",")).map({ $0.trimmingCharacters(in: .whitespaces) })
            circuit[inModule] = modules
            states.append(sModule)
        }
        
        // Now, do the conjunction mapping
        var toMap : Set<String> = Set<String>()
        var rxPredecessors: [String: Int] = [:]
        for module in states {
            switch module {
            case let .conjunction(label: label): toMap.insert(label)
            default: continue
            }
        }
        for circuitInput in circuit.keys {
            let circuitDestination: Set<String> = Set<String>(circuit[circuitInput]!).intersection(toMap)
            if circuitDestination.isEmpty { continue }
            for dest in circuitDestination {
                if let _ = conjunctionMapping[dest] { conjunctionMapping[dest]!.append(circuitInput) }
                else { conjunctionMapping[dest] = [circuitInput] }
            }
        }
        for (key, values) in conjunctionMapping {
            pulsePerModule[key] = [:]
            for value in values { pulsePerModule[key]![value] = .low }
        }
        
        for value in pulsePerModule["rs"]! {
            rxPredecessors[value.key] = 0
        }
        
        var minNbOfButtonsClicked = 0
        
        while true {
            if rxPredecessors.values.allSatisfy({ $0 > 0 }) { break }
            minNbOfButtonsClicked += 1
            // Propagate - always begin with broadcaster
            var propagationValues: [(String, Pulse)] = [("broadcaster", .low)]
            // print("button -low-> broadcaster")
            while !propagationValues.isEmpty {
                let cValue: (String, Pulse) = propagationValues.removeFirst()
                let (moduleName, pulse) = cValue
                
                if (rxPredecessors[moduleName] != nil) && pulse == .low {
                    rxPredecessors[moduleName] = minNbOfButtonsClicked
                }
                
                for (index, var module) in states.enumerated() {
                    if module.label == moduleName {
                        let newPulse = module.propagate(pulse: pulse,
                                                        conjunctionMapping: conjunctionMapping,
                                                        states: states,
                                                        pulsePerModule: pulsePerModule)
                        states[index] = module
                        if newPulse == nil { continue }
                        for dest in circuit[moduleName]! {
                            if let _ = pulsePerModule[dest] { pulsePerModule[dest]![moduleName] = newPulse }
                            propagationValues.append((dest, newPulse!))
                        }
                        break
                    }
                }
            }
        }
        
        let values: [Int] = rxPredecessors.values.map { $0 }
        return lcm(for: values)
    }
}
