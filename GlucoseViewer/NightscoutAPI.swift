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

struct APIBgs : Codable {
    var sgv: String
    var trend: Int
    var direction: String
    var datetime: Double
    var bgdelta: Int?
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
