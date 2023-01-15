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
    @State private var action: Int? = 1
    
    var body: some View {
        
        let yAxisValues: [Int] = stride(from: bgData.minBG-10, to:bgData.maxBG+20,by: 10).map {$0}
                  VStack {
                    GroupBox ( "Glucose") {
                        Chart (bgData.bgs.reversed()) {
                            LineMark(
                                x: .value("Time", $0.formattedDate),
                                y: .value("Glucose", $0.glucose)
                            ).symbol(.circle)
                        }.chartYAxis{
                            AxisMarks(values: yAxisValues)
                        }.chartYScale(domain: ClosedRange(uncheckedBounds: (lower: yAxisValues.min()!, upper: yAxisValues.max()!))).frame(minWidth: 600)
                        
                    }
                    
                    HStack(alignment: .bottom) {
                        Button("Settings"){
                           print("ugh")
                        }
                        
                        Button("Open Nightscout"){
                            self.openURL(self.baseUrl)
                        }.scaledToFill()
                        Button("Quit"){
                            NSApplication.shared.terminate(nil)
                        }.scaledToFill()
                    }.padding()
                }.frame(maxWidth: .infinity,maxHeight: .infinity).opacity(100)
          
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
    @StateObject static var bgs =
    BGData().add(BGDatum(glucose:138,datetime:1673741177000))
    .add(BGDatum(glucose:141,datetime:1673740877000))
    .add(BGDatum(glucose:145,datetime:1673740577000))
    .add(BGDatum(glucose:149,datetime:1673740277000))
    .add(BGDatum(glucose:151,datetime:1673739977000))
    .add(BGDatum(glucose:153,datetime:1673739677000))
    .add(BGDatum(glucose:157,datetime:1673739377000))
    .add(BGDatum(glucose:163,datetime:1673739076000))
    .add(BGDatum(glucose:168,datetime:1673738777000))
    .add(BGDatum(glucose:171,datetime:1673738477000))
    .add(BGDatum(glucose:172,datetime:1673738177000))
    .add(BGDatum(glucose:167,datetime:1673737876000))
    .add(BGDatum(glucose:161,datetime:1673737577000))
    .add(BGDatum(glucose:157,datetime:1673737276000))
    .add(BGDatum(glucose:158,datetime:1673736977000))
    .add(BGDatum(glucose:158,datetime:1673736676000))
    .add(BGDatum(glucose:156,datetime:1673736377000))
    .add(BGDatum(glucose:150,datetime:1673736077000))
    .add(BGDatum(glucose:145,datetime:1673735777000))
    .add(BGDatum(glucose:138,datetime:1673735476000))

    @State static var baseUrl = ""
    static var previews: some View {
        GlucoseDetailsView(baseUrl: $baseUrl, bgData: bgs)
    }
}


struct BGDatum: Identifiable {
    var id: Date {
        get {
            return datetime
        }
    }
    var glucose: Int
    var datetime: Date
    
    init(glucose:Int,datetime:Date){
        self.glucose = glucose
        self.datetime = datetime
    }
    
    init(glucose: Int, datetime:Int){
        var d = datetime
        if(d > 9999999999){
            d = d/1000
        }
        self.init(glucose: glucose, datetime: Date(timeIntervalSince1970: Double(d)))
    }
        
    var formattedDate:String {
        get {
            let formatter1:DateFormatter = DateFormatter();
            formatter1.dateStyle = DateFormatter.Style.short;
            formatter1.timeStyle = DateFormatter.Style.short;
            return formatter1.string(from: datetime)
        }
    }
}

class BGData :ObservableObject {
    @Published var bgs: [BGDatum]
    
    var minBG: Int {
        get {
            return bgs.min {$0.glucose < $1.glucose}!.glucose
        }
    }
    
    var maxBG: Int {
        get {
            return bgs.max {$0.glucose < $1.glucose}!.glucose
        }
    }
    
    init(){
        self.bgs = []
    }
    
    convenience init(with bgs:[APIBgs]){
        self.init()
        self.replace(with: bgs)
    }
    
    func replace(with bgs:[APIBgs]){
        self.bgs = []
        bgs.forEach(){ bg in
            let g = Int(bg.sgv)!
            let d = Date(timeIntervalSince1970: Double(bg.datetime/1000))
            self.bgs.append(BGDatum(glucose: g, datetime: d))
        }
    }
    
    func add(_ bg: BGDatum) -> BGData{
        self.bgs.append(bg)
        return self
    }
    
    
}
