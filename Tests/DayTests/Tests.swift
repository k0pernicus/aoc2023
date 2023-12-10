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
