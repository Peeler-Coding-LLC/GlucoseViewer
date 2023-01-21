//
//  GlucoseViewerApp.swift
//  GlucoseViewer
//
//  Created by Chase Peeler on 1/16/23.
//  Copyright © 2023 Peeler Coding, LLC. All rights reserved.
//

import Foundation
import SwiftUI


@main
struct GlucoseViewerApp: App {
    @State var bg:BGLabel = BGLabel(status: .Ok)
    @AppStorage("settings") private var settings = GlucoseViewerSettings()
    @StateObject var bgs: BGData = BGData()
    private var api = NightscoutAPI()
    
    var body: some Scene {
        MenuBarExtra(content:{
            GlucoseDetailsView(settings:$settings, bgData: bgs).frame(maxWidth: .infinity)
        }, label: {
            BGLabelView(bglabel: $bg).task{ await self.loadData()}
        }).menuBarExtraStyle(.window).windowStyle(.hiddenTitleBar)
    }
    
    ///  triggers API call and loads data
    func loadData() async {
        print(self.settings.rawValue)
        
        var interval = 15.0
        do {
            let r = try await api.loadData(self.settings.url,token: self.settings.token)
            self.bg.direction = BGDirection(rawValue: r.bgs[0].direction)!
            self.bg.glucose = Int(r.bgs[0].sgv)!
            self.bg.delta = r.bgs[0].bgdelta!
            self.bgs.replace(with: r.bgs)
            self.bg.status = .Ok
            interval = 5.0*60.0
        } catch APIError.EmptyUrl {
            self.bg.status = .NoUrl
        } catch APIError.InvalidUrl(let url){
            print("Invalid URL: \(url)")
        } catch APIError.FailedRequest {
            print("The request failed")
        } catch APIError.DecodeError(let e){
            print("Decoding Error \(e)")
        } catch {
            print("Unknown error: \(error)")
        }
        Timer.scheduledTimer(withTimeInterval: interval, repeats: false){timer in
            Task {
                await loadData()
            }
        }
    }
    
}











