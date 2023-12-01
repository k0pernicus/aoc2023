//
//  Utils.swift
//
//
//  Created by antonin on 01/12/2023.
//

@testable import aoc2023
import Foundation
import XCTest

protocol TestProtocol {
    /// The day to run
    var day : any Day { get set }
    /// Output type for the part 01
    associatedtype Output01: Equatable
    /// Output type for the part 02
    associatedtype Output02: Equatable
    /// Calls check for part 01
    func part01(filename: String, expected_result: Output01)
    /// Calls check for part 02
    func part02(filename: String, expected_result: Output02)
}

extension TestProtocol {
    func part01(filename: String, expected_result: Output01) {
        guard let content = TestUtils.openTestFile(filename: filename) else {
            XCTFail("cannot open file \(filename)")
            return
        }
        // Compute the part 01
        do {
            let part01_result = try day.part01(fromContent: content)
            XCTAssert(part01_result as! Output01 == expected_result, "expected \(expected_result) but got \(part01_result)")
        }
        catch {
            XCTFail("Cannot compute part01")
        }
    }
    
    func part02(filename: String, expected_result: Output02) {
        guard let content = TestUtils.openTestFile(filename: filename) else {
            XCTFail("cannot open file \(filename)")
            return
        }
        // Compute the part 02
        do {
            let part02_result = try day.part02(fromContent: content)
            XCTAssert(part02_result as! Output02 == expected_result, "expected \(expected_result) but got \(part02_result)")
        }
        catch {
            XCTFail("Cannot compute part02")
        }
    }
}

/// A set of functions to help solving tests
struct TestUtils {
    /// Allows to open a file in the Tests bundle, in order to open and read the content
    /// Returns the content of the raw file as a String, or nil if something goes wrong
    static func openTestFile(filename: String, filetype: String = "txt") -> String? {
        let testFileURL = NSURL.fileURL(withPath: Bundle.module.path(forResource: filename, ofType: filetype)!)
        do {
            return try String(contentsOf: testFileURL)
        } catch {
            return nil
        }
    }
}
