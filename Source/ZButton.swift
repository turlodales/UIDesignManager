//
//  SampleButton.swift
//  SwiftTesting
//
//  Created by Zivato Limited on 04/05/2020.
//  Copyright © 2020 Zivato Limited. All rights reserved.
//

import SwiftUI

@available(iOS 13.0, *)
public struct ZButton: View {
   
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
    @State var action : (() -> Void)
    
    public init(name: String, text: String, defaultBackgroundHex: String, defaultForegroundHex:String, cornerRadius: CGFloat, SFIcon: String, font: String, fontSize: CGFloat, width: CGFloat, height: CGFloat, action: @escaping (() -> Void)) {
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
        self._action = State(initialValue: action)
    }
    
    @ObservedObject var zParams = ZObject()
    
    public var body: some View {
        
        Button(action: action) {
            
            if zParams.icon == "" {
                Text(zParams.text)
                    .frame(width: zParams.width, height: zParams.height, alignment: .center)
                    .background(zParams.color)
                    .foregroundColor(zParams.foregroundColor)
                    .cornerRadius(zParams.cornerRadius)
                    .font(zParams.font)
                    .onAppear(perform: self.UpdateUI)
                    .edgesIgnoringSafeArea(.all)
                
            } else {
                HStack {
                    
                    if zParams.text == "" {
                        Image(systemName: zParams.icon)
                            .font(.system(size: zParams.iconSize * 2))
                        
                    } else {
                        Image(systemName: zParams.icon)
                            .font(.system(size: zParams.iconSize))
                    }
                    
                    if zParams.text != "" {
                        Text(zParams.text)
                    }
                    
                }
                .frame(width: zParams.width, height: zParams.height, alignment: .center)
                .background(zParams.color)
                .foregroundColor(zParams.foregroundColor)
                .cornerRadius(zParams.cornerRadius)
                .font(zParams.font)
                .onAppear(perform: self.UpdateUI)
                
                .edgesIgnoringSafeArea(.all)
            }
        }.buttonStyle(BorderlessButtonStyle())//IMPORTANT
         
    }
    
  
    func UpdateUI() {
        zParams.styleButton(name: name, defBackgroundHex: defaultBackgroundHex, defForegroundHex: defaultForegroundHex, text: text, cornerRadius: cornerRadius, SFIcon: SFIcon, font: font, fontSize: fontSize, fWidth: width, fHeight: height)
    }
      
}

func test() {
  print("test")
}

struct ZButton_Previews: PreviewProvider {
    @available(iOS 13.0.0, *)
    static var previews: some View {
        ZButton(name: "sample", text: "Hello World", defaultBackgroundHex: "#FF0000", defaultForegroundHex: "#FFFFFF", cornerRadius: 5, SFIcon: "chevron.right", font: "Avenir-Medium", fontSize: 15.0, width: 100.0, height: 50.0, action: test)
    }
}

