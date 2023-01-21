//
//  EnterUrlView.swift
//  GlucoseViewer
//
//  Created by Chase Peeler on 1/13/23.
//  Copyright © 2023 Peeler Coding, LLC. All rights reserved.
//

import SwiftUI
import Combine

struct SettingsView: View {
    @Environment(\.presentationMode) var presentation
    
    @Binding var settings :GlucoseViewerSettings
    @State var originalSettings:GlucoseViewerSettings
//    @State var originalUrl: String
//    @State var originalToken: String
//    @State var originalUnits: GlucoseViewerSettings.Units
//    @State var originalAxis: GlucoseViewerSettings.GraphAxis
    let userDefaults = UserDefaults.standard
    

    
    init(settings:Binding<GlucoseViewerSettings>){
        self._settings = settings
        self._originalSettings = State(initialValue: settings.wrappedValue)
    }
    
    var body: some View {
        VStack {
            Text("Glucose Toolbar Viewer Settings").font(.title)
            Form {
                TextField("Nightscout URL",text: $originalSettings.url)
                TextField("API Token",text: $originalSettings.token)
                HStack {
                    Button("Save") {
                        self.settings = self.originalSettings
                        print(self.settings.rawValue)
                        userDefaults.set(self.settings.rawValue, forKey: "settings")
                        self.presentation.wrappedValue.dismiss()
                    }
                    Button("Cancel"){
                        self.presentation.wrappedValue.dismiss()
                    }
                }.frame(maxWidth: .infinity, alignment: .trailing)
            }.frame(width: 500).padding(5)
        }.padding(10)
    }
}

struct EnterUrlView_Previews: PreviewProvider {
    @State static var settings = GlucoseViewerSettings()
    static var previews: some View {
        SettingsView(settings: $settings)
    }
}
