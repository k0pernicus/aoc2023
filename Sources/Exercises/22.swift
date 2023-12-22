//
//  22.swift
//  aoc2023
//
//  Created by Antonin on 12/11/2023.
//

import Foundation

class Day22 : Day {
    
    typealias Output01 = Int
    typealias Output02 = Int
    
    internal var tag = "22"
    
    init() {}
    
    struct BrickRange: Hashable, Comparable {
        var beg: Int
        var end: Int
        internal func contains(index: Int) -> Bool {
            return index >= beg && index <= end
        }
        internal mutating func fall(nb: Int) {
            self.beg -= nb
            self.end -= nb
        }
        static func < (lhs: Day22.BrickRange, rhs: Day22.BrickRange) -> Bool {
            return lhs.beg <= rhs.beg
        }
        internal func asSet() -> Set<Int> {
            return Set<Int>(beg...end)
        }
    }
    
    struct Brick: Hashable {
        let label: String
        let rangeX: BrickRange
        let rangeY: BrickRange
        var rangeZ: BrickRange
    }
    
    internal func part01(fromContent: String) throws -> Output01 {
        let input = fromContent.components(separatedBy: .newlines).filter({ !$0.isEmpty })
        // Process the input
        var bricks: [Brick] = []
        for (index, line) in input.enumerated() {
            let brickCoordinates = line.components(separatedBy: .init(charactersIn: "~"))
            assert(brickCoordinates.count == 2)
            let (left, right): ([Int], [Int]) = (brickCoordinates[0].components(separatedBy: .init(charactersIn: ",")).map({ Int($0)! }),
                                                 brickCoordinates[1].components(separatedBy: .init(charactersIn: ",")).map({ Int($0)! }))
            assert(left.count == 3)
            assert(right.count == 3)
            bricks.append(Brick(label: String(index),
                                rangeX: BrickRange(beg: left[0], end: right[0]),
                                rangeY: BrickRange(beg: left[1], end: right[1]),
                                rangeZ: BrickRange(beg: left[2], end: right[2])))
        }
        // Fall & compute
        bricks = bricks.sorted(by: { $0.rangeZ <= $1.rangeZ })
        var (maxX, maxY) = (0, 0)
        for brick in bricks {
            maxX = max(maxX, brick.rangeX.end)
            maxY = max(maxY, brick.rangeY.end)
        }
        
        var ground: [[(Int, Int)]] = Array.init(repeating: Array.init(repeating: (1, -1), count: maxX + 1), count: maxY + 1)
        var supportedBy: [Set<Int>] = Array.init(repeating: Set<Int>(), count: bricks.count)
        var supports: [Set<Int>] = Array.init(repeating: Set<Int>(), count: bricks.count)
        
        for (brickIndex, brick) in bricks.enumerated() {
            var maxHeight = 0
            for y in brick.rangeY.beg...brick.rangeY.end {
                for x in brick.rangeX.beg...brick.rangeX.end {
                    let currentHeight = ground[y][x].0
                    // Reach the maximum height ?
                    if currentHeight > maxHeight {
                        supportedBy[brickIndex] = Set<Int>()
                        maxHeight = currentHeight
                    }
                    // Touch a new block ?
                    if currentHeight == maxHeight && ground[y][x].1 >= 0 {
                        supportedBy[brickIndex].insert(ground[y][x].1)
                    }
                }
            }
            
            for supporter in supportedBy[brickIndex] {
                supports[supporter].insert(brickIndex)
            }
            
            let brickHeight = brick.rangeZ.end - brick.rangeZ.beg + 1
            for y in brick.rangeY.beg...brick.rangeY.end {
                for x in brick.rangeX.beg...brick.rangeX.end {
                    ground[y][x] = (maxHeight + brickHeight, brickIndex)
                }
            }
            
            bricks[brickIndex].rangeZ.beg = maxHeight
            bricks[brickIndex].rangeZ.end = maxHeight + brickHeight - 1
        }

        var possibleBlocks = Set<Int>(0..<bricks.count)
        for touch in supportedBy {
            if touch.count == 1 {
                possibleBlocks.remove(touch.first!)
            }
        }
        
        return possibleBlocks.count
    }
    
    internal func part02(fromContent: String) throws -> Output02 {
        let input = fromContent.components(separatedBy: .newlines).filter({ !$0.isEmpty })
        // Process the input
        var bricks: [Brick] = []
        for (index, line) in input.enumerated() {
            let brickCoordinates = line.components(separatedBy: .init(charactersIn: "~"))
            assert(brickCoordinates.count == 2)
            let (left, right): ([Int], [Int]) = (brickCoordinates[0].components(separatedBy: .init(charactersIn: ",")).map({ Int($0)! }),
                                                 brickCoordinates[1].components(separatedBy: .init(charactersIn: ",")).map({ Int($0)! }))
            assert(left.count == 3)
            assert(right.count == 3)
            bricks.append(Brick(label: String(index),
                                rangeX: BrickRange(beg: left[0], end: right[0]),
                                rangeY: BrickRange(beg: left[1], end: right[1]),
                                rangeZ: BrickRange(beg: left[2], end: right[2])))
        }
        // Fall & compute
        bricks = bricks.sorted(by: { $0.rangeZ <= $1.rangeZ })
        var (maxX, maxY) = (0, 0)
        for brick in bricks {
            maxX = max(maxX, brick.rangeX.end)
            maxY = max(maxY, brick.rangeY.end)
        }
        
        var ground: [[(Int, Int)]] = Array.init(repeating: Array.init(repeating: (1, -1), count: maxX + 1), count: maxY + 1)
        var supportedBy: [Set<Int>] = Array.init(repeating: Set<Int>(), count: bricks.count)
        var supports: [Set<Int>] = Array.init(repeating: Set<Int>(), count: bricks.count)
        
        for (brickIndex, brick) in bricks.enumerated() {
            var maxHeight = 0
            for y in brick.rangeY.beg...brick.rangeY.end {
                for x in brick.rangeX.beg...brick.rangeX.end {
                    let currentHeight = ground[y][x].0
                    // Reach the maximum height ?
                    if currentHeight > maxHeight {
                        supportedBy[brickIndex] = Set<Int>()
                        maxHeight = currentHeight
                    }
                    // Touch a new block ?
                    if currentHeight == maxHeight && ground[y][x].1 >= 0 {
                        supportedBy[brickIndex].insert(ground[y][x].1)
                    }
                }
            }
            
            for supporter in supportedBy[brickIndex] {
                supports[supporter].insert(brickIndex)
            }
            
            let brickHeight = brick.rangeZ.end - brick.rangeZ.beg + 1
            for y in brick.rangeY.beg...brick.rangeY.end {
                for x in brick.rangeX.beg...brick.rangeX.end {
                    ground[y][x] = (maxHeight + brickHeight, brickIndex)
                }
            }
            
            bricks[brickIndex].rangeZ.beg = maxHeight
            bricks[brickIndex].rangeZ.end = maxHeight + brickHeight - 1
        }
        
        var ans = 0
        for brickIndex in 0..<bricks.count {
            
            // BFS as long as the next brick falls
            var stack = [brickIndex]
            var falling = Set<Int>([brickIndex])
            while !stack.isEmpty {
                // current brick
                let currentBrickIndex = stack.removeFirst()
                // make it falls
                for supported in supports[currentBrickIndex] {
                    if supportedBy[supported].subtracting(falling).count == 0 {
                        falling.insert(supported)
                        stack.append(supported)
                    }
                }
            }
            // How many blocks have fallen?
            ans += falling.count - 1
            
        }
        
        return ans
    }
}
