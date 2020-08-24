//
//  CardView.swift
//  SlotApp
//
//  Created by Gutu Galuppo on 21.08.20.
//  Copyright © 2020 Gutu Galuppo. All rights reserved.
//

import SwiftUI

struct CardView: View {
    @Binding var symbol:String
    @Binding var background:Color
    var body: some View {
        
        Image(symbol)
        .resizable()
        .aspectRatio(1, contentMode:
            .fit)
        .background(background.opacity(0.5))
        .cornerRadius(20)
        
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        CardView(symbol: Binding.constant("cherry")
            , background: Binding.constant(Color.green))
    }
}
