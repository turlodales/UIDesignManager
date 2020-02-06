//
//  ZUILabel.swift
//  UIDesignManager
//
//  Created by Zivato on 16/09/2019.
//

import UIKit

open class ZUIView: UIView {
    
    let defaults = UserDefaults.standard
    
    var isHorizontallyCentred = false
    var isVerticallyCentred = false
    
    var inactiveColourString = ""
    var inactiveCornerRadius = 0
    
    
    
    override init (frame : CGRect) {
        super.init(frame : frame)
        
    }
    
    open func configure(name: String, source: UIViewController, sourceParent: UIView, left: CGFloat? = nil, right: CGFloat? = nil, top: CGFloat? = nil, bottom: CGFloat? = nil, fixedWidth: CGFloat? = nil, fixedHeight: CGFloat? = nil, centerX: Bool, centerY: Bool) {
        
        print("\(#line) ran")
        
        
        let configuration = name
        
        if (self.layer.backgroundColor) == nil {
            self.layer.backgroundColor = generateRandomPastelColor(withMixedColor: UIColor.blue).cgColor
        }
        
        if (self.layer.backgroundColor) == nil {
            self.layer.backgroundColor = generateRandomPastelColor(withMixedColor: UIColor.blue).cgColor
        }
        
        inactiveColourString = UIColor(cgColor: self.layer.backgroundColor!).hexString(.d6)
        inactiveCornerRadius = Int(self.layer.cornerRadius)
        
        
        if let config = defaults.value(forKey: name) as? [String: Any] {
            if let status = config["active"] as? Bool {
                if status == true {
                    if let bgColour = config["bgColour"] as? String {
                        DispatchQueue.main.async {
                            self.layer.backgroundColor = hexStringToUIColor(hex: bgColour).cgColor
                            
                            if bgColour == "clear" {
                                self.layer.backgroundColor = UIColor.clear.cgColor
                            }
                        }
                    }
                    
                    if let cornerRadius = config["cornerRadius"] as? CGFloat {
                        if cornerRadius > 0 {
                            
                            DispatchQueue.main.async {
                                self.layer.cornerRadius = cornerRadius
                                self.layer.masksToBounds = true
                            }
                        }
                    }
                    
                    if let vConstraints = config["vConstraints"] as? String {
                        if let hConstraints = config["hConstraints"] as? String {
                            
                            //handle center
                            DispatchQueue.main.async {
                                self.translatesAutoresizingMaskIntoConstraints = false
                                sourceParent.addConstraints( NSLayoutConstraint.constraints(withVisualFormat: hConstraints, options: [], metrics: nil, views: ["self":self]))
                                sourceParent.addConstraints( NSLayoutConstraint.constraints(withVisualFormat: vConstraints, options: [], metrics: nil, views: ["self":self]))
                                
                                if let centerVertically = config["centerVertically"] as? Bool {
                                    if let centerHorizontally = config["centerHorizontally"] as? Bool {
                                        
                                        if centerHorizontally == true {
                                            self.centerYAnchor.constraint(equalTo: sourceParent.centerYAnchor).isActive = true
                                        }
                                        if centerVertically == true {
                                            self.centerXAnchor.constraint(equalTo: sourceParent.centerXAnchor).isActive = true
                                        }
                                    }
                                }
                            }
                        }
                    }
                    
                    if let cornerRadius = config["cornerRadius"] as? CGFloat {
                        DispatchQueue.main.async {
                            self.layer.cornerRadius = cornerRadius
                            self.layer.masksToBounds = true
                        }
                    }
                } else {
                    self.revertToStoryboardUI(name: name, source: source, sourceParent: sourceParent, left: left, right: right, top: top, bottom: bottom, fixedWidth: fixedWidth, fixedHeight: fixedHeight, centerX: centerX, centerY: centerY)
                }
            }
        }
        
        
        let url = URL(string: "https://uidesignmanager.herokuapp.com/v1/getasset/id/\(name)/\(appId)")!
        print("\(#line) \(url)")
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        
        request.httpMethod = "GET"
        
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("error: \(error)")
            } else {
                if let response = response as? HTTPURLResponse {
                    print("statusCode: \(response.statusCode)")
                    
                    if let data = data, let dataString = String(data: data, encoding: .utf8) {
                        
                        let data = dataString.data(using: .utf8)!
                        do{
                            let responseObject = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String:AnyObject]
                            
                            if let dataObject = responseObject!["data"] as? [String : AnyObject]{
                                print("the datobject is \(dataObject)")
                                if let components = dataObject["components"] as? NSArray{
                                    
                                    if components.count != 0{
                                        let jsonData = components[0] as! [String : AnyObject]
                                        self.defaults.setValue(jsonData, forKey: configuration)
                                        if let status = jsonData["active"] as? Bool{
                                            if status == true {
                                                if let color = jsonData["bgColour"] as? String{
                                                    if let cR = jsonData["cornerRadius"] as? CGFloat{
                                                        DispatchQueue.main.async {
                                                            self.backgroundColor = hexStringToUIColor(hex: color)
                                                            
                                                            if color == "clear" {
                                                                self.layer.backgroundColor = UIColor.clear.cgColor
                                                            }
                                                            
                                                            if cR > 0 {
                                                                self.layer.cornerRadius = cR
                                                                self.layer.masksToBounds = true
                                                            }
                                                        }
                                                    }
                                                }
                                                if let cornerRadius = jsonData["cornerRadius"] as? CGFloat {
                                                    DispatchQueue.main.async {
                                                        self.layer.cornerRadius = cornerRadius
                                                        self.layer.masksToBounds = true
                                                    }
                                                }
                                                if let vConstraints = jsonData["vConstraints"] as? String {
                                                    if let hConstraints = jsonData["hConstraints"] as? String {
                                                        DispatchQueue.main.async {
                                                            self.translatesAutoresizingMaskIntoConstraints = false
                                                            sourceParent.addConstraints( NSLayoutConstraint.constraints(withVisualFormat: hConstraints, options: [], metrics: nil, views: ["self":self]))
                                                            sourceParent.addConstraints( NSLayoutConstraint.constraints(withVisualFormat: vConstraints, options: [], metrics: nil, views: ["self":self]))
                                                            
                                                            if let centerVertically = jsonData["centerVertically"] as? Bool {
                                                                if let centerHorizontally = jsonData["centerHorizontally"] as? Bool {
                                                                    if centerHorizontally == true {
                                                                        self.centerYAnchor.constraint(equalTo: sourceParent.centerYAnchor).isActive = true
                                                                    }
                                                                    if centerVertically == true {
                                                                        self.centerXAnchor.constraint(equalTo: sourceParent.centerXAnchor).isActive = true
                                                                    }
                                                                }
                                                            }
                                                        }
                                                    }
                                                }
                                            }else {
                                                self.revertToStoryboardUI(name: name, source: source, sourceParent: sourceParent, left: left, right: right, top: top, bottom: bottom, fixedWidth: fixedWidth, fixedHeight: fixedHeight, centerX: centerX, centerY: centerY)
                                            }
                                        }
                                    }else if components.count == 0{
                                        DispatchQueue.main.async {
                                            //uploads the initial config
                                            var params = [String : AnyObject]()
                                            
                                            let url = URL(string: "https://uidesignmanager.herokuapp.com/v1/assets")!
                                            var request = URLRequest(url: url)
                                            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                                            
                                            
                                            request.httpMethod = "POST"
                                            
                                            let screen = String(describing: type(of: source))
                                            let timestamp = NSDate().timeIntervalSince1970
                                            var hConstraints = ""
                                            var vConstraints = ""
                                            var h1 = "H:"
                                            var h2 = "[self]"
                                            var h3 = ""
                                            var v1 = "V:"
                                            var v2 = "[self]"
                                            var v3 = ""
                                            if centerY == true {
                                                v1 = "V:"
                                                v2 = "[self(\(fixedHeight!))]"
                                                v3 = ""
                                                self.isHorizontallyCentred = true
                                            }
                                            
                                            if centerX == true {
                                                h1 = "H:"
                                                h2 = "[self(\(fixedWidth!))]"
                                                h3 = ""
                                                self.isVerticallyCentred = true
                                            }
                                            
                                            if top != nil { v1 = "V:|-\(top!)-" }
                                            if bottom != nil { v3 = "-\(bottom!)-|" }
                                            if right != nil { h3 = "-\(right!)-|" }
                                            if left != nil { h1 = "H:|-\(left!)-" }
                                            if fixedWidth != nil { h2 = "[self(\(fixedWidth!))]" }
                                            if fixedHeight != nil { v2 = "[self(\(fixedHeight!))]" }
                                            
                                            hConstraints = h1 + h2 + h3
                                            vConstraints = v1 + v2 + v3
                                            
                                            var bgColorString = UIColor(cgColor: self.layer.backgroundColor!).hexString(.d6)
                                            
                                            if self.layer.backgroundColor == UIColor.clear.cgColor{
                                                bgColorString = "clear"
                                            }
                                            
                                            
                                            params["title_id"] = name as AnyObject
                                            params["bundle_id"] = appId as AnyObject
                                            params["fontName"] = "ff" as AnyObject;
                                            params["fontSize"] = 0 as AnyObject
                                            params["textValue"] = "ff" as AnyObject;
                                            params["bgColour"] = bgColorString as AnyObject;
                                            params["textColour"] = "ff" as AnyObject;
                                            params["textBgColour"] = "ff" as AnyObject;
                                            params["textAlignment"] = 0 as AnyObject;
                                            params["hConstraints"] = hConstraints as AnyObject;
                                            params["vConstraints"] = vConstraints as AnyObject;
                                            params["color"] = "" as AnyObject;
                                            params["cornerRadius"] = 0 as AnyObject;
                                            params["type"] = "UIView" as AnyObject;
                                            params["source"] = screen as AnyObject;
                                            params["timestamp"] = timestamp as AnyObject;
                                            params["name"] = configuration as AnyObject;
                                            params["contentMode"] = "f" as AnyObject;
                                            params["active"] = "1" as AnyObject;
                                            params["centerHorizontally"] = self.isHorizontallyCentred as AnyObject;
                                            params["centerVertically"] = self.isVerticallyCentred as AnyObject;
                                            params["imagedata"] = "fff" as AnyObject;
                                            
                                            
                                            request.httpBody = try? JSONSerialization.data(withJSONObject: params, options: [])
                                            
                                            let session = URLSession.shared
                                            let task = session.dataTask(with: request, completionHandler: { data, response, error -> Void in
                                                print(response!)
                                                do {
                                                    let json = try JSONSerialization.jsonObject(with: data!) as! Dictionary<String, AnyObject>
                                                    print("json data is \(json)")
                                                } catch {
                                                    print("error")
                                                }
                                            })
                                            
                                            print("params are \(params)")
                                            
                                            self.defaults.setValue(params, forKey: name)
                                            self.setInitial(sourceParent: sourceParent, json: params)
                                            
                                            task.resume()
                                        }
                                    }
                                }
                            }
                        }catch {
                            print(error.localizedDescription)
                        }
                    }
                }
            }
            
        }
        task.resume()
    }
    
    
    
    func revertToStoryboardUI(name: String, source: UIViewController, sourceParent: UIView, left: CGFloat? = nil, right: CGFloat? = nil, top: CGFloat? = nil, bottom: CGFloat? = nil, fixedWidth: CGFloat? = nil, fixedHeight: CGFloat? = nil, centerX: Bool, centerY: Bool) {
        DispatchQueue.main.async {
            let screen = String(describing: type(of: source))
            let configuration = name
            let colorString = self.inactiveColourString
            let timestamp = NSDate().timeIntervalSince1970
            var json = [String: Any]()
            var hConstraints = ""
            var vConstraints = ""
            var h1 = "H:"
            var h2 = "[self]"
            var h3 = ""
            var v1 = "V:"
            var v2 = "[self]"
            var v3 = ""
            if centerY == true {
                v1 = "V:"
                v2 = "[self(\(fixedHeight!))]"
                v3 = ""
                self.isHorizontallyCentred = true
            }
            
            if centerX == true {
                h1 = "H:"
                h2 = "[self(\(fixedWidth!))]"
                h3 = ""
                self.isVerticallyCentred = true
            }
            
            if top != nil { v1 = "V:|-\(top!)-" }
            if bottom != nil { v3 = "-\(bottom!)-|" }
            if right != nil { h3 = "-\(right!)-|" }
            if left != nil { h1 = "H:|-\(left!)-" }
            if fixedWidth != nil { h2 = "[self(\(fixedWidth!))]" }
            if fixedHeight != nil { v2 = "[self(\(fixedHeight!))]" }
            
            hConstraints = h1 + h2 + h3
            vConstraints = v1 + v2 + v3
            
            json = [ "hConstraints" : hConstraints, "vConstraints" : vConstraints, "cornerRadius": self.inactiveCornerRadius, "bgColour":colorString, "type": "UIView", "source":screen, "timestamp":timestamp, "name":configuration, "centerHorizontally" : self.isHorizontallyCentred, "centerVertically" : self.isVerticallyCentred, "active" : true]
            
            self.setInitial(sourceParent: sourceParent, json: json)
        }
    }
    
    func setInitial(sourceParent: UIView, json: [String: Any]) {
        print("handling con")
        let config = json
        if let bgColour = config["bgColour"] as? String {
            DispatchQueue.main.async {
                print("handling con \(bgColour)")
                self.layer.backgroundColor = hexStringToUIColor(hex: bgColour).cgColor
            }
        }
        
        if let cornerRadius = config["cornerRadius"] as? CGFloat {
            if cornerRadius > 0 {
                
                DispatchQueue.main.async {
                    self.layer.cornerRadius = cornerRadius
                    self.layer.masksToBounds = true
                }
            }
        }
        
        if let vConstraints = config["vConstraints"] as? String {
            if let hConstraints = config["hConstraints"] as? String {
                
                //handle center
                DispatchQueue.main.async {
                    self.removeAllConstraints()
                    
                    self.translatesAutoresizingMaskIntoConstraints = false
                    sourceParent.addConstraints( NSLayoutConstraint.constraints(withVisualFormat: hConstraints, options: [], metrics: nil, views: ["self":self]))
                    sourceParent.addConstraints( NSLayoutConstraint.constraints(withVisualFormat: vConstraints, options: [], metrics: nil, views: ["self":self]))
                    
                    if let centerVertically = config["centerVertically"] as? Bool {
                        if let centerHorizontally = config["centerHorizontally"] as? Bool {
                            
                            if centerHorizontally == true {
                                self.centerYAnchor.constraint(equalTo: sourceParent.centerYAnchor).isActive = true
                            }
                            if centerVertically == true {
                                self.centerXAnchor.constraint(equalTo: sourceParent.centerXAnchor).isActive = true
                            }
                        }
                    }
                }
            }
        }
        
        if let cornerRadius = config["cornerRadius"] as? CGFloat {
            DispatchQueue.main.async {
                self.layer.cornerRadius = cornerRadius
                self.layer.masksToBounds = true
            }
        }
        
    }
    
    func uploadData(configuration: String, source: String, type: String, json: [String: Any]) {
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        let jsonString = String(data: jsonData!, encoding: .utf8)!
        let url = URL(string: "http://data.uidesignmanager.com/post.php")!
        var request = URLRequest(url: url)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        let parameters = "appId=\(appId)&name=\(configuration)&json=\(jsonString)"
        print("code \(parameters)")
        request.httpBody = parameters.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            if let responseJSON = responseJSON as? [String: Any] {
                print(responseJSON)
            }
        }
        task.resume()
    }
    
    func generateRandomPastelColor(withMixedColor mixColor: UIColor?) -> UIColor {
        // Randomly generate number in closure
        let randomColorGenerator = { ()-> CGFloat in
            CGFloat(arc4random() % 256 ) / 256
        }
        
        var red: CGFloat = randomColorGenerator()
        var green: CGFloat = randomColorGenerator()
        var blue: CGFloat = randomColorGenerator()
        
        // Mix the color
        if let mixColor = mixColor {
            var mixRed: CGFloat = 0, mixGreen: CGFloat = 0, mixBlue: CGFloat = 0;
            mixColor.getRed(&mixRed, green: &mixGreen, blue: &mixBlue, alpha: nil)
            
            red = (red + mixRed) / 2;
            green = (green + mixGreen) / 2;
            blue = (blue + mixBlue) / 2;
        }
        
        return UIColor(red: red, green: green, blue: blue, alpha: 1)
    }
    
    convenience init() {
        self.init(frame: CGRect.zero)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

extension UIColor {
    enum HexFormat {
        case RGB
        case ARGB
        case RGBA
        case RRGGBB
        case AARRGGBB
        case RRGGBBAA
    }
    
    enum HexDigits {
        case d3, d4, d6, d8
    }
    
    func hexString(_ format: HexFormat = .RRGGBBAA) -> String {
        let maxi = [.RGB, .ARGB, .RGBA].contains(format) ? 16 : 256
        
        func toI(_ f: CGFloat) -> Int {
            return min(maxi - 1, Int(CGFloat(maxi) * f))
        }
        
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        
        self.getRed(&r, green: &g, blue: &b, alpha: &a)
        
        let ri = toI(r)
        let gi = toI(g)
        let bi = toI(b)
        let ai = toI(a)
        
        switch format {
        case .RGB:       return String(format: "#%X%X%X", ri, gi, bi)
        case .ARGB:      return String(format: "#%X%X%X%X", ai, ri, gi, bi)
        case .RGBA:      return String(format: "#%X%X%X%X", ri, gi, bi, ai)
        case .RRGGBB:    return String(format: "#%02X%02X%02X", ri, gi, bi)
        case .AARRGGBB:  return String(format: "#%02X%02X%02X%02X", ai, ri, gi, bi)
        case .RRGGBBAA:  return String(format: "#%02X%02X%02X%02X", ri, gi, bi, ai)
        }
    }
    
    func hexString(_ digits: HexDigits) -> String {
        switch digits {
        case .d3: return hexString(.RGB)
        case .d4: return hexString(.RGBA)
        case .d6: return hexString(.RRGGBB)
        case .d8: return hexString(.RRGGBBAA)
        }
    }
}

public func hexStringToUIColor (hex:String) -> UIColor {
    var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
    
    cString = cString.replacingOccurrences(of: "\"", with: "")
    
    if (cString.hasPrefix("#")) {
        cString.remove(at: cString.startIndex)
    }
    print(cString.count)
    if ((cString.count) != 6) {
        return UIColor.clear
    }
    
    var rgbValue:UInt64 = 0
    Scanner(string: cString).scanHexInt64(&rgbValue)
    
    return UIColor(
        red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
        green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
        blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
        alpha: CGFloat(1.0)
    )
}

func uploadData(configuration: String, type: String, json: [String: Any]) {
    let jsonData = try? JSONSerialization.data(withJSONObject: json)
    let jsonString = String(data: jsonData!, encoding: .utf8)!
    let url = URL(string: "http://data.uidesignmanager.com/post.php")!
    var request = URLRequest(url: url)
    request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
    request.httpMethod = "POST"
    let parameters = "appId=\(appId)&name=\(configuration)&json=\(jsonString)"
    print("code \(parameters)")
    request.httpBody = parameters.data(using: .utf8)
    let task = URLSession.shared.dataTask(with: request) { data, response, error in
        guard let data = data, error == nil else {
            print(error?.localizedDescription ?? "No data")
            return
        }
        let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
        if let responseJSON = responseJSON as? [String: Any] {
            print(responseJSON)
        }
    }
    task.resume()
}

public func setUIViewColor (name: String, source: UIViewController, initialColor: UIColor, view: UIView) {
    
    
    let defaults = UserDefaults.standard
    var returnedColor = initialColor
    
    if let config = defaults.value(forKey: name) as? [String: Any] {
        if let status = config["active"] as? Bool {
            if status == true {
                if let bgColour = config["color"] as? String {
                    DispatchQueue.main.async {
                        returnedColor = hexStringToUIColor(hex: bgColour)
                        view.layer.backgroundColor = returnedColor.cgColor
                    }
                }
            }else{
                view.layer.backgroundColor = initialColor.cgColor
            }
        }
    }
    
    let url = URL(string: "https://uidesignmanager.herokuapp.com/v1/getasset/id/\(name)/\(appId)")!
    print("\(#line) \(url)")
    var request = URLRequest(url: url)
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    
    
    request.httpMethod = "GET"
    
    let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
        if let error = error {
            print("error: \(error)")
        } else {
            if let response = response as? HTTPURLResponse {
                print("statusCode: \(response.statusCode)")
                
                if let data = data, let dataString = String(data: data, encoding: .utf8) {
                    
                    let data = dataString.data(using: .utf8)!
                    do{
                        let responseObject = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String:AnyObject]
                        
                        if let dataObject = responseObject!["data"] as? [String : AnyObject]{
                            print("to check no of comps \(dataObject)")
                            if let components = dataObject["components"] as? NSArray{
                                if components.count != 0{
                                    var jsonData = components[0] as! [String : AnyObject]
                                    jsonData["hConstraints"] = "" as AnyObject
                                    jsonData["vConstraints"] = "" as AnyObject
                                    UserDefaults.standard.setValue(jsonData, forKey: name)
                                    if let status = jsonData["active"] as? Bool{
                                        if status == true {
                                            if let color = jsonData["color"] as? String{
                                                DispatchQueue.main.async {
                                                    returnedColor = hexStringToUIColor(hex: color)
                                                    
                                                    view.layer.backgroundColor = returnedColor.cgColor
                                                }
                                            }
                                        }else{
                                            view.layer.backgroundColor = initialColor.cgColor
                                        }
                                    }
                                } else if components.count == 0{
                                    DispatchQueue.main.async {
                                        //uploads the initial config
                                        var params = [String : AnyObject]()
                                        
                                        let url = URL(string: "https://uidesignmanager.herokuapp.com/v1/assets")!
                                        var request = URLRequest(url: url)
                                        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                                        
                                        
                                        request.httpMethod = "POST"
                                        
                                        
                                        
                                        let colorString = initialColor.hexString(.d6)
                                        
                                        let timestamp = NSDate().timeIntervalSince1970
                                        
                                        let json: [String: Any] = ["color":colorString, "timestamp":timestamp, "name":name, "type": "UIColor", "active" : true]
                                        let jsonData = try? JSONSerialization.data(withJSONObject: json)
                                        
                                        params["title_id"] = name as AnyObject
                                        params["bundle_id"] = appId as AnyObject
                                        params["fontName"] = "" as AnyObject;
                                        params["fontSize"] = 0 as AnyObject
                                        params["textValue"] = "" as AnyObject;
                                        params["textColour"] = "" as AnyObject;
                                        params["textBgColour"] = "" as AnyObject;
                                        params["textAlignment"] = 0 as AnyObject;
                                        //params["hConstraints"] = "" as AnyObject;
                                        //params["vConstraints"] = "" as AnyObject;
                                        params["color"] = colorString as AnyObject;
                                        params["bgColour"] = "" as AnyObject;
                                        params["cornerRadius"] = 0 as AnyObject;
                                        params["type"] = "UIColor" as AnyObject;
                                        params["source"] = "" as AnyObject;
                                        params["timestamp"] = timestamp as AnyObject;
                                        params["name"] = name as AnyObject;
                                        params["contentMode"] = "" as AnyObject;
                                        params["active"] = true as AnyObject;
                                        params["centerHorizontally"] = false as AnyObject;
                                        params["centerVertically"] = false as AnyObject;
                                        params["imagedata"] = "" as AnyObject;
                                        
                                        defaults.setValue(jsonData, forKey: name)
                                        
                                        //uploadData(configuration: name, type: "UIColor", json: json)
                                        
                                        returnedColor = initialColor
                                        view.layer.backgroundColor = returnedColor.cgColor
                                        
                                        request.httpBody = try? JSONSerialization.data(withJSONObject: params, options: [])
                                        
                                        let session = URLSession.shared
                                        let task = session.dataTask(with: request, completionHandler: { data, response, error -> Void in
                                            do {
                                                _ = try JSONSerialization.jsonObject(with: data!) as! Dictionary<String, AnyObject>
                                            } catch {
                                                print("error")
                                            }
                                        })
                                        
                                        defaults.setValue(params, forKey: name)
                                        //self.setInitial(sourceParent: sourceParent, json: params)
                                        
                                        task.resume()
                                    }
                                }
                            }
                            
                        }
                        
                    }catch {
                        print(error.localizedDescription)
                    }
                }
            }
        }
    }
    
    task.resume()
}

