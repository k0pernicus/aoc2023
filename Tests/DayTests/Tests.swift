//
//  Days.swift
//
//
//  Created by antonin on 01/12/2023.
//

@testable import aoc2023
import XCTest

final class D01Tests: XCTestCase, TestProtocol {
    var day: any Day = Day01()
    typealias Output01 = Int
    typealias Output02 = Int
    func testPart01() { part01(filename: "\(day.tag)_01", expected_result: 142) }
    func testPart02() { part02(filename: "\(day.tag)_02", expected_result: 281) }
}

final class D02Tests: XCTestCase, TestProtocol {
    var day: any Day = Day02()
    typealias Output01 = Int
    typealias Output02 = Int
    func testPart01() { part01(filename: "\(day.tag)", expected_result: 8) }
    func testPart02() { part02(filename: "\(day.tag)", expected_result: 2286) }
}

final class D03Tests: XCTestCase, TestProtocol {
    var day: any Day = Day03()
    typealias Output01 = Int
    typealias Output02 = Int
    func testPart01() { part01(filename: "\(day.tag)", expected_result: 4361) }
    func testPart02() { part02(filename: "\(day.tag)", expected_result: 467835) }
}

final class D04Tests: XCTestCase, TestProtocol {
    var day: any Day = Day04()
    typealias Output01 = Int
    typealias Output02 = Int
    func testPart01() { part01(filename: "\(day.tag)", expected_result: 13) }
    func testPart02() { part02(filename: "\(day.tag)", expected_result: 30) }
}

final class D05Tests: XCTestCase, TestProtocol {
    var day: any Day = Day05()
    typealias Output01 = Int
    typealias Output02 = Int
    func testPart01() { part01(filename: "\(day.tag)", expected_result: 35) }
    func testPart02() { part02(filename: "\(day.tag)", expected_result: 46) }
}

final class D06Tests: XCTestCase, TestProtocol {
    var day: any Day = Day06()
    typealias Output01 = Int
    typealias Output02 = Int
    func testPart01() { part01(filename: "\(day.tag)", expected_result: 288) }
    func testPart02() { part02(filename: "\(day.tag)", expected_result: 71503) }
}

final class D07Tests: XCTestCase, TestProtocol {
    var day: any Day = Day07()
    typealias Output01 = Int
    typealias Output02 = Int
    // Internal test
    func testTag() {
        let t1: Tag = Tag(rawValue: "3A333");
        let t2: Tag = Tag(rawValue: "33733");
        XCTAssert(t1 < t2)
    }
    func testTagPart2() {
        let t1: Tag = Tag(rawValue: "3J333");
        let t2: Tag = Tag(rawValue: "32733");
        XCTAssert(t1 < t2) // J is lower than anything else
    }
    func testPart01() { part01(filename: "\(day.tag)", expected_result: 6440) }
    func testPart02() { part02(filename: "\(day.tag)", expected_result: 5905) }
}

final class D08Tests: XCTestCase, TestProtocol {
    var day: any Day = Day08()
    typealias Output01 = Int
    typealias Output02 = Int
    func testPart0101() { part01(filename: "\(day.tag)_01", expected_result: 2) }
    func testPart0102() { part01(filename: "\(day.tag)_02", expected_result: 6) }
    func testPart02() { part02(filename: "\(day.tag)_03", expected_result: 6) }
}

final class D09Tests: XCTestCase, TestProtocol {
    var day: any Day = Day09()
    typealias Output01 = Int
    typealias Output02 = Int
    func testPart01() { part01(filename: "\(day.tag)", expected_result: 114) }
    func testPart02() { part02(filename: "\(day.tag)", expected_result: 2) }
}

final class D10Tests: XCTestCase, TestProtocol {
    var day: any Day = Day10()
    typealias Output01 = Int
    typealias Output02 = Int
    func testPart0101() { part01(filename: "\(day.tag)_01", expected_result: 4) }
    func testPart0102() { part01(filename: "\(day.tag)_02", expected_result: 8) }
    func testPart0201() { part02(filename: "\(day.tag)_03", expected_result: 4) }
    func testPart0202() { part02(filename: "\(day.tag)_04", expected_result: 8) }
    func testPart0203() { part02(filename: "\(day.tag)_05", expected_result: 10) }
}

