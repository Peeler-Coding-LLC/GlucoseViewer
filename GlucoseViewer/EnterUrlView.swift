//
//  EnterUrlView.swift
//  GlucoseViewer
//
//  Created by Chase Peeler on 1/13/23.
//  Copyright © 2023 Peeler Coding, LLC. All rights reserved.
//

import SwiftUI

struct EnterUrlView: View {
    @Binding var url : String
    @Binding var token: String
    var body: some View {
        Form {
            TextField("Nightscout URL",text: $url)
            TextField("API Token",text: $token)
            HStack {
                Button("Save") {
                    
                }
                Button("Cancel"){
                    
                }
            }.frame(maxWidth: .infinity, alignment: .trailing)
        }.frame(width: 500).padding(5)
    }
}

struct EnterUrlView_Previews: PreviewProvider {
    @State static var b = ""
    @State static var u = "d"
    static var previews: some View {
        EnterUrlView(url: $u, token: $b)
    }
}