public func setUIImageViewColor (name: String, source: UIViewController, initialColor: UIColor, view: UIImageView) {
    
    
    let defaults = UserDefaults.standard
    var returnedColor = initialColor
    
    if let config = defaults.value(forKey: name) as? [String: Any] {
        if let status = config["active"] as? Bool {
            if status == true {
                if let bgColour = config["color"] as? String {
                    DispatchQueue.main.async {
                        returnedColor = hexStringToUIColor(hex: bgColour)
                        view.layer.backgroundColor = returnedColor.cgColor
                    }
                }
            }else{
                view.layer.backgroundColor = initialColor.cgColor
            }
        }
    }
    
    let url = URL(string: "https://uidesignmanager.herokuapp.com/v1/getasset/id/\(name)/\(appId)")!
    print("\(#line) \(url)")
    var request = URLRequest(url: url)
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    
    
    request.httpMethod = "GET"
    
    let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
        if let error = error {
            print("error: \(error)")
        } else {
            if let response = response as? HTTPURLResponse {
                print("statusCode: \(response.statusCode)")
                
                if let data = data, let dataString = String(data: data, encoding: .utf8) {
                    
                    let data = dataString.data(using: .utf8)!
                    do{
                        let responseObject = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String:AnyObject]
                        
                        if let dataObject = responseObject!["data"] as? [String : AnyObject]{
                            print("to check no of comps \(dataObject)")
                            if let components = dataObject["components"] as? NSArray{
                                if components.count != 0{
                                    var jsonData = components[0] as! [String : AnyObject]
                                    jsonData["hConstraints"] = "" as AnyObject
                                    jsonData["vConstraints"] = "" as AnyObject
                                    UserDefaults.standard.setValue(jsonData, forKey: name)
                                    if let status = jsonData["active"] as? Bool{
                                        if status == true {
                                            if let color = jsonData["color"] as? String{
                                                DispatchQueue.main.async {
                                                    returnedColor = hexStringToUIColor(hex: color)
                                                    
                                                    view.layer.backgroundColor = returnedColor.cgColor
                                                }
                                            }
                                        }else{
                                            view.layer.backgroundColor = initialColor.cgColor
                                        }
                                    }
                                } else if components.count == 0{
                                    DispatchQueue.main.async {
                                        //uploads the initial config
                                        var params = [String : AnyObject]()
                                        
                                        let url = URL(string: "https://uidesignmanager.herokuapp.com/v1/assets")!
                                        var request = URLRequest(url: url)
                                        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                                        
                                        
                                        request.httpMethod = "POST"
                                        
                                        
                                        
                                        let colorString = initialColor.hexString(.d6)
                                        
                                        let timestamp = NSDate().timeIntervalSince1970
                                        
                                        let json: [String: Any] = ["color":colorString, "timestamp":timestamp, "name":name, "type": "UIColor", "active" : true]
                                        let jsonData = try? JSONSerialization.data(withJSONObject: json)
                                        
                                        params["title_id"] = name as AnyObject
                                        params["bundle_id"] = appId as AnyObject
                                        params["fontName"] = "" as AnyObject;
                                        params["fontSize"] = 0 as AnyObject
                                        params["textValue"] = "" as AnyObject;
                                        params["textColour"] = "" as AnyObject;
                                        params["textBgColour"] = "" as AnyObject;
                                        params["textAlignment"] = 0 as AnyObject;
                                        //params["hConstraints"] = "" as AnyObject;
                                        //params["vConstraints"] = "" as AnyObject;
                                        params["color"] = colorString as AnyObject;
                                        params["bgColour"] = "" as AnyObject;
                                        params["cornerRadius"] = 0 as AnyObject;
                                        params["type"] = "UIColor" as AnyObject;
                                        params["source"] = "" as AnyObject;
                                        params["timestamp"] = timestamp as AnyObject;
                                        params["name"] = name as AnyObject;
                                        params["contentMode"] = "" as AnyObject;
                                        params["active"] = true as AnyObject;
                                        params["centerHorizontally"] = false as AnyObject;
                                        params["centerVertically"] = false as AnyObject;
                                        params["imagedata"] = "" as AnyObject;
                                        
                                        
                                        
                                        defaults.setValue(jsonData, forKey: name)
                                        
                                        //uploadData(configuration: name, type: "UIColor", json: json)
                                        
                                        returnedColor = initialColor
                                        view.layer.backgroundColor = returnedColor.cgColor
                                        
                                        request.httpBody = try? JSONSerialization.data(withJSONObject: params, options: [])
                                        
                                        let session = URLSession.shared
                                        let task = session.dataTask(with: request, completionHandler: { data, response, error -> Void in
                                            do {
                                                _ = try JSONSerialization.jsonObject(with: data!) as! Dictionary<String, AnyObject>
                                            } catch {
                                                print("error")
                                            }
                                        })
                                        
                                        defaults.setValue(params, forKey: name)
                                        //self.setInitial(sourceParent: sourceParent, json: params)
                                        
                                        task.resume()
                                    }
                                }
                            }
                            
                        }
                        
                    }catch {
                        print(error.localizedDescription)
                    }
                }
            }
        }
    }
    
    task.resume()
}

