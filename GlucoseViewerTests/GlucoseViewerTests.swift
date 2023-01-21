//
//  GlucoseViewerTests.swift
//  GlucoseViewerTests
//
//  Created by Chase Peeler on 1/18/23.
//  Copyright © 2023 Peeler Coding, LLC. All rights reserved.
//

import XCTest
@testable import GlucoseViewer

final class GlucoseViewerTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
        
        let bgl = BGLabel(glucose: 100, direction: BGDirection.Flat, delta: -2, status: BGLabel.Status.Ok)
        let arrow = bgl.directionArrow
        XCTAssertEqual(arrow, "→")
        
        
    }

    

}
