//
//  NightscoutAPI.swift
//  GlucoseViewer
//
//  Created by Chase Peeler on 1/19/23.
//  Copyright © 2023 Peeler Coding, LLC. All rights reserved.
//

import Foundation
import SwiftUI



struct APIStatus : Codable {
    var now: Double
}

struct StringableNumber: Codable,ExpressibleByFloatLiteral,ExpressibleByIntegerLiteral,ExpressibleByStringLiteral,Comparable {
    
    static func < (lhs: StringableNumber, rhs: StringableNumber) -> Bool {
        return lhs.double < rhs.double
    }
    
    var string: String
    var int: Int
    var double: Double
    
    init(floatLiteral value: Double){
        self.string = String(value)
        self.int = Int(value)
        self.double = value
    }
    
    init(integerLiteral value: Int){
        self.string = String(value)
        self.int = value
        self.double = Double(value)
    }
   
    init(stringLiteral value: String){
        self.string = value
        self.int = Int(value) ?? 0
        self.double = Double(value) ?? 0.0
    }
    
    // Where we determine what type the value is
    init(from decoder: Decoder) throws {
        let container =  try decoder.singleValueContainer()
        self.double = 0.0
        self.int = 0
        self.string = "0"
        
        if let string = try? container.decode(String.self) {
            if let d =  Double(string) {
                self.double = d
                self.int = Int(d)
                self.string = string
            }
        } else if let int = try? container.decode(Int.self){
            self.int = int
            self.double = Double(int)
            self.string = String(int)
        } else if let double = try? container.decode(Double.self){
            self.double = double
            self.int = Int(double)
            self.string = String(double)
        }
    }

    // We need to go back to a dynamic type, so based on the data we have stored, encode to the proper type
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(self.double)
    }
}

struct APIBgs : Codable {
    var sgv: StringableNumber
    var trend: Int
    var direction: String
    var datetime: Double
    var bgdelta: StringableNumber?
}


struct APIData : Codable {
    var status: [APIStatus]
    var bgs: [APIBgs]
}

enum APIError: Error {
    case EmptyUrl
    case InvalidUrl(url:String)
    case FailedRequest
    case DecodeError(error:Error)
}


struct NightscoutAPI{
    private let session: NightscoutUrlSessionProtocol
    
    init(session: NightscoutUrlSessionProtocol = URLSession.shared) {
        self.session = session
    }
    
    func loadData(_ baseUrl:String,token: String = "") async throws -> APIData {
        
        if(baseUrl.isEmpty){
            throw APIError.EmptyUrl
        }
        
        var urlString = baseUrl
        
        if(urlString.last != "/"){
            urlString += "/"
        }
        
        urlString += "pebble?count=20"
        if(!token.isEmpty){
            urlString += "&token="+token
        }
        
        guard let url = URL(string: urlString) else {
            throw APIError.InvalidUrl(url: urlString)
        }
                
        let (data,response) = try await session.data(from: url,delegate: nil)
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw APIError.FailedRequest
        }
        
        do {
            let r: APIData = try JSONDecoder().decode(APIData.self, from: data)
            return r
        } catch {
            throw APIError.DecodeError(error: error)
        }
        
                
    }
    
}

protocol NightscoutUrlSessionProtocol {
    func data(from url: URL, delegate: URLSessionTaskDelegate?) async throws -> (Data, URLResponse)
}

extension URLSession : NightscoutUrlSessionProtocol {}
