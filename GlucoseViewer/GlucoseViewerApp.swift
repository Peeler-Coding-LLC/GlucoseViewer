//
//  DexcomViewerApp.swift
//  DexcomViewer
//
//  Created by Chase Peeler on 1/10/23.
//

import SwiftUI

@main
struct GlucoseViewerApp: App {
    @State var bg:BGLabel = BGLabel(glucose: 99, direction: BGDirection(rawValue: "DoubleDown")!)
    var body: some Scene {
        MenuBarExtra(content:{
            Button("T"){
                bg.glucose = 100
                bg.direction = BGDirection(rawValue: "FortyFiveUp")!
            }
            Divider()
            Button("Quit") {
                NSApplication.shared.terminate(nil)

            }
        }, label: {
            BGLabelView(bglabel: $bg).onAppear(perform: loadData)
                    
                 
            
        })
    }
    
    func loadData(){
        guard let url = URL(string: "https://nightscout.chasepeeler.com/pebble")
        else {
            return
            
        }
        print("foo")
        URLSession.shared.dataTask(with: url) { (data, _, _) in
            print("2")
            DispatchQueue.main.async {
                do {
                    print("3")
                    let r: APIData = try JSONDecoder().decode(APIData.self, from: data!)
                    self.bg.direction = BGDirection(rawValue: r.bgs[0].direction)!
                    self.bg.glucose = Int(r.bgs[0].sgv)!
                    self.bg.delta = r.bgs[0].bgdelta
                } catch {
                    print("decode fail")
                }
                print("5")
                Timer.scheduledTimer(withTimeInterval: 5.0*60.0, repeats: false){timer in
                    print("4")
                    loadData()
                }
            }
        }.resume()

    }
    
}

struct APIStatus : Codable {
    var now: Int
}

struct APIBgs : Codable {
    var sgv: String
    var trend: Int
    var direction: String
    var datetime: Int
    var bgdelta: Int
}


struct APIData : Codable {
    var status: [APIStatus]
    var bgs: [APIBgs]
}




