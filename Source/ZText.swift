//
//  ZText.swift
//  SwiftTesting
//
//  Created by Zivato Limited on 28/05/2020.
//  Copyright © 2020 Zivato Limited. All rights reserved.
//


import SwiftUI

@available(iOS 13.0, *)
struct ZText: View {

    @State var name : String
    @State var text : String
    @State var defaultBackgroundHex : String
    @State var defaultForegroundHex : String
    @State var cornerRadius : CGFloat
    @State var SFIcon : String
    @State var font : String
    @State var fontSize : CGFloat
    @State var width : CGFloat
    @State var height: CGFloat
    
    public init(name: String, text: String, defaultBackgroundHex: String, defaultForegroundHex:String, cornerRadius: CGFloat, SFIcon: String, font: String, fontSize: CGFloat, width: CGFloat, height: CGFloat) {
        self._name = State(initialValue: name)
        self._text = State(initialValue: text)
        self._defaultBackgroundHex = State(initialValue: defaultBackgroundHex)
        self._defaultForegroundHex = State(initialValue: defaultForegroundHex)
        self._cornerRadius = State(initialValue: cornerRadius)
        self._SFIcon = State(initialValue: SFIcon)
        self._font = State(initialValue: font)
        self._fontSize = State(initialValue: fontSize)
        self._width = State(initialValue: width)
        self._height = State(initialValue: height)
    }
        
    @ObservedObject var zParams = ZObject()
    
    var body: some View {
        
        Text(text)
            
            .frame(width: zParams.width, height: zParams.height, alignment: .leading)
            .padding()
            .background(zParams.color)
            .foregroundColor(zParams.foregroundColor)
            .cornerRadius(zParams.cornerRadius)
            .font(zParams.font)
            
            .onAppear(perform: self.UpdateUI)

    }
    
    func UpdateUI() {
        zParams.styleText(name: name, defBackgroundHex: defaultBackgroundHex, defForegroundHex: defaultForegroundHex, text: text, cornerRadius: cornerRadius, SFIcon: SFIcon, font: font, fontSize: fontSize, fWidth: width, fHeight: height)
    }
      
}

func ZTextTest() {
  print("test")
}

struct ZText_Previews: PreviewProvider {
    @available(iOS 13.0.0, *)
    static var previews: some View {
        ZText(name: "sample", text: "Hello World", defaultBackgroundHex: "#FF0000", defaultForegroundHex: "#FFFFFF", cornerRadius: 5, SFIcon: "chevron.right", font: "Avenir-Medium", fontSize: 15.0, width: 100.0, height: 50.0)
    }
}

