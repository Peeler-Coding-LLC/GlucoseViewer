//
//  DexcomViewerApp.swift
//  DexcomViewer
//
//  Created by Chase Peeler on 1/10/23.
//

import SwiftUI

@main
struct DexcomViewerApp: App {
    var body: some Scene {
        //WindowGroup {
        //    ContentView()
        //}
        MenuBarExtra("CP"){
            Button("T"){}
            Button("Z"){}
            Divider()
            Button("Quit") {
                NSApplication.shared.terminate(nil)

            }
        }
    }
}
