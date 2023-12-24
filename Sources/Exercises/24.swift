//
//  24.swift
//  aoc2023
//
//  Created by Antonin on 12/11/2023.
//

import Foundation

class Day24 : Day {
    
    typealias Output01 = Int
    typealias Output02 = Int
    
    internal var tag = "24"
    
    let MIN_INTERSECTION_COOR_TESTS: Int = 7
    let MAX_INTERSECTION_COOR_TESTS: Int = 27
    let MIN_INTERSECTION_COOR_MAIN : Int = 200000000000000
    let MAX_INTERSECTION_COOR_MAIN : Int = 400000000000000
    
    init() {}
    
    struct Trajectory {
        let x: Float
        let y: Float
        let z: Float
        let velocityX: Float
        let velocityY: Float
        let velocityZ: Float
        
        var coef : (Float, Float) {
            let a: Float = velocityY / velocityX
            let b: Float = y - ((x * velocityY) / velocityX)
            return (a, b)
        }
    }
    
    internal func intersection(_ coefA: (Float, Float), _ coefB: (Float, Float)) -> Float? {
        if coefB.0 != coefA.0 { return (coefB.1 - coefA.1) / (coefA.0 - coefB.0) }
        return nil
    }
    
    internal func part01(fromContent: String) throws -> Output01 {
        let lines = fromContent.components(separatedBy: .newlines).filter({ !$0.isEmpty })
        var trajectories: [Trajectory] = []
        for line in lines {
            let components: [String] = line.components(separatedBy: .init(charactersIn: "@"))
                                           .map({ $0.trimmingCharacters(in: .whitespaces) })
            assert(components.count == 2)
            let (rawCoordinates, rawVelocities) = (components[0], components[1])
            let coordinates = rawCoordinates.components(separatedBy: .whitespaces)
                                            .map({ $0.trimmingCharacters(in: .init(charactersIn: ",")) })
                                            .filter({ !$0.isEmpty })
                                            .map({ Float($0)! })
            let velocities = rawVelocities.components(separatedBy: .whitespaces)
                                          .map({ $0.trimmingCharacters(in: .init(charactersIn: ",")) })
                                          .filter({ !$0.isEmpty })
                                          .map({ Float($0)! })
            assert(coordinates.count == 3)
            assert(velocities.count == 3)
            trajectories.append(Trajectory(x: coordinates[0],
                                           y: coordinates[1],
                                           z: coordinates[2],
                                           velocityX: velocities[0],
                                           velocityY: velocities[1],
                                           velocityZ: velocities[2]))
        }
        
        // Change this value to run the unit tests !
        let minValue = MIN_INTERSECTION_COOR_MAIN
        let maxValue = MAX_INTERSECTION_COOR_MAIN
        var ans: Int = 0
        
        for i in 0..<trajectories.count {
            for j in (i+1)..<trajectories.count {
                
                // print("Particles \(trajectories[i]) vs \(trajectories[j])")
                
                let coefA = trajectories[i].coef
                let coefB = trajectories[j].coef
                
                // print("\(coefA) / \(coefB)")
                
                let intersectionX = intersection(coefA, coefB)
                guard let intersectionX = intersectionX else { continue }
                let intersectionY: Float = coefA.0 * intersectionX + coefA.1
                
                
                // return (d - d0) / v
                let tA: Float = (intersectionX - trajectories[i].x) / trajectories[i].velocityX
                let tB: Float = (intersectionX - trajectories[j].x) / trajectories[j].velocityX
                // print("\(tA) / \(tB)")
                
                if tA >= 0.0 && tB >= 0.0 && Float(minValue) <= intersectionX && intersectionX <= Float(maxValue) && Float(minValue) <= intersectionY && intersectionY <= Float(maxValue) {
                    ans += 1
                }
            }
        }
        
        return ans
    }
    
    internal func part02(fromContent: String) throws -> Output02 {
        return 0
    }
}
