//
//  BGLabelView.swift
//  DexcomViewer
//
//  Created by Chase Peeler on 1/11/23.
//

import SwiftUI

struct BGLabelView: View {
    @Binding var bglabel : BGLabel
    var body: some View {
        if(bglabel.status == .NoUrl){
            Text("Set URL")
        } else if(bglabel.status == .Error){
            Text("Error")
        } else {
            Text(bglabel.combined)
        }
    }
}

struct BGLabelView_Previews: PreviewProvider {
    @State static var bg = BGLabel(glucose: "101", direction: .Flat, delta: 2)
    static var previews: some View {
        BGLabelView(bglabel: $bg)
    }
}
