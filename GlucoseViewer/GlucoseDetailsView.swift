//
//  GlucoseDetailsView.swift
//  GlucoseViewer
//
//  Created by Chase Peeler on 1/14/23.
//  Copyright © 2023 Peeler Coding, LLC. All rights reserved.
//

import SwiftUI
import Charts

struct GlucoseDetailsView: View {
    @Environment(\.openURL) private  var opener
    @Binding var baseUrl: String
    @ObservedObject var bgData: BGData;
    var body: some View {
        
        var yAxisValues: [Int] = stride(from: bgData.minBG-10, to:bgData.maxBG+20,by: 10).map {$0}
        
        VStack {
            GroupBox ( "Glucose") {
                Chart (bgData.bgs.reversed()) {
                    let date = Date(timeIntervalSince1970: Double($0.datetime/1000))
                    
                    LineMark(
                        x: .value("Time", $0.formattedDate),
                        y: .value("Glucose", $0.numericBG)
                    )
                }.chartYAxis{
                    AxisMarks(values: yAxisValues)
                }.chartYScale(domain: ClosedRange(uncheckedBounds: (lower: yAxisValues.min()!, upper: yAxisValues.max()!)))
                    
            }
            
            HStack(alignment: .bottom) {
                Button("Settings") {
                    self.openURL("glucoseviewer://Settings")
                }.scaledToFill()
                // Spacer().frame(height: 0)
                Button("Open Nightscout"){
                    self.openURL(self.baseUrl)
                }.scaledToFill()
                // Spacer().frame(height: 0)
                Button("Quit"){
                    NSApplication.shared.terminate(nil)
                }.scaledToFill()
            }.padding()
        }.frame(maxWidth: .infinity,maxHeight: .infinity)
    }
    
        func openURL(_ url:String){
            if let u = URL(string: url) {
                self.openURL(u)
            }
            
        }
        
        func openURL(_ url:URL){
            opener(url)
        }
   
}

struct GlucoseDetailsView_Previews: PreviewProvider {
    @StateObject static var bgs = BGData(with:[
        APIBgs(sgv:"108",trend:4,direction:"Flat",datetime:1673725577000,bgdelta:-2),
        APIBgs(sgv:"100",trend:4,direction:"Flat",datetime:1673725276000),
        APIBgs(sgv:"112",trend:4,direction:"Flat",datetime:1673724976000)
    ])
    @State static var baseUrl = ""
    static var previews: some View {
        GlucoseDetailsView(baseUrl: $baseUrl, bgData: bgs)
    }
}


struct BGDatum: Identifiable,BGS {
    var id:Int {
        get {
            return datetime
        }
    }
    var sgv: String
    var trend: Int
    var direction: String
    var datetime: Int
    var bgdelta: Int? = 0
    
    var numericBG: Int {
        if let bg = Int(sgv) {
            return bg
        } else {
            return 0
        }
    }
    
    var formattedDate:String {
        get {
            let formatter1:DateFormatter = DateFormatter();
            formatter1.dateStyle = DateFormatter.Style.short;
            formatter1.timeStyle = DateFormatter.Style.short;
            let d = Date(timeIntervalSince1970: Double(datetime/1000))
            return formatter1.string(from: d)
        }
    }
}

class BGData :ObservableObject {
    @Published var bgs: [BGDatum]
    
    var minBG: Int {
        get {
            return bgs.min {$0.numericBG < $1.numericBG}!.numericBG
        }
    }
    
    var maxBG: Int {
        get {
            return bgs.max {$0.numericBG < $1.numericBG}!.numericBG
        }
    }
    
    init(){
        self.bgs = []
    }
    
    convenience init(with bgs:[BGS]){
        self.init()
        self.replace(with: bgs)
    }
    
    func replace(with bgs:[BGS]){
        self.bgs = []
        bgs.forEach(){ bg in
            self.bgs.append(BGDatum(sgv: bg.sgv, trend: bg.trend, direction: bg.direction, datetime: bg.datetime, bgdelta: bg.bgdelta))
        }
    }
    
    
}
