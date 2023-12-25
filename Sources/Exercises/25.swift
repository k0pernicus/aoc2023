//
//  25.swift
//  aoc2023
//
//  Created by Antonin on 25/12/2023.
//

import Foundation

class Day25 : Day {
    
    typealias Output01 = Int
    typealias Output02 = Int
    
    internal var tag = "25"
    
    init() {}
    
    internal func part01(fromContent: String) throws -> Output01 {
        let graphConnections: [String] = fromContent.components(separatedBy: .newlines).filter({ !$0.isEmpty })
        var nodes: Set<String> = Set<String>()
        var edges: [(String, String)] = []
        for connection in graphConnections {
            let components: [String] = connection.components(separatedBy: .init(charactersIn: ":"))
            assert(components.count == 2)
            let begNode = components[0]
            let endNodes = components[1].components(separatedBy: .whitespaces).map({ $0.trimmingCharacters(in: .whitespaces) }).filter({ !$0.isEmpty })
            nodes.insert(begNode)
            for endNode in endNodes {
                nodes.insert(endNode)
                edges.append((begNode, endNode))
            }
        }
        
        // Usage of Karger's Algorithm
        // https://en.wikipedia.org/wiki/Karger%27s_algorithm
        
        
        while (true) {
            
            var currentEdges = edges
            var currentNodes = nodes
            while currentNodes.count > 2 {
                // Remove random element
                let i = Int.random(in: 0..<currentEdges.count)
                let (nodeStart, nodeEnd) = currentEdges[i]
                
                currentEdges.remove(at: i)
                currentNodes.remove(nodeStart)
                currentNodes.remove(nodeEnd)
                
                // Contract and add the new node
                let contractedEdgeNode = String("\(nodeStart):\(nodeEnd)")
                currentNodes.insert(contractedEdgeNode)
                
                for (index, (startEdge, endEdge)) in currentEdges.enumerated() {
                    if startEdge == nodeStart || startEdge == nodeEnd { currentEdges[index].0 = contractedEdgeNode }
                    if endEdge == nodeStart || endEdge == nodeEnd { currentEdges[index].1 = contractedEdgeNode }
                }
                
                // Remove the loops
                var j = 0
                while j < currentEdges.count {
                    if currentEdges[j].0 == currentEdges[j].1 {
                        currentEdges.remove(at: j)
                    }
                    else { j += 1 }
                }
            }
            
            if currentEdges.count == 3 {
                return currentNodes.map({ $0.components(separatedBy: .init(charactersIn: ":")).count }).reduce(1, { $0 * $1 })
            }
        }
        
        return 0
    }
    
    internal func part02(fromContent content: String) throws -> Output02 {
        return 0
    }
}