public func setUIButtonBgColor (name: String, source: UIViewController, initialColor: UIColor, view: UIButton) {
    
    
    let defaults = UserDefaults.standard
    var returnedColor = initialColor
    
    if let config = defaults.value(forKey: name) as? [String: Any] {
        if let status = config["active"] as? Bool {
            if status == true {
                if let bgColour = config["color"] as? String {
                    DispatchQueue.main.async {
                        returnedColor = hexStringToUIColor(hex: bgColour)
                        view.layer.backgroundColor = returnedColor.cgColor
                    }
                }
            }else{
                view.layer.backgroundColor = initialColor.cgColor
            }
        }
    }
    
    let url = URL(string: "https://uidesignmanager.herokuapp.com/v1/getasset/id/\(name)/\(appId)")!
    print("\(#line) \(url)")
    var request = URLRequest(url: url)
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    
    
    request.httpMethod = "GET"
    
    let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
        if let error = error {
            print("error: \(error)")
        } else {
            if let response = response as? HTTPURLResponse {
                print("statusCode: \(response.statusCode)")
                
                if let data = data, let dataString = String(data: data, encoding: .utf8) {
                    
                    let data = dataString.data(using: .utf8)!
                    do{
                        let responseObject = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String:AnyObject]
                        
                        if let dataObject = responseObject!["data"] as? [String : AnyObject]{
                            print("to check no of comps \(dataObject)")
                            if let components = dataObject["components"] as? NSArray{
                                if components.count != 0{
                                    var jsonData = components[0] as! [String : AnyObject]
                                    jsonData["hConstraints"] = "" as AnyObject
                                    jsonData["vConstraints"] = "" as AnyObject
                                    UserDefaults.standard.setValue(jsonData, forKey: name)
                                    if let status = jsonData["active"] as? Bool{
                                        if status == true {
                                            if let color = jsonData["color"] as? String{
                                                DispatchQueue.main.async {
                                                    returnedColor = hexStringToUIColor(hex: color)
                                                    
                                                    view.layer.backgroundColor = returnedColor.cgColor
                                                }
                                            }
                                        }else{
                                            view.layer.backgroundColor = initialColor.cgColor
                                        }
                                    }
                                } else if components.count == 0{
                                    DispatchQueue.main.async {
                                        //uploads the initial config
                                        var params = [String : AnyObject]()
                                        
                                        let url = URL(string: "https://uidesignmanager.herokuapp.com/v1/assets")!
                                        var request = URLRequest(url: url)
                                        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                                        
                                        
                                        request.httpMethod = "POST"
                                        
                                        
                                        
                                        let colorString = initialColor.hexString(.d6)
                                        
                                        let timestamp = NSDate().timeIntervalSince1970
                                        
                                        let json: [String: Any] = ["color":colorString, "timestamp":timestamp, "name":name, "type": "UIColor", "active" : true]
                                        let jsonData = try? JSONSerialization.data(withJSONObject: json)
                                        
                                        
                                        params["title_id"] = name as AnyObject
                                        params["bundle_id"] = appId as AnyObject
                                        params["fontName"] = "" as AnyObject;
                                        params["fontSize"] = 0 as AnyObject
                                        params["textValue"] = "" as AnyObject;
                                        params["textColour"] = "" as AnyObject;
                                        params["textBgColour"] = "" as AnyObject;
                                        params["textAlignment"] = 0 as AnyObject;
                                        //params["hConstraints"] = "" as AnyObject;
                                        //params["vConstraints"] = "" as AnyObject;
                                        params["color"] = colorString as AnyObject;
                                        params["bgColour"] = "" as AnyObject;
                                        params["cornerRadius"] = 0 as AnyObject;
                                        params["type"] = "UIColor" as AnyObject;
                                        params["source"] = "" as AnyObject;
                                        params["timestamp"] = timestamp as AnyObject;
                                        params["name"] = name as AnyObject;
                                        params["contentMode"] = "" as AnyObject;
                                        params["active"] = true as AnyObject;
                                        params["centerHorizontally"] = false as AnyObject;
                                        params["centerVertically"] = false as AnyObject;
                                        params["imagedata"] = "" as AnyObject;
                                        
                                        
                                        defaults.setValue(jsonData, forKey: name)
                                        
                                        //uploadData(configuration: name, type: "UIColor", json: json)
                                        
                                        returnedColor = initialColor
                                        view.layer.backgroundColor = returnedColor.cgColor
                                        
                                        request.httpBody = try? JSONSerialization.data(withJSONObject: params, options: [])
                                        
                                        let session = URLSession.shared
                                        let task = session.dataTask(with: request, completionHandler: { data, response, error -> Void in
                                            do {
                                                _ = try JSONSerialization.jsonObject(with: data!) as! Dictionary<String, AnyObject>
                                            } catch {
                                                print("error")
                                            }
                                        })
                                        
                                        defaults.setValue(params, forKey: name)
                                        //self.setInitial(sourceParent: sourceParent, json: params)
                                        
                                        task.resume()
                                    }
                                }
                            }
                            
                        }
                        
                    }catch {
                        print(error.localizedDescription)
                    }
                }
            }
        }
    }
    
    task.resume()
}

