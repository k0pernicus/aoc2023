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
    
    internal func dijkstra(graph: [Int: [Int]], start: Int, end: Int) -> [Int]? {
        var visited: Set<Int> = Set<Int>()
        var queue  : [Int]    = []
        var parents: [Int: Int] = [:]
        
        queue.append(start)
        while !queue.isEmpty {
            let currentNode = queue.removeFirst()
            if visited.contains(currentNode) { continue }
            visited.insert(currentNode)
            // Did we reached the end ?
            if (currentNode == end) { break }
            for neighbor in graph[currentNode]! {
                if visited.contains(neighbor) { continue }
                parents[neighbor] = currentNode
                queue.append(neighbor)
            }
        }
        
        var path: [Int] = []
        var node: Int = end
        while node != start {
            path.append(node)
            if let childNode = parents[node] { node = childNode }
            else { return nil } // No parent -> no connection
        }
        path.append(start)
        path.reverse()
        return path
    }
    
    internal func countConnnectedNodes(_ graph: [Int: [Int]]) -> Int {
        var visited: Set<Int> = Set<Int>()
        var queue: [Int] = []
        for node in graph.keys { queue.append(node) }
        while !queue.isEmpty {
            let currentNode = queue.removeFirst()
            if visited.contains(currentNode) { continue }
            visited.insert(currentNode)
            for neighbor in graph[currentNode]! { queue.append(neighbor) }
        }
        return visited.count
    }
    
    internal func part01(fromContent: String) throws -> Output01 {
        let graphConnections: [String] = fromContent.components(separatedBy: .newlines).filter({ !$0.isEmpty })
        var connections: [Int: [Int]] = [:]
        var nodeIds: [String: Int] = [:]
        for connection in graphConnections {
            let components: [String] = connection.components(separatedBy: .init(charactersIn: ":"))
            assert(components.count == 2)
            let begNode = components[0]
            let endNodes = components[1].components(separatedBy: .whitespaces).map({ $0.trimmingCharacters(in: .whitespaces) }).filter({ !$0.isEmpty })
            if nodeIds[begNode] == nil { nodeIds[begNode] = nodeIds.count }
            let begNodeId: Int = nodeIds[begNode]!
            for endNode in endNodes {
                if nodeIds[endNode] == nil { nodeIds[endNode] = nodeIds.count }
                let endNodeId: Int = nodeIds[endNode]!
                if var existingNodes = connections[begNodeId] { connections[begNodeId]?.append(endNodeId) } else { connections[begNodeId] = [endNodeId] }
                if var existingNodes = connections[endNodeId] { connections[endNodeId]?.append(begNodeId) } else { connections[endNodeId] = [begNodeId] }
            }
        }
        
        for (currentNode, _) in connections {
            var currectConnections = connections
            for _ in 0..<3 {
                let path = dijkstra(graph: currectConnections, start: 0, end: currentNode)
                print("Found path \(path)")
                for i in 0..<path!.count - 1 {
                    let current = path![i]
                    let next = path![i+1]
                    print("Removing connection between \(current) and \(next)...")
                    // Remove beg
                    var modifiedValuesBeg = currectConnections[current]!
                    let valueIndexBeg: Int = modifiedValuesBeg.firstIndex(of: next)!
                    modifiedValuesBeg.remove(at: valueIndexBeg)
                    currectConnections[current] = modifiedValuesBeg
                    // Remove end
                    var modifiedValueEnd = currectConnections[next]!
                    let valueIndexEnd: Int = modifiedValueEnd.firstIndex(of: current)!
                    modifiedValueEnd.remove(at: valueIndexEnd)
                    currectConnections[next] = modifiedValueEnd
                }
            }
                
            // Is there still a path ?
            if dijkstra(graph: currectConnections, start: 0, end: currentNode) == nil {
                print("Found two groups!")
                let fstGroupNb = countConnnectedNodes(currectConnections)
                let sndGroupNb = currectConnections.count - fstGroupNb
                return fstGroupNb * sndGroupNb
            } else {
                print("Did not found two groups!")
            }
        }
        
        return 0
    }
    
    internal func part02(fromContent content: String) throws -> Output02 {
        return 0
    }
}
