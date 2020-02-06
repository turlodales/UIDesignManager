//
//  ZUILabel.swift
//  UIDesignManager
//
//  Created by Zivato on 16/09/2019.
//

import UIKit

open class ZUILabel: UILabel {
    
    let defaults = UserDefaults.standard
    
    var isHorizontallyCentred = false
    var isVerticallyCentred = false
    
    
    var inactiveBackgroundColorString = ""
    var inactiveTextColorString = ""
    var inactiveTextValue = ""
    var inactiveTextAlignment = 0
    var inactiveCornerRadius = 0
    var inactiveFontName = ""
    var inactiveFontSize = 0
    
    
    override init (frame : CGRect) {
        super.init(frame : frame)
        
    }
    
    open func configure(name: String, source: UIViewController, sourceParent: UIView, left: CGFloat? = nil, right: CGFloat? = nil, top: CGFloat? = nil, bottom: CGFloat? = nil, fixedWidth: CGFloat? = nil, fixedHeight: CGFloat? = nil, centerX: Bool, centerY: Bool) {
        
        let configuration = name
        
        if (self.layer.backgroundColor) == nil {
            self.layer.backgroundColor = generateRandomPastelColor(withMixedColor: UIColor.blue).cgColor
        }
        
        if (self.font.fontName) == ".SFUI-Regular" {
            self.font = UIFont(name: "Avenir-Oblique", size: self.font.pointSize)
        }
        
        if (self.layer.backgroundColor) == nil {
            self.layer.backgroundColor = generateRandomPastelColor(withMixedColor: UIColor.blue).cgColor
        }
        
        inactiveBackgroundColorString = self.backgroundColor!.hexString(.d6)
        inactiveTextColorString = self.textColor.hexString(.d6)
        inactiveTextValue = self.text ?? ""
        inactiveTextAlignment = self.textAlignment.rawValue
        inactiveCornerRadius = Int(self.layer.cornerRadius)
        inactiveFontName = self.font.fontName
        inactiveFontSize = Int(self.font.pointSize)
        
        
        if let config = defaults.value(forKey: name) as? [String: Any] {
            if let status = config["active"] as? Bool {
                if status == true {
                    if let fontName = config["fontName"] as? String {
                        if let fontSize = config["fontSize"] as? CGFloat {
                            DispatchQueue.main.async {
                                self.font = UIFont(name: fontName, size: fontSize)
                            }
                        }
                    }
                    
                    if let textValue = config["textValue"] as? String {
                        if let textColour = config["textColour"] as? String {
                            if let textAlignment = config["textAlignment"] as? Int {
                                if let textBgColour = config["textBgColour"] as? String {
                                    
                                    DispatchQueue.main.async {
                                        self.text = textValue
                                        self.textColor = hexStringToUIColor(hex: textColour)
                                        self.layer.backgroundColor = hexStringToUIColor(hex: textBgColour).cgColor
                                        
                                        if textBgColour == "clear" {
                                            self.layer.backgroundColor = UIColor.clear.cgColor
                                        }
                                        
                                        if textColour == "clear" {
                                            self.textColor = UIColor.clear
                                        }
                                        
                                        if textAlignment == 1{
                                            self.textAlignment = .center
                                        } else if textAlignment == 4{
                                            self.textAlignment = .left
                                        } else if textAlignment == 2{
                                            self.textAlignment = .right
                                        }
                                    }
                                }
                            }
                        }
                    }
                    
                    
                    if let vConstraints = config["vConstraints"] as? String {
                        if let hConstraints = config["hConstraints"] as? String {
                            DispatchQueue.main.async {
                                self.translatesAutoresizingMaskIntoConstraints = false
                                
                                sourceParent.addConstraints( NSLayoutConstraint.constraints(withVisualFormat: hConstraints, options: [], metrics: nil, views: ["self":self]))
                                sourceParent.addConstraints( NSLayoutConstraint.constraints(withVisualFormat: vConstraints, options: [], metrics: nil, views: ["self":self]))
                                
                                if let centerVertically = config["centerVertically"] as? Int {
                                    if let centerHorizontally = config["centerHorizontally"] as? Int {
                                        
                                        if centerHorizontally == 1 {
                                            self.centerYAnchor.constraint(equalTo: sourceParent.centerYAnchor).isActive = true
                                        }
                                        if centerVertically == 1 {
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
                }else {
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
                                
                                if let components = dataObject["components"] as? NSArray{
                                    if components.count != 0{
                                        let jsonData = components[0] as! [String : AnyObject]
                                        self.defaults.setValue(jsonData, forKey: configuration)
                                        if let status = jsonData["active"] as? Bool{
                                            if status == true {
                                                if let fontName = jsonData["fontName"] as? String {
                                                    if let fontSize = jsonData["fontSize"] as? CGFloat {
                                                        DispatchQueue.main.async {
                                                            self.font = UIFont(name: fontName, size: fontSize)
                                                        }
                                                    }
                                                }
                                                
                                                
                                                if let textValue = jsonData["textValue"] as? String {
                                                    if let textColour = jsonData["textColour"] as? String {
                                                        if let textAlignment = jsonData["textAlignment"] as? Int {
                                                            if let textBgColour = jsonData["textBgColour"] as? String {
                                                                
                                                                DispatchQueue.main.async {
                                                                    self.text = textValue
                                                                    self.textColor = hexStringToUIColor(hex: textColour)
                                                                    self.layer.backgroundColor = hexStringToUIColor(hex: textBgColour).cgColor
                                                                    
                                                                    if textBgColour == "clear" {
                                                                        self.layer.backgroundColor = UIColor.clear.cgColor
                                                                    }
                                                                    
                                                                    if textColour == "clear" {
                                                                        self.textColor = UIColor.clear
                                                                    }
                                                                    
                                                                    if textAlignment == 1{
                                                                        self.textAlignment = .center
                                                                    } else if textAlignment == 4{
                                                                        self.textAlignment = .left
                                                                    } else if textAlignment == 2{
                                                                        self.textAlignment = .right
                                                                    }
                                                                }
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
                                                            self.removeAllConstraints()
                                                            
                                                            self.translatesAutoresizingMaskIntoConstraints = false
                                                            sourceParent.addConstraints( NSLayoutConstraint.constraints(withVisualFormat: hConstraints, options: [], metrics: nil, views: ["self":self]))
                                                            sourceParent.addConstraints( NSLayoutConstraint.constraints(withVisualFormat: vConstraints, options: [], metrics: nil, views: ["self":self]))
                                                            
                                                            if let centerVertically = jsonData["centerVertically"] as? Int {
                                                                if let centerHorizontally = jsonData["centerHorizontally"] as? Int {
                                                                    
                                                                    if centerHorizontally == 1 {
                                                                        self.centerYAnchor.constraint(equalTo: sourceParent.centerYAnchor).isActive = true
                                                                    }
                                                                    if centerVertically == 1 {
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
                                            
                                            if (self.text) == nil {
                                                self.text = "Hello."
                                            }
                                            
                                            var textColorString = self.textColor?.hexString(.d6)
                                            var textBgColorString = UIColor(cgColor: self.layer.backgroundColor!).hexString(.d6)
                                            
                                            if self.layer.backgroundColor == UIColor.clear.cgColor{
                                                textBgColorString = "clear"
                                            }
                                            
                                            if self.textColor == UIColor.clear{
                                                textColorString = "clear"
                                            }
                                            
                                            params["title_id"] = name as AnyObject
                                            params["bundle_id"] = appId as AnyObject
                                            params["fontName"] = self.font.fontName as AnyObject;
                                            params["fontSize"] = self.font.pointSize as AnyObject
                                            params["textValue"] = self.text as AnyObject;
                                            params["bgColour"] = "" as AnyObject;
                                            params["textColour"] = textColorString as AnyObject;
                                            params["textBgColour"] = textBgColorString as AnyObject;
                                            params["textAlignment"] = "\(self.textAlignment.rawValue)" as AnyObject;
                                            params["hConstraints"] = hConstraints as AnyObject;
                                            params["vConstraints"] = vConstraints as AnyObject;
                                            params["color"] = "" as AnyObject;
                                            params["cornerRadius"] = 0 as AnyObject;
                                            params["type"] = "UILabel" as AnyObject;
                                            params["source"] = screen as AnyObject;
                                            params["timestamp"] = timestamp as AnyObject;
                                            params["name"] = configuration as AnyObject;
                                            params["contentMode"] = "" as AnyObject;
                                            params["active"] = true as AnyObject;
                                            params["centerHorizontally"] = self.isHorizontallyCentred as AnyObject;
                                            params["centerVertically"] = self.isVerticallyCentred as AnyObject;
                                            params["imagedata"] = "" as AnyObject;
                                            
                                            
                                            request.httpBody = try? JSONSerialization.data(withJSONObject: params, options: [])
                                            
                                            let session = URLSession.shared
                                            let task = session.dataTask(with: request, completionHandler: { data, response, error -> Void in
                                                print(response!)
                                                do {
                                                    _ = try JSONSerialization.jsonObject(with: data!) as! Dictionary<String, AnyObject>
                                                } catch {
                                                    print("error")
                                                }
                                            })
                                            
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
            let configuration = name
            let timestamp = NSDate().timeIntervalSince1970
            let screen = String(describing: type(of: source))
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
            
            if (self.text) == nil {
                self.text = "Hello."
            }
            
            
            
            
            
            json = [ "fontName": self.inactiveFontName, "fontSize": self.inactiveFontSize, "textValue": self.inactiveTextValue, "textColour": self.inactiveTextColorString , "textBgColour": self.inactiveBackgroundColorString, "textAlignment" : "\(self.inactiveTextAlignment)", "hConstraints" : hConstraints, "vConstraints" : vConstraints, "cornerRadius": self.inactiveCornerRadius, "type": "UILabel", "source":screen, "timestamp":timestamp, "name":configuration, "active" : true, "centerHorizontally" : self.isHorizontallyCentred, "centerVertically": self.isVerticallyCentred]
            
            self.setInitial(sourceParent: sourceParent, json: json)
        }
    }
    
    func setInitial(sourceParent: UIView, json: [String: Any]) {
        let config = json
        
        if let cornerRadius = config["cornerRadius"] as? CGFloat {
            if cornerRadius > 0 {
                
                DispatchQueue.main.async {
                    self.layer.cornerRadius = cornerRadius
                    self.layer.masksToBounds = true
                }
            }
        }
        
        if let textValue = config["textValue"] as? String {
            if let textColour = config["textColour"] as? String {
                if let textAlignment = config["textAlignment"] as? String {
                    if let textBgColour = config["textBgColour"] as? String {
                        
                        DispatchQueue.main.async {
                            
                            self.text = textValue
                            self.textColor = hexStringToUIColor(hex: textColour)
                            self.layer.backgroundColor = hexStringToUIColor(hex: textBgColour).cgColor
                            
                            if textAlignment == "1"{
                                self.textAlignment = .center
                            } else if textAlignment == "4"{
                                self.textAlignment = .left
                            } else if textAlignment == "2"{
                                self.textAlignment = .right
                            }
                            
                        }
                    }
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
        
        
        //need to store an initial config in the user defaults
        
    }
    
    func uploadData(configuration: String, source: String, type: String, json: [String: Any]) {
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        let jsonString = String(data: jsonData!, encoding: .utf8)!
        let url = URL(string: "http://data.uidesignmanager.com/post.php")!
        var request = URLRequest(url: url)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        let parameters = "appId=\(appId)&name=\(configuration)&json=\(jsonString)"
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
