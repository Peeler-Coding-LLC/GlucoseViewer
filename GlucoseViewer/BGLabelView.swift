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
        Text(bglabel.combined)
    }
}

struct BGLabelView_Previews: PreviewProvider {
    @State static var bg = BGLabel(glucose: 100, direction: .Flat, delta: 2)
    static var previews: some View {
        BGLabelView(bglabel: $bg)
    }
}