public func setUIButtonTitleColor (name: String, source: UIViewController, initialColor: UIColor, view: UIButton) {
    
    
    let defaults = UserDefaults.standard
    var returnedColor = initialColor
    
    if let config = defaults.value(forKey: name) as? [String: Any] {
        if let status = config["active"] as? Bool {
            if status == true {
                if let bgColour = config["color"] as? String {
                    DispatchQueue.main.async {
                        returnedColor = hexStringToUIColor(hex: bgColour)
                        view.layer.backgroundColor = returnedColor.cgColor
                    }
                }
            }else{
                view.layer.backgroundColor = initialColor.cgColor
            }
        }
    }
    
    let url = URL(string: "https://uidesignmanager.herokuapp.com/v1/getasset/id/\(name)/\(appId)")!
    print("\(#line) \(url)")
    var request = URLRequest(url: url)
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    
    
    request.httpMethod = "GET"
    
    let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
        if let error = error {
            print("error: \(error)")
        } else {
            if let response = response as? HTTPURLResponse {
                print("statusCode: \(response.statusCode)")
                
                if let data = data, let dataString = String(data: data, encoding: .utf8) {
                    
                    let data = dataString.data(using: .utf8)!
                    do{
                        let responseObject = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String:AnyObject]
                        
                        if let dataObject = responseObject!["data"] as? [String : AnyObject]{
                            print("to check no of comps \(dataObject)")
                            if let components = dataObject["components"] as? NSArray{
                                if components.count != 0{
                                    var jsonData = components[0] as! [String : AnyObject]
                                    jsonData["hConstraints"] = "" as AnyObject
                                    jsonData["vConstraints"] = "" as AnyObject
                                    UserDefaults.standard.setValue(jsonData, forKey: name)
                                    if let status = jsonData["active"] as? Bool{
                                        if status == true {
                                            if let color = jsonData["color"] as? String{
                                                DispatchQueue.main.async {
                                                    returnedColor = hexStringToUIColor(hex: color)
                                                    
                                                    view.layer.backgroundColor = returnedColor.cgColor
                                                }
                                            }
                                        }else{
                                            view.layer.backgroundColor = initialColor.cgColor
                                        }
                                    }
                                } else if components.count == 0{
                                    DispatchQueue.main.async {
                                        //uploads the initial config
                                        var params = [String : AnyObject]()
                                        
                                        let url = URL(string: "https://uidesignmanager.herokuapp.com/v1/assets")!
                                        var request = URLRequest(url: url)
                                        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                                        
                                        
                                        request.httpMethod = "POST"
                                        
                                        
                                        
                                        let colorString = initialColor.hexString(.d6)
                                        
                                        let timestamp = NSDate().timeIntervalSince1970
                                        
                                        let json: [String: Any] = ["color":colorString, "timestamp":timestamp, "name":name, "type": "UIColor", "active" : true]
                                        let jsonData = try? JSONSerialization.data(withJSONObject: json)
                                        
                                        params["title_id"] = name as AnyObject
                                        params["bundle_id"] = appId as AnyObject
                                        params["fontName"] = "" as AnyObject;
                                        params["fontSize"] = 0 as AnyObject
                                        params["textValue"] = "" as AnyObject;
                                        params["textColour"] = "" as AnyObject;
                                        params["textBgColour"] = "" as AnyObject;
                                        params["textAlignment"] = 0 as AnyObject;
                                        //params["hConstraints"] = "" as AnyObject;
                                        //params["vConstraints"] = "" as AnyObject;
                                        params["color"] = colorString as AnyObject;
                                        params["bgColour"] = "" as AnyObject;
                                        params["cornerRadius"] = 0 as AnyObject;
                                        params["type"] = "UIColor" as AnyObject;
                                        params["source"] = "" as AnyObject;
                                        params["timestamp"] = timestamp as AnyObject;
                                        params["name"] = name as AnyObject;
                                        params["contentMode"] = "" as AnyObject;
                                        params["active"] = true as AnyObject;
                                        params["centerHorizontally"] = false as AnyObject;
                                        params["centerVertically"] = false as AnyObject;
                                        params["imagedata"] = "" as AnyObject;
                                        
                                        
                                        
                                        defaults.setValue(jsonData, forKey: name)
                                        
                                        //uploadData(configuration: name, type: "UIColor", json: json)
                                        
                                        returnedColor = initialColor
                                        view.layer.backgroundColor = returnedColor.cgColor
                                        
                                        request.httpBody = try? JSONSerialization.data(withJSONObject: params, options: [])
                                        
                                        let session = URLSession.shared
                                        let task = session.dataTask(with: request, completionHandler: { data, response, error -> Void in
                                            do {
                                                _ = try JSONSerialization.jsonObject(with: data!) as! Dictionary<String, AnyObject>
                                            } catch {
                                                print("error")
                                            }
                                        })
                                        
                                        defaults.setValue(params, forKey: name)
                                        //self.setInitial(sourceParent: sourceParent, json: params)
                                        
                                        task.resume()
                                    }
                                }
                            }
                            
                        }
                        
                    }catch {
                        print(error.localizedDescription)
                    }
                }
            }
        }
    }
    
    task.resume()
}

