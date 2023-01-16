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
    
    @Binding var url : String
    @Binding var token: String
    
    @State var originalUrl: String
    @State var originalToken: String
    let userDefaults = UserDefaults.standard
    

    
    init(url: Binding<String>, token: Binding<String>){
        self._url = url
        self._token = token
        
        self._originalUrl = State(initialValue: url.wrappedValue)
        self._originalToken = State(initialValue: token.wrappedValue)
    }
    
    var body: some View {
        VStack {
            Text("Glucose Toolbar Viewer Settings").font(.title)
            Form {
                TextField("Nightscout URL",text: $originalUrl)
                TextField("API Token",text: $originalToken)
                HStack {
                    Button("Save") {
                        self.url = self.originalUrl
                        self.token = self.originalToken
                        userDefaults.set(self.url, forKey: "url")
                        userDefaults.set(self.token, forKey:"token")
                        
                        self.presentation.wrappedValue.dismiss()
                    }
                    Button("Cancel"){
 //                       self.url = self.originalUrl
   //                     self.token = self.originalToken
                        self.presentation.wrappedValue.dismiss()
                    }
                }.frame(maxWidth: .infinity, alignment: .trailing)
            }.frame(width: 500).padding(5)
        }.padding(10)
    }
}

struct EnterUrlView_Previews: PreviewProvider {
    @State static var b = ""
    @State static var u = "d"
    static var previews: some View {
        SettingsView(url: $u, token: $b)
    }
}
