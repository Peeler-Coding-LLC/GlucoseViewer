//
//  NightscoutAPITests.swift
//  GlucoseViewerTests
//
//  Created by Chase Peeler on 1/19/23.
//  Copyright © 2023 Peeler Coding, LLC. All rights reserved.
//

import XCTest
@testable import GlucoseViewer

final class NightscoutAPITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testEmptyUrl() async throws {
        
        let data = Data()
        let response = URLResponse()
        
        let session = MockURLSession(mockData: data, mockResponse: response)
        let api = NightscoutAPI(session: session)
        let e = expectation(description: "Empty URL")
        do {
           let _ = try await api.loadData("")
        } catch APIError.EmptyUrl {
            e.fulfill()
        }
        
        wait(for: [e], timeout: 3)
    }
    
    func testInvalidUrl() async throws {
        
        let data = Data()
        let response = URLResponse()
        
        let session = MockURLSession(mockData: data, mockResponse: response)
        let api = NightscoutAPI(session: session)
        let e = expectation(description: "Invalid URL")
        do {
           let _ = try await api.loadData("htp:\\")
        } catch APIError.InvalidUrl(let url) {
            XCTAssertEqual(url,"htp:\\/pebble?count=20")
            e.fulfill()
        }
        
        wait(for: [e], timeout: 3)
    }

    func testFailedRequest() async throws {
        
        let data = Data()
        
        let response = HTTPURLResponse(url: URL(string: "http://www.example.com")!, statusCode: 404, httpVersion: nil, headerFields: nil)
            
        let session = MockURLSession(mockData: data, mockResponse: response!)
        let api = NightscoutAPI(session: session)
        let e = expectation(description: "Failed Request")
        do {
           let _ = try await api.loadData("http://example.com")
        } catch APIError.FailedRequest {
            e.fulfill()
        }
        
        wait(for: [e], timeout: 3)
    }
    
    func testFailedDecode() async throws {
        
        let data = loadJsonData(file: "invalidjson")!
        
        let response = HTTPURLResponse(url: URL(string: "http://www.example.com")!, statusCode: 200, httpVersion: nil, headerFields: nil)
            
        let session = MockURLSession(mockData: data, mockResponse: response!)
        let api = NightscoutAPI(session: session)
        let e = expectation(description: "Failed DEcoding")
        do {
           let _ = try await api.loadData("http://example.com")
        } catch APIError.DecodeError( _) {
            e.fulfill()
        }
        
        wait(for: [e], timeout: 3)
    }
    
    func testSuccess() async throws {
        let data = loadJsonData(file: "validjson")!
        
        let response = HTTPURLResponse(url: URL(string: "http://www.example.com")!, statusCode: 200, httpVersion: nil, headerFields: nil)
            
        let session = MockURLSession(mockData: data, mockResponse: response!)
        let api = NightscoutAPI(session: session)
        let e = expectation(description: "Valid")
        do {
           let r = try await api.loadData("http://example.com")
            XCTAssertEqual(r.status.count,1)
            XCTAssertEqual(r.status[0].now, 1674180158028)
            XCTAssertEqual(r.bgs.count, 3)
            XCTAssertEqual(r.bgs[0].sgv, "121")
            XCTAssertEqual(r.bgs[0].trend, 4)
            XCTAssertEqual(r.bgs[0].direction, "Flat")
            
            e.fulfill()
        } catch {
            
        }
        
        wait(for: [e], timeout: 3)
    }
    
    /// Test for issue [#8](https://github.com/chasepeeler/GlucoseViewer/issues/8)
    func testStringDeltaValue() async throws {
        let data = loadJsonData(file: "stringdelta")!
        
        let response = HTTPURLResponse(url: URL(string: "http://www.example.com")!, statusCode: 200, httpVersion: nil, headerFields: nil)
            
        let session = MockURLSession(mockData: data, mockResponse: response!)
        let api = NightscoutAPI(session: session)
        let e = expectation(description: "Valid")
        do {
           let r = try await api.loadData("http://example.com")
            XCTAssertEqual(r.bgs[0].bgdelta?.string, "-0.8")
            e.fulfill()
        } catch {
            
        }
        
        wait(for: [e], timeout: 3)
    }
    
    private func loadJsonData(file: String) -> Data? {
        //1
        if let jsonFilePath = Bundle(for: type(of:  self)).path(forResource: file, ofType: "json") {
            let jsonFileURL = URL(fileURLWithPath: jsonFilePath)
            //2
            if let jsonData = try? Data(contentsOf: jsonFileURL) {
                return jsonData
            }
        }
        //3
        return nil
    }

}

class MockURLSession : NightscoutUrlSessionProtocol {
    
    var mockData:Data
    var mockResponse:URLResponse
    
    init(mockData: Data, mockResponse: URLResponse) {
        self.mockData = mockData
        self.mockResponse = mockResponse
    }
        
    func data(from url: URL, delegate: URLSessionTaskDelegate?) async throws -> (Data, URLResponse) {
        return (self.mockData,self.mockResponse)
    }
    
    
}


