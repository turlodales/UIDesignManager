//
//  ZUILabel.swift
//  UIDesignManager
//
//  Created by Zivato on 16/09/2019.
//

import UIKit



open class ZUILabel: UILabel {
    //initWithFrame to init view from code
    
    let defaults = UserDefaults.standard
    
    let appID = "\(Bundle.main.bundleIdentifier!)".replacingOccurrences(of: ".", with: "", options: NSString.CompareOptions.literal, range: nil)
    
    var isHorizontallyCentred = false
    var isVerticallyCentred = false
    
    
    override init (frame : CGRect) {
        super.init(frame : frame)
        
        if (self.layer.backgroundColor) == nil {
            self.layer.backgroundColor = generateRandomPastelColor(withMixedColor: UIColor.blue).cgColor
        }
        
        if (self.font.fontName) == ".SFUI-Regular" {
            self.font = UIFont(name: "Avenir-Oblique", size: 12)
        }
    }
    
    
    open func configure(name: String, source: UIViewController, sourceParent: UIView, left: CGFloat? = nil, right: CGFloat? = nil, top: CGFloat? = nil, bottom: CGFloat? = nil, fixedWidth: CGFloat? = nil, fixedHeight: CGFloat? = nil, centerX: Bool, centerY: Bool) {
                
        let configuration = name
        
        if (self.layer.backgroundColor) == nil {
            self.layer.backgroundColor = generateRandomPastelColor(withMixedColor: UIColor.blue).cgColor
        }
        
        if (self.font.fontName) == ".SFUI-Regular" {
            self.font = UIFont(name: "Avenir-Oblique", size: self.font.pointSize)
        }
        

        
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
                }else {
                    self.revertToStoryboardUI(name: name, source: source, sourceParent: sourceParent, left: left, right: right, top: top, bottom: bottom, fixedWidth: fixedWidth, fixedHeight: fixedHeight, centerX: centerX, centerY: centerY)
                }
            }
        }
        
        
        let url = URL(string: "http://data.uidesignmanager.com/get.php")!
        var request = URLRequest(url: url)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        let parameters = "appID=\(appID)&name=\(name)"
        request.httpBody = parameters.data(using: .utf8)
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("error: \(error)")
            } else {
                if let response = response as? HTTPURLResponse {
                    print("statusCode: \(response.statusCode)")

                    if let data = data, let dataString = String(data: data, encoding: .utf8) {
                        if dataString.contains("no data") == false {
                            do {
                                
                                if let json = dataString.data(using: String.Encoding.utf8){
                                    if let jsonData = try JSONSerialization.jsonObject(with: json, options: .allowFragments) as? [String:AnyObject]{
                                        self.defaults.setValue(jsonData, forKey: configuration) //puts the configurations in the user defaults as configuration
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
                                    }
                                }
                                
                            } catch {
                                print(error.localizedDescription)
                            }
                            
                        } else if dataString.contains("no data"){
                            DispatchQueue.main.async {
                                //uploads the initial config
                                let screen = String(describing: type(of: source))
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
                                

                                
                                json = ["fontName": self.font.fontName, "fontSize": self.font.pointSize, "textValue": self.text!, "textColour": textColorString!, "textBgColour": textBgColorString, "textAlignment" : "\(self.textAlignment.rawValue)", "hConstraints" : hConstraints, "vConstraints" : vConstraints, "cornerRadius": 0, "type": "UILabel", "source":screen, "timestamp":timestamp, "name":configuration, "active" : true, "centerHorizontally" : self.isHorizontallyCentred, "centerVertically": self.isVerticallyCentred]
                                
                                let jsonData = try? JSONSerialization.data(withJSONObject: json)
                                
                                self.defaults.setValue(jsonData, forKey: configuration)
                                self.setInitial(sourceParent: sourceParent, json: json)
                                self.uploadData(configuration: configuration, source: screen, type: "UIViews", json: json)
                            }
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
        
        let textColorString = self.textColor?.hexString(.d6)
        let textBgColorString = UIColor(cgColor: self.layer.backgroundColor!).cgColor
        
        
            
        
            json = [ "fontName": self.font.fontName, "fontSize": self.font.pointSize, "textValue": self.text!, "textColour": textColorString! , "textBgColour": textBgColorString, "textAlignment" : "\(self.textAlignment.rawValue)", "hConstraints" : hConstraints, "vConstraints" : vConstraints, "cornerRadius": 0, "type": "UILabel", "source":screen, "timestamp":timestamp, "name":configuration, "active" : true, "centerHorizontally" : self.isHorizontallyCentred, "centerVertically": self.isVerticallyCentred]
        
            self.setInitial(sourceParent: sourceParent, json: json)
        }
    }
    
    func setInitial(sourceParent: UIView, json: [String: Any]) {
        print("handling con")
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
        
        
        
    }
    
    
    
    func uploadData(configuration: String, source: String, type: String, json: [String: Any]) {
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        let jsonString = String(data: jsonData!, encoding: .utf8)!
        let url = URL(string: "http://data.uidesignmanager.com/post.php")!
        var request = URLRequest(url: url)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        let parameters = "appID=\(appID)&name=\(configuration)&json=\(jsonString)"
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