public func setUILabelBgColor (name: String, source: UIViewController, initialColor: UIColor, view: UILabel) {
    
    
    let defaults = UserDefaults.standard
    var returnedColor = initialColor
    
    if let config = defaults.value(forKey: name) as? [String: Any] {
        if let status = config["active"] as? Bool {
            if status == true {
                if let bgColour = config["color"] as? String {
                    DispatchQueue.main.async {
                        returnedColor = hexStringToUIColor(hex: bgColour)
                        view.layer.backgroundColor = returnedColor.cgColor
                    }
                }
            }else{
                view.layer.backgroundColor = initialColor.cgColor
            }
        }
    }
    
    let url = URL(string: "https://uidesignmanager.herokuapp.com/v1/getasset/id/\(name)/\(appId)")!
    print("\(#line) \(url)")
    var request = URLRequest(url: url)
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    
    
    request.httpMethod = "GET"
    
    let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
        if let error = error {
            print("error: \(error)")
        } else {
            if let response = response as? HTTPURLResponse {
                print("statusCode: \(response.statusCode)")
                
                if let data = data, let dataString = String(data: data, encoding: .utf8) {
                    
                    let data = dataString.data(using: .utf8)!
                    do{
                        let responseObject = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String:AnyObject]
                        
                        if let dataObject = responseObject!["data"] as? [String : AnyObject]{
                            print("to check no of comps \(dataObject)")
                            if let components = dataObject["components"] as? NSArray{
                                if components.count != 0{
                                    var jsonData = components[0] as! [String : AnyObject]
                                    jsonData["hConstraints"] = "" as AnyObject
                                    jsonData["vConstraints"] = "" as AnyObject
                                    UserDefaults.standard.setValue(jsonData, forKey: name)
                                    if let status = jsonData["active"] as? Bool{
                                        if status == true {
                                            if let color = jsonData["color"] as? String{
                                                DispatchQueue.main.async {
                                                    returnedColor = hexStringToUIColor(hex: color)
                                                    
                                                    view.layer.backgroundColor = returnedColor.cgColor
                                                }
                                            }
                                        }else{
                                            view.layer.backgroundColor = initialColor.cgColor
                                        }
                                    }
                                } else if components.count == 0{
                                    DispatchQueue.main.async {
                                        //uploads the initial config
                                        var params = [String : AnyObject]()
                                        
                                        let url = URL(string: "https://uidesignmanager.herokuapp.com/v1/assets")!
                                        var request = URLRequest(url: url)
                                        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                                        
                                        
                                        request.httpMethod = "POST"
                                        
                                        
                                        
                                        let colorString = initialColor.hexString(.d6)
                                        
                                        let timestamp = NSDate().timeIntervalSince1970
                                        
                                        let json: [String: Any] = ["color":colorString, "timestamp":timestamp, "name":name, "type": "UIColor", "active" : true]
                                        let jsonData = try? JSONSerialization.data(withJSONObject: json)
                                        
                                        
                                        params["title_id"] = name as AnyObject
                                        params["bundle_id"] = appId as AnyObject
                                        params["fontName"] = "" as AnyObject;
                                        params["fontSize"] = 0 as AnyObject
                                        params["textValue"] = "" as AnyObject;
                                        params["textColour"] = "" as AnyObject;
                                        params["textBgColour"] = "" as AnyObject;
                                        params["textAlignment"] = 0 as AnyObject;
                                        //params["hConstraints"] = "" as AnyObject;
                                        //params["vConstraints"] = "" as AnyObject;
                                        params["color"] = colorString as AnyObject;
                                        params["bgColour"] = "" as AnyObject;
                                        params["cornerRadius"] = 0 as AnyObject;
                                        params["type"] = "UIColor" as AnyObject;
                                        params["source"] = "" as AnyObject;
                                        params["timestamp"] = timestamp as AnyObject;
                                        params["name"] = name as AnyObject;
                                        params["contentMode"] = "" as AnyObject;
                                        params["active"] = true as AnyObject;
                                        params["centerHorizontally"] = false as AnyObject;
                                        params["centerVertically"] = false as AnyObject;
                                        params["imagedata"] = "" as AnyObject;
                                        
                                        
                                        
                                        defaults.setValue(jsonData, forKey: name)
                                        
                                        //uploadData(configuration: name, type: "UIColor", json: json)
                                        
                                        returnedColor = initialColor
                                        view.layer.backgroundColor = returnedColor.cgColor
                                        
                                        request.httpBody = try? JSONSerialization.data(withJSONObject: params, options: [])
                                        
                                        let session = URLSession.shared
                                        let task = session.dataTask(with: request, completionHandler: { data, response, error -> Void in
                                            do {
                                                _ = try JSONSerialization.jsonObject(with: data!) as! Dictionary<String, AnyObject>
                                            } catch {
                                                print("error")
                                            }
                                        })
                                        
                                        defaults.setValue(params, forKey: name)
                                        //self.setInitial(sourceParent: sourceParent, json: params)
                                        
                                        task.resume()
                                    }
                                }
                            }
                            
                        }
                        
                    }catch {
                        print(error.localizedDescription)
                    }
                }
            }
        }
    }
    
    task.resume()
}

