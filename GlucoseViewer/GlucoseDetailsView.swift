//
//  GlucoseDetailsView.swift
//  GlucoseViewer
//
//  Created by Chase Peeler on 1/14/23.
//  Copyright © 2023 Peeler Coding, LLC. All rights reserved.
//

import SwiftUI
import Charts

struct AxisValues {
    var values: [Double]
    
    init(with values: BGData, using settings: GlucoseViewerSettings){
        self.values = []
        switch settings.axisStyle {
        case .fixed:
            switch settings.units {
            case .mgdL:
                self.values = stride(from: 50, to:300,by: 25).map {Double($0)}
            case .mmolL:
                self.values = stride(from: 2.8, to:16.6,by: 0.60).map {$0}
            }
        case .dynamic:
            switch settings.units {
            case .mgdL:
                self.values = stride(from: values.minBG.int-10, to:values.maxBG.int+20,by: 10).map {Double($0)}
            case .mmolL:
                self.values = stride(from: values.minBG.double-1.0, to:values.maxBG.double+1.5,by: 0.5).map {$0}
            }
        }
        
        self.values.sort()
        
        
    }
    
}

struct GlucoseDetailsView: View {
    @Environment(\.openURL) private  var opener
    //    @Binding var baseUrl: String
    //    @Binding var token: String
    @Binding var settings:GlucoseViewerSettings
    @ObservedObject var bgData: BGData;
    @State private var action: Int? = 1
    @State private var showModal = false
    var body: some View {
        
        
        VStack {
            if(bgData.hasData){
                let yAxisValues = AxisValues(with: bgData, using: settings)
                GroupBox ( "Glucose") {
                    
                    Chart (bgData.bgs.reversed()) {
                        LineMark(
                            x: .value("Time", $0.formattedDate),
                            y: .value("Glucose", $0.glucose.double)
                        ).symbol(.circle).alignsMarkStylesWithPlotArea()
                    }.chartYAxis{
                        AxisMarks(values: yAxisValues.values)
                    }.chartYScale(domain: ClosedRange(uncheckedBounds: (
                        lower: yAxisValues.values.min()!,
                        upper: yAxisValues.values.max()!)))
                    .frame(minWidth: 700)
                    
                    
                    
                }
            }
            HStack(alignment: .bottom) {
                Button("Settings"){
                    showModal = true
                }
                
                Button("Open Nightscout"){
                    self.openURL(self.settings.url)
                }.scaledToFill()
                Button("Quit"){
                    NSApplication.shared.terminate(nil)
                }.scaledToFill()
            }.padding()
        }.frame(maxWidth: .infinity,maxHeight: .infinity).opacity(100)
            .sheet(isPresented: $showModal,onDismiss:{
                print(settings.url)
            }
            ){
                SettingsView(settings: $settings)
            }.opacity(0.99)
        
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
    //    BGData().add(BGDatum(glucose:4.0,datetime:1673741177000))
    //        .add(BGDatum(glucose:4.5,datetime:1673740877000))
    //        .add(BGDatum(glucose:4.6,datetime:1673740577000))
    //        .add(BGDatum(glucose:4.7,datetime:1673740277000))
    //        .add(BGDatum(glucose:4.1,datetime:1673739977000))
    //        .add(BGDatum(glucose:4.0,datetime:1673739677000))
    //        .add(BGDatum(glucose:4.0,datetime:1673739377000))
    //        .add(BGDatum(glucose:4.2,datetime:1673739076000))
    //        .add(BGDatum(glucose:4.5,datetime:1673738777000))
    //        .add(BGDatum(glucose:4.0,datetime:1673738477000))
    //        .add(BGDatum(glucose:4.5,datetime:1673738177000))
    //        .add(BGDatum(glucose:4.5,datetime:1673737876000))
    //        .add(BGDatum(glucose:4.6,datetime:1673737577000))
    //        .add(BGDatum(glucose:5.1,datetime:1673737276000))
    //        .add(BGDatum(glucose:4.5,datetime:1673736977000))
    //        .add(BGDatum(glucose:5.6,datetime:1673736676000))
    //        .add(BGDatum(glucose:4.7,datetime:1673736377000))
    //        .add(BGDatum(glucose:6.9,datetime:1673736077000))
    //        .add(BGDatum(glucose:4.5,datetime:1673735777000))
    //        .add(BGDatum(glucose:4.5,datetime:1673735476000))
    //
    @State static var settings = GlucoseViewerSettings(units: .mgdL,axisStyle: .dynamic)
    static var previews: some View {
        GlucoseDetailsView(settings:$settings, bgData: bgs)
    }
}


struct BGDatum: Identifiable {
    var id: Date {
        get {
            return datetime
        }
    }
    var glucose: StringableNumber
    var datetime: Date
    
    init(glucose:StringableNumber,datetime:Date){
        self.glucose = glucose
        self.datetime = datetime
    }
    
    init(glucose: StringableNumber, datetime:Double){
        var d = datetime
        
        if(d > 9999999999.0){
            d = d/1000.0
        }
        self.init(glucose: glucose, datetime: Date(timeIntervalSince1970: d))
    }
    
    var formattedDate:String {
        get {
            let formatter1:DateFormatter = DateFormatter();
            formatter1.pmSymbol = ""
            formatter1.amSymbol = ""
            formatter1.dateStyle = .none
            formatter1.timeStyle = .short
            return formatter1.string(from: datetime)
        }
    }
}

class BGData :ObservableObject {
    @Published var bgs: [BGDatum]
    var hasData:Bool = false
    
    var minBG: StringableNumber {
        get {
            return bgs.min {$0.glucose < $1.glucose}!.glucose
        }
    }
    
    var maxBG: StringableNumber {
        get {
            return bgs.max {$0.glucose < $1.glucose}!.glucose
        }
    }
    
    init(){
        self.bgs = []
        self.hasData = false
    }
    
    convenience init(with bgs:[APIBgs]){
        self.init()
        self.replace(with: bgs)
    }
    
    func replace(with bgs:[APIBgs]){
        self.bgs = []
        bgs.forEach(){ bg in
            let g = bg.sgv
            var d = bg.datetime
            if(d > 9999999999.0){
                d = d/1000.0
            }
            self.bgs.append(BGDatum(glucose: g, datetime: Date(timeIntervalSince1970: d)))
        }
        self.hasData = !bgs.isEmpty
    }
    
    func add(_ bg: BGDatum) -> BGData{
        self.bgs.append(bg)
        self.hasData = true
        return self
    }
    
    
}
