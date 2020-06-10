//
//  ZView.swift
//  SwiftTesting
//
//  Created by Zivato Limited on 20/05/2020.
//  Copyright © 2020 Zivato Limited. All rights reserved.
//

import SwiftUI



struct ZView: View {

    @State var name : String
    @State var defaultBackgroundHex : String
    @State var cornerRadius : CGFloat
    @State var width : CGFloat
    @State var height: CGFloat
    
    
    
    
    
    
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

func zviewtest() {
  print("test")
}

struct ZView_Previews: PreviewProvider {
    static var previews: some View {
        ZView(name: "zview_sample", defaultBackgroundHex: "#ff0000", cornerRadius: 10, width: 80, height: 80)
    }
}