public func setUILabelTextColor (name: String, source: UIViewController, initialColor: UIColor, view: UILabel) {
    
    
    let defaults = UserDefaults.standard
    var returnedColor = initialColor
    
    if let config = defaults.value(forKey: name) as? [String: Any] {
        if let status = config["active"] as? Bool {
            if status == true {
                if let bgColour = config["color"] as? String {
                    DispatchQueue.main.async {
                        returnedColor = hexStringToUIColor(hex: bgColour)
                        view.layer.backgroundColor = returnedColor.cgColor
                    }
                }
            }else{
                view.layer.backgroundColor = initialColor.cgColor
            }
        }
    }
    
    let url = URL(string: "https://uidesignmanager.herokuapp.com/v1/getasset/id/\(name)/\(appId)")!
    print("\(#line) \(url)")
    var request = URLRequest(url: url)
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    
    
    request.httpMethod = "GET"
    
    let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
        if let error = error {
            print("error: \(error)")
        } else {
            if let response = response as? HTTPURLResponse {
                print("statusCode: \(response.statusCode)")
                
                if let data = data, let dataString = String(data: data, encoding: .utf8) {
                    
                    let data = dataString.data(using: .utf8)!
                    do{
                        let responseObject = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String:AnyObject]
                        
                        if let dataObject = responseObject!["data"] as? [String : AnyObject]{
                            print("to check no of comps \(dataObject)")
                            if let components = dataObject["components"] as? NSArray{
                                if components.count != 0{
                                    var jsonData = components[0] as! [String : AnyObject]
                                    jsonData["hConstraints"] = "" as AnyObject
                                    jsonData["vConstraints"] = "" as AnyObject
                                    UserDefaults.standard.setValue(jsonData, forKey: name)
                                    if let status = jsonData["active"] as? Bool{
                                        if status == true {
                                            if let color = jsonData["color"] as? String{
                                                DispatchQueue.main.async {
                                                    returnedColor = hexStringToUIColor(hex: color)
                                                    
                                                    view.layer.backgroundColor = returnedColor.cgColor
                                                }
                                            }
                                        }else{
                                            view.layer.backgroundColor = initialColor.cgColor
                                        }
                                    }
                                } else if components.count == 0{
                                    DispatchQueue.main.async {
                                        //uploads the initial config
                                        var params = [String : AnyObject]()
                                        
                                        let url = URL(string: "https://uidesignmanager.herokuapp.com/v1/assets")!
                                        var request = URLRequest(url: url)
                                        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                                        
                                        
                                        request.httpMethod = "POST"
                                        
                                        
                                        
                                        let colorString = initialColor.hexString(.d6)
                                        
                                        let timestamp = NSDate().timeIntervalSince1970
                                        
                                        let json: [String: Any] = ["color":colorString, "timestamp":timestamp, "name":name, "type": "UIColor", "active" : true]
                                        let jsonData = try? JSONSerialization.data(withJSONObject: json)
                                        
                                        
                                        params["title_id"] = name as AnyObject
                                        params["bundle_id"] = appId as AnyObject
                                        params["fontName"] = "" as AnyObject;
                                        params["fontSize"] = 0 as AnyObject
                                        params["textValue"] = "" as AnyObject;
                                        params["textColour"] = "" as AnyObject;
                                        params["textBgColour"] = "" as AnyObject;
                                        params["textAlignment"] = 0 as AnyObject;
                                        //params["hConstraints"] = "" as AnyObject;
                                        //params["vConstraints"] = "" as AnyObject;
                                        params["color"] = colorString as AnyObject;
                                        params["bgColour"] = "" as AnyObject;
                                        params["cornerRadius"] = 0 as AnyObject;
                                        params["type"] = "UIColor" as AnyObject;
                                        params["source"] = "" as AnyObject;
                                        params["timestamp"] = timestamp as AnyObject;
                                        params["name"] = name as AnyObject;
                                        params["contentMode"] = "" as AnyObject;
                                        params["active"] = true as AnyObject;
                                        params["centerHorizontally"] = false as AnyObject;
                                        params["centerVertically"] = false as AnyObject;
                                        params["imagedata"] = "" as AnyObject;
                                        
                                        
                                        
                                        defaults.setValue(jsonData, forKey: name)
                                        
                                        //uploadData(configuration: name, type: "UIColor", json: json)
                                        
                                        returnedColor = initialColor
                                        view.layer.backgroundColor = returnedColor.cgColor
                                        
                                        request.httpBody = try? JSONSerialization.data(withJSONObject: params, options: [])
                                        
                                        let session = URLSession.shared
                                        let task = session.dataTask(with: request, completionHandler: { data, response, error -> Void in
                                            do {
                                                _ = try JSONSerialization.jsonObject(with: data!) as! Dictionary<String, AnyObject>
                                            } catch {
                                                print("error")
                                            }
                                        })
                                        
                                        defaults.setValue(params, forKey: name)
                                        //self.setInitial(sourceParent: sourceParent, json: params)
                                        
                                        task.resume()
                                    }
                                }
                            }
                            
                        }
                        
                    }catch {
                        print(error.localizedDescription)
                    }
                }
            }
        }
    }
    
    task.resume()
}

