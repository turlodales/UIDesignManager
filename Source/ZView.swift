//
//  ZView.swift
//  SwiftTesting
//
//  Created by Zivato Limited on 20/05/2020.
//  Copyright © 2020 Zivato Limited. All rights reserved.
//

import SwiftUI



@available(iOS 13.0, *)
struct ZView: View {

    @State var name : String
    @State var defaultBackgroundHex : String
    @State var cornerRadius : CGFloat
    @State var width : CGFloat
    @State var height: CGFloat
    
    public init(name: String, defaultBackgroundHex: String, cornerRadius: CGFloat, width: CGFloat, height: CGFloat) {
        self._name = State(initialValue: name)
        self._defaultBackgroundHex = State(initialValue: defaultBackgroundHex)
        self._cornerRadius = State(initialValue: cornerRadius)
        self._width = State(initialValue: width)
        self._height = State(initialValue: height)
    }
    
    @ObservedObject var zParams = ZObject()
    
    var body: some View {
        
        ZStack {
            
            Image("")
                
            }.frame(width: zParams.width, height: zParams.height, alignment: .center)
            .background(zParams.color)
            .cornerRadius(zParams.cornerRadius)
            .font(zParams.font)
            .onAppear(perform: self.UpdateUI)
            
            .edgesIgnoringSafeArea(.all)
        }
        
    func UpdateUI() {
        zParams.styleView(name: name, defBackgroundHex: defaultBackgroundHex, cornerRadius: cornerRadius, fWidth: width, fHeight: height)
    }
      
}

struct ZView_Previews: PreviewProvider {
    @available(iOS 13.0.0, *)
    static var previews: some View {
        ZView(name: "zview_sample", defaultBackgroundHex: "#ff0000", cornerRadius: 10, width: 80, height: 80)
    }
}


