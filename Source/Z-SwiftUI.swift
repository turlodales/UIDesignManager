//
//  ZColor.swift
//  SwiftTesting
//
//  Created by Zivato Limited on 05/05/2020.
//  Copyright © 2020 Zivato Limited. All rights reserved.
//

import Foundation
import SwiftUI

public var objectIds = [String]()

extension Date {
    func currentTimeMillis() -> Int64 {
        return Int64(self.timeIntervalSince1970 * 1000)
    }
}

@available(iOS 13.0, *)
class ZObject:ObservableObject {
    
    @Published var color = Color.clear
    @Published var text = String()
    @Published var opacity = 0.0
    @Published var foregroundColor = Color.clear
    @Published var cornerRadius = CGFloat(0.0)
    @Published var icon = ""
    @Published var font = Font.custom("Avenir-Medium", size: 15.0)
    @Published var style = "standard"
    @Published var height = CGFloat()
    @Published var width = CGFloat()
    @Published var iconSize = CGFloat()
    
    public func set(passKey: String) {
        key = passKey
        appId = "\(Bundle.main.bundleIdentifier!)\(key)".validString
        print("UIDesignManager ID: \(appId)")
    }
    
    public func styleText(name: String, defBackgroundHex: String, defForegroundHex: String, text: String, cornerRadius: CGFloat, SFIcon: String, font: String, fontSize: CGFloat, fWidth: CGFloat, fHeight: CGFloat) {

        var col = Color.init(hex: defBackgroundHex)
        let defaults = UserDefaults.standard
        
        if let config = defaults.value(forKey: name) as? [String: Any] {
            if let status = config["active"] as? Bool {
                if status == true {
                    if let bgColour = config["textBgColour"] as? String {
                        col = Color.init(hex: bgColour)
                        color = col
                        opacity = 1.0
                    }
                    if let textValue = config["textValue"] as? String {
                        self.text = textValue
                    }
                    if let textColor = config["textColour"] as? String {
                        self.foregroundColor = Color.init(hex: textColor)
                    }
                    if let icon = config["icon"] as? String {
                        self.icon = icon
                    }
                    if let corners = config["cornerRadius"] as? CGFloat {
                        self.cornerRadius = corners
                    }
                    if let frameWidth = config["width"] as? CGFloat {
                        self.width = frameWidth
                    }
                    if let frameHeight = config["height"] as? CGFloat {
                        self.height = frameHeight
                    }
                    if let fontName = config["fontName"] as? String {
                        if let fontSize = config["fontSize"] as? CGFloat {
                        self.font = Font.custom(fontName, size: fontSize)
                        self.iconSize = fontSize
                        }
                    }
                } else {
                    col = Color.init(hex: defBackgroundHex)
                    self.foregroundColor = Color.init(hex: defForegroundHex)
                    color = col
                    opacity = 1.0
                    self.cornerRadius = cornerRadius
                    self.font = Font.custom(font, size: fontSize)
                    self.iconSize = fontSize
                    self.width = fWidth
                    self.height = fHeight
                    self.icon = SFIcon
                }
            }
        } else {
            color = col
            opacity = 1.0
            self.text = text
            self.foregroundColor = Color.init(hex: defForegroundHex)
            self.cornerRadius = cornerRadius
            self.font = Font.custom(font, size: fontSize)
            self.iconSize = fontSize
            self.width = fWidth
            self.height = fHeight
            self.icon = SFIcon
        }
        
        var returnedColor = col
        
        let url = URL(string: "https://uidesignmanager.herokuapp.com/v1/getasset/id/\(name)/\(appId)")!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            if let error = error {
                print("error: \(error)")
            } else {
                if (response as? HTTPURLResponse) != nil {
                    if let data = data, let dataString = String(data: data, encoding: .utf8) {
                        let data = dataString.data(using: .utf8)!
                        do{
                            let responseObject = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String:AnyObject]
                            if let dataObject = responseObject!["data"] as? [String : AnyObject]{
                                if let components = dataObject["components"] as? NSArray{
                                    if components.count != 0 {
                                        let jsonData = components[0] as! [String : AnyObject]
                                        
                                        DispatchQueue.main.async {
                                        UserDefaults.standard.setValue(jsonData, forKey: name)
                                        }
                                        objectIds.append(name)
                                        if let status = jsonData["active"] as? Bool{
                                            if status == true {
                                                if let color = jsonData["textBgColour"] as? String{
                                                    DispatchQueue.main.async {
                                                        returnedColor = Color.init(hex: color)
                                                        self.color = returnedColor
                                                        self.opacity = 1.0

                                                    }
                                                }
                                                if let textValue = jsonData["textValue"] as? String{
                                                    DispatchQueue.main.async {
                                                        self.text = textValue
                                                    }
                                                }
                                                if let textColor = jsonData["textColour"] as? String{
                                                    DispatchQueue.main.async {
                                                        self.foregroundColor = Color.init(hex: textColor)
                                                    }
                                                }
                                                if let SFIcon = jsonData["icon"] as? String {
                                                    DispatchQueue.main.async {
                                                        self.icon = SFIcon
                                                    }
                                                }
                                                if let corners = jsonData["cornerRadius"] as? CGFloat {
                                                    DispatchQueue.main.async {
                                                    self.cornerRadius = corners
                                                    }
                                                }
                                                if let fontName = jsonData["fontName"] as? String {
                                                    if let fontSize = jsonData["fontSize"] as? CGFloat {
                                                        DispatchQueue.main.async {
                                                    self.font = Font.custom(fontName, size: fontSize)
                                                            self.iconSize = fontSize
                                                        }
                                                    }
                                                }
                                                if let frameWidth = jsonData["width"] as? CGFloat {
                                                    DispatchQueue.main.async {
                                                    self.width = frameWidth
                                                    }
                                                }
                                                if let frameHeight = jsonData["height"] as? CGFloat {
                                                    DispatchQueue.main.async {
                                                    self.height = frameHeight
                                                    }
                                                }
                                            } else {
                                                returnedColor = Color.init(hex: defBackgroundHex)
                                                self.color = returnedColor
                                                self.opacity = 1.0
                                                self.foregroundColor = Color.init(hex: defForegroundHex)
                                                self.cornerRadius = cornerRadius
                                                self.font = Font.custom(font, size: fontSize)
                                                self.iconSize = fontSize
                                                self.width = fWidth
                                                self.height = fHeight
                                                self.icon = SFIcon
                                            }
                                        }
                                    } else if components.count == 0 && !objectIds.contains(name) {
                                        objectIds.append(name)
                                        DispatchQueue.main.async {
                                            self.color = col
                                            self.opacity = 1.0
                                            self.cornerRadius = cornerRadius
                                            self.font = Font.custom(font, size: fontSize)
                                            self.iconSize = fontSize
                                            self.width = fWidth
                                            self.height = fHeight
                                            self.icon = SFIcon
                                        }
                                            
                                        if defBackgroundHex == "" {
                                            print("Error---> Invalid default background hexidecimal value")
                                            return
                                        }
                                        
                                        if defForegroundHex == "" {
                                            print("Error---> Invalid default foreground hexidecimal value")
                                            return
                                        }
                                            
                                            var params = [String : AnyObject]()
                                            let url = URL(string: "https://uidesignmanager.herokuapp.com/v1/assets")!
                                            var request = URLRequest(url: url)
                                            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                                            request.httpMethod = "POST"
                                            let timestamp = NSDate().timeIntervalSince1970
                                            let json: [String: Any] = ["color":defBackgroundHex, "timestamp":timestamp, "name":name, "type": "SwiftUIButton", "active" : true, "bundle_id" : appId, "textValue" : text]
                                            let jsonData = try? JSONSerialization.data(withJSONObject: json)
                                            params["title_id"] = name as AnyObject
                                            params["bundle_id"] = appId as AnyObject
                                            params["fontName"] = font as AnyObject;
                                            params["fontSize"] = fontSize as AnyObject
                                            params["hConstraints"] = "H:[self(\(fWidth))]" as AnyObject
                                            params["vConstraints"] = "V:[self(\(fHeight))]" as AnyObject
                                            params["textValue"] = text as AnyObject;
                                            params["textColour"] = defForegroundHex as AnyObject;
                                            params["textBgColour"] = defBackgroundHex as AnyObject;
                                            params["textAlignment"] = 0 as AnyObject;
                                            params["color"] = defBackgroundHex as AnyObject;
                                            params["bgColour"] = defBackgroundHex as AnyObject;
                                            params["cornerRadius"] = cornerRadius as AnyObject;
                                            params["type"] = "SwiftUIText" as AnyObject;
                                            params["source"] = "SwiftUI" as AnyObject;
                                            params["timestamp"] = timestamp as AnyObject;
                                            params["name"] = name as AnyObject;
                                            params["contentMode"] = "" as AnyObject;
                                            params["active"] = true as AnyObject;
                                            params["centerHorizontally"] = true as AnyObject;
                                            params["centerVertically"] = true as AnyObject;
                                            params["imagedata"] = "" as AnyObject;
                                            params["icon"] = SFIcon as AnyObject;
                                            defaults.setValue(jsonData, forKey: name)
                                            
                                            
                                            request.httpBody = try? JSONSerialization.data(withJSONObject: params, options: [])
                                            let session = URLSession.shared
                                            let task = session.dataTask(with: request, completionHandler: { data, response, error -> Void in
                                                do {
                                                    _ = try JSONSerialization.jsonObject(with: data!) as! Dictionary<String, AnyObject>
                                                    print("Uploaded initial parameters successfully for -----> \(name)")
                                                } catch {
                                                    print(error.localizedDescription)
                                                }
                                            })
                                            defaults.setValue(params, forKey: name)
                                            
                                            task.resume()
                                            
                                    }
                                }
                            }
                        } catch {
                            print(error.localizedDescription)
                        }
                    }
                }
            }
        }
        
        task.resume()
    }
    
    public func styleButton(name: String, defBackgroundHex: String, defForegroundHex: String, text: String, cornerRadius: CGFloat, SFIcon: String, font: String, fontSize: CGFloat, fWidth: CGFloat, fHeight: CGFloat) {

        var col = Color.init(hex: defBackgroundHex)
        let defaults = UserDefaults.standard
        
        if let config = defaults.value(forKey: name) as? [String: Any] {
            if let status = config["active"] as? Bool {
                if status == true {
                    if let bgColour = config["textBgColour"] as? String {
                        col = Color.init(hex: bgColour)
                        color = col
                        opacity = 1.0
                    }
                    if let textValue = config["textValue"] as? String {
                        self.text = textValue
                    }
                    if let textColor = config["textColour"] as? String {
                        self.foregroundColor = Color.init(hex: textColor)
                    }
                    if let icon = config["icon"] as? String {
                        self.icon = icon
                    }
                    if let corners = config["cornerRadius"] as? CGFloat {
                        self.cornerRadius = corners
                    }
                    if let frameWidth = config["width"] as? CGFloat {
                        self.width = frameWidth
                    }
                    if let frameHeight = config["height"] as? CGFloat {
                        self.height = frameHeight
                    }
                    if let fontName = config["fontName"] as? String {
                        if let fontSize = config["fontSize"] as? CGFloat {
                        self.font = Font.custom(fontName, size: fontSize)
                        self.iconSize = fontSize
                        }
                    }
                } else {
                    col = Color.init(hex: defBackgroundHex)
                    self.foregroundColor = Color.init(hex: defForegroundHex)
                    color = col
                    opacity = 1.0
                    self.cornerRadius = cornerRadius
                    self.font = Font.custom(font, size: fontSize)
                    self.iconSize = fontSize
                    self.width = fWidth
                    self.height = fHeight
                    self.icon = SFIcon
                }
            }
        } else {
            color = col
            opacity = 1.0
            self.text = text
            self.foregroundColor = Color.init(hex: defForegroundHex)
            self.cornerRadius = cornerRadius
            self.font = Font.custom(font, size: fontSize)
            self.iconSize = fontSize
            self.width = fWidth
            self.height = fHeight
            self.icon = SFIcon
        }
        
        var returnedColor = col
        
        let url = URL(string: "https://uidesignmanager.herokuapp.com/v1/getasset/id/\(name)/\(appId)")!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            if let error = error {
                print("error: \(error)")
            } else {
                if (response as? HTTPURLResponse) != nil {
                    if let data = data, let dataString = String(data: data, encoding: .utf8) {
                        let data = dataString.data(using: .utf8)!
                        do{
                            let responseObject = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String:AnyObject]
                            if let dataObject = responseObject!["data"] as? [String : AnyObject]{
                                if let components = dataObject["components"] as? NSArray{
                                    if components.count != 0 {
                                        let jsonData = components[0] as! [String : AnyObject]
                                        
                                        DispatchQueue.main.async {
                                        UserDefaults.standard.setValue(jsonData, forKey: name)
                                        }
                                        objectIds.append(name)
                                        if let status = jsonData["active"] as? Bool{
                                            if status == true {
                                                if let color = jsonData["textBgColour"] as? String{
                                                    DispatchQueue.main.async {
                                                        returnedColor = Color.init(hex: color)
                                                        self.color = returnedColor
                                                        self.opacity = 1.0
                                                    }
                                                }
                                                if let textValue = jsonData["textValue"] as? String{
                                                    DispatchQueue.main.async {
                                                        self.text = textValue
                                                    }
                                                }
                                                if let textColor = jsonData["textColour"] as? String{
                                                    DispatchQueue.main.async {
                                                        self.foregroundColor = Color.init(hex: textColor)
                                                    }
                                                }
                                                if let SFIcon = jsonData["icon"] as? String {
                                                    DispatchQueue.main.async {
                                                        self.icon = SFIcon
                                                    }
                                                }
                                                if let corners = jsonData["cornerRadius"] as? CGFloat {
                                                    DispatchQueue.main.async {
                                                    self.cornerRadius = corners
                                                    }
                                                }
                                                if let fontName = jsonData["fontName"] as? String {
                                                    if let fontSize = jsonData["fontSize"] as? CGFloat {
                                                        DispatchQueue.main.async {
                                                    self.font = Font.custom(fontName, size: fontSize)
                                                            self.iconSize = fontSize
                                                        }
                                                    }
                                                }
                                                if let frameWidth = jsonData["width"] as? CGFloat {
                                                    DispatchQueue.main.async {
                                                    self.width = frameWidth
                                                    }
                                                }
                                                if let frameHeight = jsonData["height"] as? CGFloat {
                                                    DispatchQueue.main.async {
                                                    self.height = frameHeight
                                                    }
                                                }
                                            } else {
                                                returnedColor = Color.init(hex: defBackgroundHex)
                                                self.color = returnedColor
                                                self.opacity = 1.0
                                                self.foregroundColor = Color.init(hex: defForegroundHex)
                                                self.cornerRadius = cornerRadius
                                                self.font = Font.custom(font, size: fontSize)
                                                self.iconSize = fontSize
                                                self.width = fWidth
                                                self.height = fHeight
                                                self.icon = SFIcon
                                            }
                                        }
                                    } else if components.count == 0 && !objectIds.contains(name) {
                                        objectIds.append(name)
                                        DispatchQueue.main.async {
                                            self.color = col
                                            self.opacity = 1.0
                                            self.cornerRadius = cornerRadius
                                            self.font = Font.custom(font, size: fontSize)
                                            self.iconSize = fontSize
                                            self.width = fWidth
                                            self.height = fHeight
                                            self.icon = SFIcon
                                        }
                                            
                                        if defBackgroundHex == "" {
                                            print("Error---> Invalid default background hexidecimal value")
                                            return
                                        }
                                        
                                        if defForegroundHex == "" {
                                            print("Error---> Invalid default foreground hexidecimal value")
                                            return
                                        }
                                            
                                            var params = [String : AnyObject]()
                                            let url = URL(string: "https://uidesignmanager.herokuapp.com/v1/assets")!
                                            var request = URLRequest(url: url)
                                            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                                            request.httpMethod = "POST"
                                            let timestamp = NSDate().timeIntervalSince1970
                                            let json: [String: Any] = ["color":defBackgroundHex, "timestamp":timestamp, "name":name, "type": "SwiftUIButton", "active" : true, "bundle_id" : appId, "textValue" : text]
                                            let jsonData = try? JSONSerialization.data(withJSONObject: json)
                                            params["title_id"] = name as AnyObject
                                            params["bundle_id"] = appId as AnyObject
                                            params["fontName"] = font as AnyObject;
                                            params["fontSize"] = fontSize as AnyObject
                                            params["hConstraints"] = "H:[self(\(fWidth))]" as AnyObject
                                            params["vConstraints"] = "V:[self(\(fHeight))]" as AnyObject
                                            params["textValue"] = text as AnyObject;
                                            params["textColour"] = defForegroundHex as AnyObject;
                                            params["textBgColour"] = defBackgroundHex as AnyObject;
                                            params["textAlignment"] = 0 as AnyObject;
                                            params["color"] = defBackgroundHex as AnyObject;
                                            params["bgColour"] = defBackgroundHex as AnyObject;
                                            params["cornerRadius"] = cornerRadius as AnyObject;
                                            params["type"] = "SwiftUIButton" as AnyObject;
                                            params["source"] = "SwiftUI" as AnyObject;
                                            params["timestamp"] = timestamp as AnyObject;
                                            params["name"] = name as AnyObject;
                                            params["contentMode"] = "" as AnyObject;
                                            params["active"] = true as AnyObject;
                                            params["centerHorizontally"] = true as AnyObject;
                                            params["centerVertically"] = true as AnyObject;
                                            params["imagedata"] = "" as AnyObject;
                                            params["icon"] = SFIcon as AnyObject;
                                            defaults.setValue(jsonData, forKey: name)
                                            
                                            
                                            request.httpBody = try? JSONSerialization.data(withJSONObject: params, options: [])
                                            let session = URLSession.shared
                                            let task = session.dataTask(with: request, completionHandler: { data, response, error -> Void in
                                                do {
                                                    _ = try JSONSerialization.jsonObject(with: data!) as! Dictionary<String, AnyObject>
                                                    print("Uploaded initial parameters successfully for -----> \(name)")
                                                } catch {
                                                    print(error.localizedDescription)
                                                }
                                            })
                                            defaults.setValue(params, forKey: name)
                                            
                                            task.resume()
                                            
                                    }
                                }
                            }
                        } catch {
                            print(error.localizedDescription)
                        }
                    }
                }
            }
        }
        
        task.resume()
    }
    
    public func styleView(name: String, defBackgroundHex: String, cornerRadius: CGFloat, fWidth: CGFloat, fHeight: CGFloat) {

        var col = Color.init(hex: defBackgroundHex)
        let defaults = UserDefaults.standard
        
        if let config = defaults.value(forKey: name) as? [String: Any] {
            if let status = config["active"] as? Bool {
                if status == true {
                    if let bgColour = config["bgColour"] as? String {
                        col = Color.init(hex: bgColour)
                        color = col
                        opacity = 1.0
                    }
                    if let corners = config["cornerRadius"] as? CGFloat {
                        self.cornerRadius = corners
                    }
                    if let frameWidth = config["width"] as? CGFloat {
                        self.width = frameWidth
                    }
                    if let frameHeight = config["height"] as? CGFloat {
                        self.height = frameHeight
                    }
                } else {
                    col = Color.init(hex: defBackgroundHex)
                    color = col
                    opacity = 1.0
                    self.cornerRadius = cornerRadius
                    self.width = fWidth
                    self.height = fHeight
                }
            }
        } else {
            color = col
            opacity = 1.0
            self.cornerRadius = cornerRadius
            self.width = fWidth
            self.height = fHeight
        }
        
        var returnedColor = col
        
        let url = URL(string: "https://uidesignmanager.herokuapp.com/v1/getasset/id/\(name)/\(appId)")!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            if let error = error {
                print("error: \(error)")
            } else {
                if (response as? HTTPURLResponse) != nil {
                    if let data = data, let dataString = String(data: data, encoding: .utf8) {
                        let data = dataString.data(using: .utf8)!
                        do{
                            let responseObject = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String:AnyObject]
                            if let dataObject = responseObject!["data"] as? [String : AnyObject]{
                                if let components = dataObject["components"] as? NSArray{
                                    if components.count != 0 {
                                        let jsonData = components[0] as! [String : AnyObject]
                                        
                                        DispatchQueue.main.async {
                                        UserDefaults.standard.setValue(jsonData, forKey: name)
                                        }
                                        objectIds.append(name)
                                        if let status = jsonData["active"] as? Bool{
                                            if status == true {
                                                if let color = jsonData["bgColour"] as? String{
                                                    DispatchQueue.main.async {
                                                        returnedColor = Color.init(hex: color)
                                                        self.color = returnedColor
                                                        self.opacity = 1.0
                                                    }
                                                }
                                                if let corners = jsonData["cornerRadius"] as? CGFloat {
                                                    DispatchQueue.main.async {
                                                    self.cornerRadius = corners
                                                    }
                                                }
                                                if let fontName = jsonData["fontName"] as? String {
                                                    if let fontSize = jsonData["fontSize"] as? CGFloat {
                                                        DispatchQueue.main.async {
                                                    self.font = Font.custom(fontName, size: fontSize)
                                                            self.iconSize = fontSize
                                                        }
                                                    }
                                                }
                                                if let frameWidth = jsonData["width"] as? CGFloat {
                                                    DispatchQueue.main.async {
                                                    self.width = frameWidth
                                                    }
                                                }
                                                if let frameHeight = jsonData["height"] as? CGFloat {
                                                    DispatchQueue.main.async {
                                                    self.height = frameHeight
                                                    }
                                                }
                                            } else {
                                                returnedColor = Color.init(hex: defBackgroundHex)
                                                self.color = returnedColor
                                                self.opacity = 1.0
                                                self.cornerRadius = cornerRadius
                                                self.width = fWidth
                                                self.height = fHeight
                                            }
                                        }
                                    } else if components.count == 0 && !objectIds.contains(name) {
                                        objectIds.append(name)
                                        DispatchQueue.main.async {
                                            self.color = col
                                            self.opacity = 1.0
                                            self.cornerRadius = cornerRadius
                                            self.width = fWidth
                                            self.height = fHeight
                                        }
                                            
                                        if defBackgroundHex == "" {
                                            print("Error---> Invalid default background hexidecimal value")
                                            return
                                        }
                                        
                                        
                                            
                                            var params = [String : AnyObject]()
                                            let url = URL(string: "https://uidesignmanager.herokuapp.com/v1/assets")!
                                            var request = URLRequest(url: url)
                                            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                                            request.httpMethod = "POST"
                                            let timestamp = NSDate().timeIntervalSince1970
                                            let json: [String: Any] = ["color":defBackgroundHex, "timestamp":timestamp, "name":name, "type": "SwiftUIView", "active" : true, "bundle_id" : appId]
                                            let jsonData = try? JSONSerialization.data(withJSONObject: json)
                                            params["title_id"] = name as AnyObject
                                            params["bundle_id"] = appId as AnyObject
                                            params["fontName"] = "" as AnyObject;
                                            params["fontSize"] = 0 as AnyObject
                                            params["hConstraints"] = "H:[self(\(fWidth))]" as AnyObject
                                            params["vConstraints"] = "V:[self(\(fHeight))]" as AnyObject
                                            params["textValue"] = "" as AnyObject;
                                            params["textColour"] = "" as AnyObject;
                                            params["textBgColour"] = defBackgroundHex as AnyObject;
                                            params["textAlignment"] = 0 as AnyObject;
                                            params["color"] = defBackgroundHex as AnyObject;
                                            params["bgColour"] = defBackgroundHex as AnyObject;
                                            params["cornerRadius"] = cornerRadius as AnyObject;
                                            params["type"] = "SwiftUIButton" as AnyObject;
                                            params["source"] = "SwiftUI" as AnyObject;
                                            params["timestamp"] = timestamp as AnyObject;
                                            params["name"] = name as AnyObject;
                                            params["contentMode"] = "" as AnyObject;
                                            params["active"] = true as AnyObject;
                                            params["centerHorizontally"] = true as AnyObject;
                                            params["centerVertically"] = true as AnyObject;
                                            params["imagedata"] = "" as AnyObject;
                                            params["icon"] = "" as AnyObject;
                                            defaults.setValue(jsonData, forKey: name)
                                            
                                            
                                            request.httpBody = try? JSONSerialization.data(withJSONObject: params, options: [])
                                            let session = URLSession.shared
                                            let task = session.dataTask(with: request, completionHandler: { data, response, error -> Void in
                                                do {
                                                    _ = try JSONSerialization.jsonObject(with: data!) as! Dictionary<String, AnyObject>
                                                    print("Uploaded initial parameters successfully for -----> \(name)")
                                                } catch {
                                                    print(error.localizedDescription)
                                                }
                                            })
                                            defaults.setValue(params, forKey: name)
                                            
                                            task.resume()
                                            
                                    }
                                }
                            }
                        } catch {
                            print(error.localizedDescription)
                        }
                    }
                }
            }
        }
        
        task.resume()
    }
}
    


@available(iOS 13.0, *)
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}





