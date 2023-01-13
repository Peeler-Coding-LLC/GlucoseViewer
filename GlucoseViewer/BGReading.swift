//
//  BGLabel.swift
//  DexcomViewer
//
//  Created by Chase Peeler on 1/11/23.
//

import Foundation

struct BGLabel {
    var glucose: Int = 0
    var direction: BGDirection = BGDirection.Flat
    var delta: Int = 0
    
    var combined : String {
        get {
            return String(glucose)+" "+directionArrow+" "+signedDelta
        }
    }
    
    var signedDelta : String {
        get {
            return (delta < 0 ? "" : "+")+String(delta)
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
}