public func setUITextViewBgColor (name: String, source: UIViewController, initialColor: UIColor, view: UITextView) {
    
    
    let defaults = UserDefaults.standard
    var returnedColor = initialColor
    
    if let config = defaults.value(forKey: name) as? [String: Any] {
        if let status = config["active"] as? Bool {
            if status == true {
                if let bgColour = config["color"] as? String {
                    DispatchQueue.main.async {
                        returnedColor = hexStringToUIColor(hex: bgColour)
                        view.layer.backgroundColor = returnedColor.cgColor
                    }
                }
            }else{
                view.layer.backgroundColor = initialColor.cgColor
            }
        }
    }
    
    let url = URL(string: "https://uidesignmanager.herokuapp.com/v1/getasset/id/\(name)/\(appId)")!
    print("\(#line) \(url)")
    var request = URLRequest(url: url)
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    
    
    request.httpMethod = "GET"
    
    let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
        if let error = error {
            print("error: \(error)")
        } else {
            if let response = response as? HTTPURLResponse {
                print("statusCode: \(response.statusCode)")
                
                if let data = data, let dataString = String(data: data, encoding: .utf8) {
                    
                    let data = dataString.data(using: .utf8)!
                    do{
                        let responseObject = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String:AnyObject]
                        
                        if let dataObject = responseObject!["data"] as? [String : AnyObject]{
                            print("to check no of comps \(dataObject)")
                            if let components = dataObject["components"] as? NSArray{
                                if components.count != 0{
                                    var jsonData = components[0] as! [String : AnyObject]
                                    jsonData["hConstraints"] = "" as AnyObject
                                    jsonData["vConstraints"] = "" as AnyObject
                                    UserDefaults.standard.setValue(jsonData, forKey: name)
                                    if let status = jsonData["active"] as? Bool{
                                        if status == true {
                                            if let color = jsonData["color"] as? String{
                                                DispatchQueue.main.async {
                                                    returnedColor = hexStringToUIColor(hex: color)
                                                    
                                                    view.layer.backgroundColor = returnedColor.cgColor
                                                }
                                            }
                                        }else{
                                            view.layer.backgroundColor = initialColor.cgColor
                                        }
                                    }
                                } else if components.count == 0{
                                    DispatchQueue.main.async {
                                        //uploads the initial config
                                        var params = [String : AnyObject]()
                                        
                                        let url = URL(string: "https://uidesignmanager.herokuapp.com/v1/assets")!
                                        var request = URLRequest(url: url)
                                        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                                        
                                        
                                        request.httpMethod = "POST"
                                        
                                        
                                        
                                        let colorString = initialColor.hexString(.d6)
                                        
                                        let timestamp = NSDate().timeIntervalSince1970
                                        
                                        let json: [String: Any] = ["color":colorString, "timestamp":timestamp, "name":name, "type": "UIColor", "active" : true]
                                        let jsonData = try? JSONSerialization.data(withJSONObject: json)
                                        
                                        
                                        params["title_id"] = name as AnyObject
                                        params["bundle_id"] = appId as AnyObject
                                        params["fontName"] = "" as AnyObject;
                                        params["fontSize"] = 0 as AnyObject
                                        params["textValue"] = "" as AnyObject;
                                        params["textColour"] = "" as AnyObject;
                                        params["textBgColour"] = "" as AnyObject;
                                        params["textAlignment"] = 0 as AnyObject;
                                        //params["hConstraints"] = "" as AnyObject;
                                        //params["vConstraints"] = "" as AnyObject;
                                        params["color"] = colorString as AnyObject;
                                        params["bgColour"] = "" as AnyObject;
                                        params["cornerRadius"] = 0 as AnyObject;
                                        params["type"] = "UIColor" as AnyObject;
                                        params["source"] = "" as AnyObject;
                                        params["timestamp"] = timestamp as AnyObject;
                                        params["name"] = name as AnyObject;
                                        params["contentMode"] = "" as AnyObject;
                                        params["active"] = true as AnyObject;
                                        params["centerHorizontally"] = false as AnyObject;
                                        params["centerVertically"] = false as AnyObject;
                                        params["imagedata"] = "" as AnyObject;
                                        
                                        
                                        
                                        defaults.setValue(jsonData, forKey: name)
                                        
                                        //uploadData(configuration: name, type: "UIColor", json: json)
                                        
                                        returnedColor = initialColor
                                        view.layer.backgroundColor = returnedColor.cgColor
                                        
                                        request.httpBody = try? JSONSerialization.data(withJSONObject: params, options: [])
                                        
                                        let session = URLSession.shared
                                        let task = session.dataTask(with: request, completionHandler: { data, response, error -> Void in
                                            do {
                                                _ = try JSONSerialization.jsonObject(with: data!) as! Dictionary<String, AnyObject>
                                            } catch {
                                                print("error")
                                            }
                                        })
                                        
                                        defaults.setValue(params, forKey: name)
                                        //self.setInitial(sourceParent: sourceParent, json: params)
                                        
                                        task.resume()
                                    }
                                }
                            }
                            
                        }
                        
                    }catch {
                        print(error.localizedDescription)
                    }
                }
            }
        }
    }
    
    task.resume()
}