final class D11Tests: XCTestCase, TestProtocol {
    var day: any Day = Day11()
    typealias Output01 = Int
    typealias Output02 = Int
    func testPart01() { part01(filename: "\(day.tag)", expected_result: 374) }
    func testPart02() { part02(filename: "\(day.tag)", expected_result: 82000210) }
}

final class D12Tests: XCTestCase, TestProtocol {
    var day: any Day = Day12()
    typealias Output01 = Int
    typealias Output02 = Int
    func testPart01() { part01(filename: "\(day.tag)", expected_result: 21) }
    func testPart02() { part02(filename: "\(day.tag)", expected_result: 525152) }
}

final class D13Tests: XCTestCase, TestProtocol {
    var day: any Day = Day13()
    typealias Output01 = Int
    typealias Output02 = Int
    func testPart01() { part01(filename: "\(day.tag)", expected_result: 405) }
    func testPart02() { part02(filename: "\(day.tag)", expected_result: 400) }
}

final class D14Tests: XCTestCase, TestProtocol {
    var day: any Day = Day14()
    typealias Output01 = Int
    typealias Output02 = Int
    func testTranspose() {
        let initialArray: [[Int]] = [[1,2,3], [4, 5], [6]]
        var rotatedArray: [[Int]] = initialArray
        for _ in 0..<4 {
            rotatedArray = transpose(rotatedArray)
        }
        XCTAssert(initialArray == rotatedArray.map{ $0.filter{ $0 != 0 } })
    }
    func testPart01() { part01(filename: "\(day.tag)", expected_result: 136) }
    func testPart02() { part02(filename: "\(day.tag)", expected_result: 64) }
}

final class D15Tests: XCTestCase, TestProtocol {
    var day: any Day = Day15()
    typealias Output01 = Int
    typealias Output02 = Int
    func testPart0101() { part01(filename: "\(day.tag)_01", expected_result: 52) }
    func testPart0102() { part01(filename: "\(day.tag)_02", expected_result: 1320) }
    func testPart02() { part02(filename: "\(day.tag)_02", expected_result: 145) }
}

final class D16Tests: XCTestCase, TestProtocol {
    var day: any Day = Day16()
    typealias Output01 = Int
    typealias Output02 = Int
    func testPart01() { part01(filename: "\(day.tag)", expected_result: 46) }
    func testPart02() { part02(filename: "\(day.tag)", expected_result: 51) }
}

final class D17Tests: XCTestCase, TestProtocol {
    var day: any Day = Day17()
    typealias Output01 = Int
    typealias Output02 = Int
    func testPart01() { part01(filename: "\(day.tag)", expected_result: 102) }
    func testPart02() { part02(filename: "\(day.tag)", expected_result: 94) }
}

final class D18Tests: XCTestCase, TestProtocol {
    var day: any Day = Day18()
    typealias Output01 = Int
    typealias Output02 = Int
    func testPart01() { part01(filename: "\(day.tag)", expected_result: 62) }
    func testPart02() { part02(filename: "\(day.tag)", expected_result: 952408144115) }
}

final class D19Tests: XCTestCase, TestProtocol {
    var day: any Day = Day19()
    typealias Output01 = Int
    typealias Output02 = Int
    func testPart01() { part01(filename: "\(day.tag)", expected_result: 19114) }
    func testPart02() { part02(filename: "\(day.tag)", expected_result: 167409079868000) }
}

final class D20Tests: XCTestCase, TestProtocol {
    var day: any Day = Day20()
    typealias Output01 = Int
    typealias Output02 = Int
    func testPart0101() { part01(filename: "\(day.tag)_01", expected_result: 32000000) }
    func testPart0102() { part01(filename: "\(day.tag)_02", expected_result: 11687500) }
    func testPart0103() { part01(filename: "\(day.tag)_03", expected_result: 834323022) }
}

final class D21Tests: XCTestCase, TestProtocol {
    var day: any Day = Day21()
    typealias Output01 = Int
    typealias Output02 = Int
    // Need to change 16 here !
    func testPart01() { part01(filename: "\(day.tag)_01", expected_result: 42) }
    // Can't test part 02 here - no additional input :(
}

final class D22Tests: XCTestCase, TestProtocol {
    var day: any Day = Day22()
    typealias Output01 = Int
    typealias Output02 = Int
    func testPart01() { part01(filename: "\(day.tag)", expected_result: 5) }
    func testPart02() { part02(filename: "\(day.tag)", expected_result: 7) }
}
