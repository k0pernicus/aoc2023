//
//  Day01Tests.swift
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
