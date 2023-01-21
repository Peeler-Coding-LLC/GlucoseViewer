//
//  BGLabel.swift
//  DexcomViewer
//
//  Created by Chase Peeler on 1/11/23.
//

import Foundation

struct BGLabel {
    var glucose: StringableNumber = 0.0
    var direction: BGDirection = BGDirection.Flat
    var delta: StringableNumber = 0.0
    var status : Status = .Ok
    var hasError: Bool {
        get {
            return self.status != .Ok
        }
    }
    
    var combined : String {
        get {
            return glucose.string+" "+directionArrow+" "+signedDelta
        }
    }
    
    var signedDelta : String {
        get {
            return (delta.double < 0.0 ? "" : "+")+delta.string
        }
    }
    
    var directionArrow : String {
        get {
            switch direction {
            case .Flat:
                return "→"
            case .DoubleDown:
                return "↓↓"
            case .DoubleUp:
                return "↑↑"
            case .SingleUp:
                return "↑"
            case .SingleDown:
                return "↓"
            case .FortyFiveUp:
                return "↗"
            case .FortyFiveDown:
                return "↘"
            }
        }
    }
    
    enum Status {
        case NoUrl
        case Error
        case Ok
    }
    
}
