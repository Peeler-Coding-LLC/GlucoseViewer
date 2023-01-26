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
    @State var showToken = false
    let userDefaults = UserDefaults.standard
    
    
    
    init(settings:Binding<GlucoseViewerSettings>){
        self._settings = settings
        self._originalSettings = State(initialValue: settings.wrappedValue)
    }
    
    var body: some View {
        VStack {
            Text("Glucose Toolbar Viewer Settings").font(.title)
            Form {
                VStack {
                    TextField(text: $originalSettings.url) {
                        Text("Nightscount URL").bold()
                        
                    }
                    ApiTokenField(value: $originalSettings.token)
                    HStack {
                        Picker(selection: $originalSettings.units, label: Text("Units:").bold()) {
                            Text("mg/dL").tag(GlucoseViewerSettings.Units.mgdL)
                            Text("mmol/L").tag(GlucoseViewerSettings.Units.mmolL)
                        }.pickerStyle(.radioGroup).horizontalRadioGroupLayout()
                        Spacer()
                        
                        Picker(selection: $originalSettings.axisStyle, label: Text("Axis Style:").bold() ) {
                            Text("Dynamic").tag(GlucoseViewerSettings.AxisStyle.dynamic)
                            Text("Fixed").tag(GlucoseViewerSettings.AxisStyle.fixed)
                        }.pickerStyle(.radioGroup).horizontalRadioGroupLayout().frame(alignment: .trailing)
                    }.frame(maxWidth: .infinity,alignment:.center)
                    HStack {
                        Button("Save") {
                            //since self.settings is a bound appstorage property
                            //any updates to it will get saved automatically
                            self.settings = self.originalSettings
                            self.presentation.wrappedValue.dismiss()
                        }
                        Button("Cancel"){
                            self.presentation.wrappedValue.dismiss()
                        }
                    }.frame(maxWidth: .infinity, alignment: .trailing)
                }.frame(maxWidth: .infinity).textFieldStyle(.roundedBorder)
            }.frame(width: 500).padding(5)
        }.padding(10)
    }
    
}

struct ApiTokenFieldLabel : View {
    var body:some View {
        Text("API Token").bold().padding(EdgeInsets(top: 0, leading: 44, bottom: 0, trailing: 0))
    }
}

struct ApiTokenField : View {
    @Binding var value : String
    @State var showToken: Bool = false
    
    var body : some View {
        ZStack(alignment: .trailing) {
            if(showToken){
                TextField(text: $value){
                    ApiTokenFieldLabel()
                }
            } else {
                SecureField(text: $value){
                    ApiTokenFieldLabel()
                }
            }
            Button(action: {
                showToken.toggle()
            }, label: {
                Image(systemName: showToken ? "eye" : "eye.slash")
            }).padding(.trailing, 7).buttonStyle(.plain)
        }
        
    }
    
}

struct EnterUrlView_Previews: PreviewProvider {
    @State static var settings = GlucoseViewerSettings()
    static var previews: some View {
        SettingsView(settings: $settings)
    }
}
