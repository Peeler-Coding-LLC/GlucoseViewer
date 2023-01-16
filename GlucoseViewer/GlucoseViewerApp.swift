//
//  DexcomViewerApp.swift
//  DexcomViewer
//
//  Created by Chase Peeler on 1/10/23.
//

import SwiftUI

@main
struct GlucoseViewerApp: App {
    let userDefaults = UserDefaults.standard
    
    @State var bg:BGLabel = BGLabel(status: .Ok)
    @AppStorage("url") private var baseUrl : String = ""
    @AppStorage("token") private var token : String = ""
//    @State var baseUrl: String = ""
//    @State var token: String = ""
    @State var showingPopup = false
    @StateObject var bgs: BGData = BGData()
    
    @State var a = false;
    var body: some Scene {
        MenuBarExtra(content:{
            GlucoseDetailsView(baseUrl: $baseUrl, token: $token, bgData: bgs).frame(maxWidth: .infinity)
        }, label: {
            BGLabelView(bglabel: $bg).onAppear(perform: loadData)
        }).menuBarExtraStyle(.window).windowStyle(.hiddenTitleBar)

    }
    
    func loadData(){
        if(self.baseUrl.isEmpty){
            self.bg.status = .NoUrl
            Timer.scheduledTimer(withTimeInterval: 15, repeats: false){timer in
                loadData()
            }
            return
        }
        var urlString = self.baseUrl
        
        if(urlString.last != "/"){
            urlString += "/"
        }
        
        urlString += "pebble?count=20"
        if(!self.token.isEmpty){
            urlString += "&token="+self.token
        }
       
        guard let url = URL(string: urlString)
        else {
            self.bg.status = .Error
            return
        }
        
        var interval = 5.0*60.0
        URLSession.shared.dataTask(with: url) { (data, _, _) in
            DispatchQueue.main.async {
                do {
                    if(data != nil){
                        let r: APIData = try JSONDecoder().decode(APIData.self, from: data!)
                        
                        self.bg.direction = BGDirection(rawValue: r.bgs[0].direction)!
                        self.bg.glucose = Int(r.bgs[0].sgv)!
                        self.bg.delta = r.bgs[0].bgdelta!
                        self.bgs.replace(with: r.bgs)
                        self.bg.status = .Ok
                    } else {
                        self.bg.status = .Error
                        interval = 15.0
                    }
                } catch {
                    self.bg.status = .Error
                    print(error)
                    interval = 15.0
                }
                Timer.scheduledTimer(withTimeInterval: interval, repeats: false){timer in
                    loadData()
                }
            }
        }.resume()

    }
    
  

    
}

protocol BGS {
    var sgv: String {get set}
    var trend: Int {get set}
    var direction: String {get set}
    var datetime: Int {get set}
    var bgdelta: Int? {get set}
}


struct APIStatus : Codable {
    var now: Int
}

struct APIBgs : Codable,BGS{
    var sgv: String
    var trend: Int
    var direction: String
    var datetime: Int
    var bgdelta: Int?
}


struct APIData : Codable {
    var status: [APIStatus]
    var bgs: [APIBgs]
}


