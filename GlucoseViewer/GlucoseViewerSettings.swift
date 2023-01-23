//
//  GlucoseViewerSettings.swift
//  GlucoseViewer
//
//  Created by Chase Peeler on 1/20/23.
//  Copyright © 2023 Peeler Coding, LLC. All rights reserved.
//

import Foundation

/// Holds the settings for the app. Can be stored directly in application storage.
struct GlucoseViewerSettings {
    
    
    
    /// Glucose units. mg/dL or mmol/L
    enum Units:String {
        case mgdL
        case mmolL
    }
    
    /// Whether the graph is displayed using fixed values for the y-axis or
    /// values that adjust based on the highest and lowest values retrieved
    enum AxisStyle:String {
        case fixed
        case dynamic
    }
    
    /// The base url of the nightscout instance
    var url:String = ""
    
    /// An authentication token. Leave blank if none
    var token:String = ""
    
    /// The units that glucose values are meaured in
    var units: Units = .mgdL
    
    /// The style the graph is displayed in
    var axisStyle:AxisStyle = .dynamic
    
    ///  Empty url and token, .mgdL units, and .dynamic axisStyle
    init(){
        self.url = ""
        self.token = ""
        self.units = .mgdL
        self.axisStyle = .dynamic
    }
    
     init(url: String = "", token: String = "", units: GlucoseViewerSettings.Units = .mgdL, axisStyle: GlucoseViewerSettings.AxisStyle = .dynamic) {
        self.url = url
        self.token = token
        self.units = units
        self.axisStyle = axisStyle
    }
    

  
}

extension GlucoseViewerSettings : Codable {
    
    /* Codable */
    
    enum CodingKeys:String,CodingKey {
        case url
        case token
        case units
        case axis
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(url, forKey: .url)
        try container.encode(token, forKey: .token)
        try container.encode(units.rawValue, forKey: .units)
        try container.encode(axisStyle.rawValue,forKey: .axis)
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.url = try String(values.decode(String.self, forKey: .url))
        self.token = try String(values.decode(String.self, forKey: .token))
        self.units = try Units(rawValue: values.decode(String.self, forKey: .units)) ?? .mgdL
        self.axisStyle = try AxisStyle(rawValue: values.decode(String.self, forKey:.axis)) ?? .dynamic
        
    }
    
}

extension GlucoseViewerSettings:RawRepresentable {
    /* RawRepresentable */
    
    init?(rawValue: String) {
        guard let data = rawValue.data(using: .utf8),
              let result = try? JSONDecoder().decode(GlucoseViewerSettings.self, from: data)
        else {
            return nil
        }
        self = result
    }
    
    var rawValue: String {
        guard let data = try? JSONEncoder().encode(self),
              let result = String(data: data, encoding: .utf8)
        else {
            return "[]"
        }
        return result
    }
    
    
}