public func setUITextViewTextColor (name: String, source: UIViewController, initialColor: UIColor, view: UITextView) {
    
    
    let defaults = UserDefaults.standard
    var returnedColor = initialColor
    
    if let config = defaults.value(forKey: name) as? [String: Any] {
        if let status = config["active"] as? Bool {
            if status == true {
                if let bgColour = config["color"] as? String {
                    DispatchQueue.main.async {
                        returnedColor = hexStringToUIColor(hex: bgColour)
                        view.layer.backgroundColor = returnedColor.cgColor
                    }
                }
            }else{
                view.layer.backgroundColor = initialColor.cgColor
            }
        }
    }
    
    let url = URL(string: "https://uidesignmanager.herokuapp.com/v1/getasset/id/\(name)/\(appId)")!
    print("\(#line) \(url)")
    var request = URLRequest(url: url)
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    
    
    request.httpMethod = "GET"
    
    let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
        if let error = error {
            print("error: \(error)")
        } else {
            if let response = response as? HTTPURLResponse {
                print("statusCode: \(response.statusCode)")
                
                if let data = data, let dataString = String(data: data, encoding: .utf8) {
                    
                    let data = dataString.data(using: .utf8)!
                    do{
                        let responseObject = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String:AnyObject]
                        
                        if let dataObject = responseObject!["data"] as? [String : AnyObject]{
                            print("to check no of comps \(dataObject)")
                            if let components = dataObject["components"] as? NSArray{
                                if components.count != 0{
                                    var jsonData = components[0] as! [String : AnyObject]
                                    jsonData["hConstraints"] = "" as AnyObject
                                    jsonData["vConstraints"] = "" as AnyObject
                                    UserDefaults.standard.setValue(jsonData, forKey: name)
                                    if let status = jsonData["active"] as? Bool{
                                        if status == true {
                                            if let color = jsonData["color"] as? String{
                                                DispatchQueue.main.async {
                                                    returnedColor = hexStringToUIColor(hex: color)
                                                    
                                                    view.layer.backgroundColor = returnedColor.cgColor
                                                }
                                            }
                                        }else{
                                            view.layer.backgroundColor = initialColor.cgColor
                                        }
                                    }
                                } else if components.count == 0{
                                    DispatchQueue.main.async {
                                        //uploads the initial config
                                        var params = [String : AnyObject]()
                                        
                                        let url = URL(string: "https://uidesignmanager.herokuapp.com/v1/assets")!
                                        var request = URLRequest(url: url)
                                        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                                        
                                        
                                        request.httpMethod = "POST"
                                        
                                        
                                        
                                        let colorString = initialColor.hexString(.d6)
                                        
                                        let timestamp = NSDate().timeIntervalSince1970
                                        
                                        
                                        params["title_id"] = name as AnyObject
                                        params["bundle_id"] = appId as AnyObject
                                        params["fontName"] = "" as AnyObject;
                                        params["fontSize"] = 0 as AnyObject
                                        params["textValue"] = "" as AnyObject;
                                        params["textColour"] = "" as AnyObject;
                                        params["textBgColour"] = "" as AnyObject;
                                        params["textAlignment"] = 0 as AnyObject;
                                        //params["hConstraints"] = "" as AnyObject;
                                        //params["vConstraints"] = "" as AnyObject;
                                        params["color"] = colorString as AnyObject;
                                        params["bgColour"] = "" as AnyObject;
                                        params["cornerRadius"] = 0 as AnyObject;
                                        params["type"] = "UIColor" as AnyObject;
                                        params["source"] = "" as AnyObject;
                                        params["timestamp"] = timestamp as AnyObject;
                                        params["name"] = name as AnyObject;
                                        params["contentMode"] = "" as AnyObject;
                                        params["active"] = true as AnyObject;
                                        params["centerHorizontally"] = false as AnyObject;
                                        params["centerVertically"] = false as AnyObject;
                                        params["imagedata"] = "" as AnyObject;
                                        
                                        
                                        
                                        returnedColor = initialColor
                                        view.layer.backgroundColor = returnedColor.cgColor
                                        
                                        request.httpBody = try? JSONSerialization.data(withJSONObject: params, options: [])
                                        
                                        let session = URLSession.shared
                                        let task = session.dataTask(with: request, completionHandler: { data, response, error -> Void in
                                            do {
                                                let json = try JSONSerialization.jsonObject(with: data!) as! Dictionary<String, AnyObject>
                                                print("color upload success \(json), \(params)")
                                            } catch {
                                                print("error")
                                            }
                                        })
                                        
                                        defaults.setValue(params, forKey: name)
                                        //self.setInitial(sourceParent: sourceParent, json: params)
                                        
                                        task.resume()
                                    }
                                }
                            }
                            
                        }
                        
                    }catch {
                        print(error.localizedDescription)
                    }
                }
            }
        }
    }
    
    task.resume()
    
}

extension NSLayoutConstraint.Attribute {
    func toString() -> String {
        switch self {
        case .left:
            return "left"
        case .right:
            return "right"
        case .top:
            return "top"
        case .bottom:
            return "bottom"
        case .leading:
            return "leading"
        case .trailing:
            return "trailing"
        case .width:
            return "width"
        case .height:
            return "height"
        case .centerX:
            return "centerX"
        case .centerY:
            return "centerY"
        case .lastBaseline:
            return "lastBaseline"
        case .firstBaseline:
            return "firstBaseline"
        case .leftMargin:
            return "leftMargin"
        case .rightMargin:
            return "rightMargin"
        case .topMargin:
            return "topMargin"
        case .bottomMargin:
            return "bottomMargin"
        case .leadingMargin:
            return "leadingMargin"
        case .trailingMargin:
            return "trailingMargin"
        case .centerXWithinMargins:
            return "centerXWithinMargins"
        case .centerYWithinMargins:
            return "centerYWithinMargins"
        case .notAnAttribute:
            return "notAnAttribute"
        @unknown default:
            fatalError()
        }
    }
}

extension UIView {
    // retrieves all constraints that mention the view
    func getAllConstraints() -> [NSLayoutConstraint] {
        
        // array will contain self and all superviews
        var views = [self]
        
        // get all superviews
        var view = self
        while let superview = view.superview {
            views.append(superview)
            view = superview
        }
        
        // transform views to constraints and filter only those
        // constraints that include the view itself
        return views.flatMap({ $0.constraints }).filter { constraint in
            return constraint.firstItem as? UIView == self ||
                constraint.secondItem as? UIView == self
        }
    }
}



extension UIView {
    
    public func removeAllConstraints() {
        var _superview = self.superview
        
        while let superview = _superview {
            for constraint in superview.constraints {
                
                if let first = constraint.firstItem as? UIView, first == self {
                    superview.removeConstraint(constraint)
                }
                
                if let second = constraint.secondItem as? UIView, second == self {
                    superview.removeConstraint(constraint)
                }
            }
            
            _superview = superview.superview
        }
        
        self.removeConstraints(self.constraints)
        self.translatesAutoresizingMaskIntoConstraints = true
    }
}
