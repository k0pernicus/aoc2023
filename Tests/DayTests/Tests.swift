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
