//
//  ZUILabel.swift
//  UIDesignManager
//
//  Created by Zivato on 16/09/2019.
//

import UIKit

open class ZUIButton: UIButton {
    
    let defaults = UserDefaults.standard
    var isVerticallyCentered = false
    var isHorizontallyCentered = false
    var inactiveBackgroundColorString = ""
    var inactiveTextColorString = ""
    var inactiveTextValue = ""
    var inactiveTextAlignment = 0
    var inactiveCornerRadius = 0
    var inactiveFontName = ""
    var inactiveFontSize = 0
    var inactiveImageString = ""
    
    override init (frame : CGRect) {
        super.init(frame : frame)
    }
    
    func convertBase64ToImage(imageString: String) -> UIImage {
        let imageData = Data(base64Encoded: imageString, options: Data.Base64DecodingOptions.ignoreUnknownCharacters)!
        return UIImage(data: imageData) ?? UIImage()
    }
    
    open func configure(name: String, source: UIViewController, sourceParent: UIView, left: CGFloat? = nil, right: CGFloat? = nil, top: CGFloat? = nil, bottom: CGFloat? = nil, fixedWidth: CGFloat? = nil, fixedHeight: CGFloat? = nil, centerX: Bool, centerY: Bool) {
        if (self.backgroundColor) == nil {
            self.backgroundColor = generateRandomPastelColor(withMixedColor: UIColor.systemPink)
        }
        
        if (self.titleLabel?.textColor) == nil {
            self.titleLabel?.textColor = UIColor.white
            self.setTitleColor(UIColor.black, for: .normal)
        }
        
        if (self.titleLabel?.text) == nil {
            self.setTitle(" ", for: .normal)
        }
        
        if (self.titleLabel!.font.fontName) == ".SFUI-Regular" {
            self.titleLabel!.font = UIFont(name: "Avenir-Oblique", size: 12)
        }
        
        inactiveBackgroundColorString = self.backgroundColor!.hexString(.d6)
        inactiveTextColorString = (self.titleColor(for: .normal)?.hexString(.d6))!
        inactiveTextValue = self.titleLabel!.text!
        inactiveTextAlignment = (self.titleLabel?.textAlignment.rawValue)!
        inactiveCornerRadius = Int(self.layer.cornerRadius)
        inactiveFontName = self.titleLabel?.font.fontName ?? ""
        inactiveFontSize = Int((self.titleLabel?.font.pointSize)!)
        inactiveImageString = self.backgroundImage(for: .normal)?.pngData()?.base64EncodedString(options: .lineLength64Characters) ?? ""
        
        
        
        if let imgData = defaults.value(forKey: "\(name)_id\(appId).png") as? String {
            DispatchQueue.main.async {
                let image = self.convertBase64ToImage(imageString: imgData)
                self.setBackgroundImage(image, for: .normal)
            }
        }
        
        let configuration = name
        
        
        if let config = defaults.value(forKey: name) as? [String: Any] {
            if let status = config["active"] as? Bool {
                if status == true {
                    if let fontName = config["fontName"] as? String {
                        if let fontSize = config["fontSize"] as? CGFloat {
                            DispatchQueue.main.async {
                                self.titleLabel?.font = UIFont(name: fontName, size: fontSize)
                                
                            }
                        }
                    }
                    
                    if let titleValue = config["textValue"] as? String {
                        if let titleColour = config["textColour"] as? String {
                            if let titleAlignment = config["textAlignment"] as? Int {
                                if let titleBgColour = config["textBgColour"] as? String {
                                    
                                    DispatchQueue.main.async {
                                        self.setTitle(titleValue, for: .normal)
                                        self.setTitleColor(hexStringToUIColor(hex: titleColour), for: .normal)
                                        self.backgroundColor = hexStringToUIColor(hex: titleBgColour)
                                        
                                        if titleColour == "clear" {
                                            self.setTitleColor(UIColor.clear, for: .normal)
                                        }
                                        
                                        if titleBgColour == "clear" {
                                            self.backgroundColor = UIColor.clear
                                        }
                                        
                                        
                                        if titleAlignment == 1{
                                            self.titleLabel?.textAlignment = .center
                                        } else if titleAlignment == 4{
                                            self.titleLabel?.textAlignment = .left
                                        } else if titleAlignment == 2{
                                            self.titleLabel?.textAlignment = .right
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
                                        
                                        if let status = jsonData["active"] as? Bool {
                                            if status == true {
                                                if let fontName = jsonData["fontName"] as? String {
                                                    if let fontSize = jsonData["fontSize"] as? CGFloat {
                                                        DispatchQueue.main.async {
                                                            self.titleLabel?.font = UIFont(name: fontName, size: fontSize)
                                                        }
                                                    }
                                                }
                                                
                                                if let titleValue = jsonData["textValue"] as? String {
                                                    if let titleColour = jsonData["textColour"] as? String {
                                                        if let titleAlignment = jsonData["textAlignment"] as? Int {
                                                            if let titleBgColour = jsonData["textBgColour"] as? String {
                                                                
                                                                DispatchQueue.main.async {
                                                                    
                                                                    self.setTitle(titleValue, for: .normal)
                                                                    self.setTitleColor(hexStringToUIColor(hex: titleColour), for: .normal)
                                                                    self.backgroundColor = hexStringToUIColor(hex: titleBgColour)
                                                                    
                                                                    if titleColour == "clear" {
                                                                        self.setTitleColor(UIColor.clear, for: .normal)
                                                                    }
                                                                    
                                                                    if titleBgColour == "clear" {
                                                                        self.backgroundColor = UIColor.clear
                                                                    }
                                                                    
                                                                    
                                                                    if titleAlignment == 1{
                                                                        self.titleLabel?.textAlignment = .center
                                                                    } else if titleAlignment == 4{
                                                                        self.titleLabel?.textAlignment = .left
                                                                    } else if titleAlignment == 2{
                                                                        self.titleLabel?.textAlignment = .right
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
                                                
                                                if let imageurl = jsonData["imageurl"] as? String{
                                                    DispatchQueue.main.async {
                                                        if let url = URL(string: imageurl) {
                                                            do {
                                                                
                                                                let contents = try String(contentsOf: url)
                                                                let image = self.convertBase64ToImage(imageString: contents)
                                                                self.defaults.setValue(contents, forKey: "\(configuration)_id\(appId).png")
                                                                self.setBackgroundImage(image, for: .normal)
                                                                
                                                            } catch {
                                                                // contents could not be loaded
                                                                self.defaults.setValue(" ", forKey: "\(configuration)_id\(appId).png")
                                                                self.setBackgroundImage(nil, for: .normal)
                                                            }
                                                        }else{
                                                            self.defaults.setValue(" ", forKey: "\(configuration)_id\(appId).png")
                                                            self.setBackgroundImage(nil, for: .normal)
                                                        }
                                                    }
                                                }
                                                
                                            }else{
                                                self.revertToStoryboardUI(name: name, source: source, sourceParent: sourceParent, left: left, right: right, top: top, bottom: bottom, fixedWidth: fixedWidth, fixedHeight: fixedHeight, centerX: centerX, centerY: centerY)
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
                                                self.isHorizontallyCentered = true
                                            }
                                            
                                            if centerX == true {
                                                h1 = "H:"
                                                h2 = "[self(\(fixedWidth!))]"
                                                h3 = ""
                                                self.isVerticallyCentered = true
                                            }
                                            
                                            if top != nil { v1 = "V:|-\(top!)-" }
                                            if bottom != nil { v3 = "-\(bottom!)-|" }
                                            if right != nil { h3 = "-\(right!)-|" }
                                            if left != nil { h1 = "H:|-\(left!)-" }
                                            if fixedWidth != nil { h2 = "[self(\(fixedWidth!))]" }
                                            if fixedHeight != nil { v2 = "[self(\(fixedHeight!))]" }
                                            
                                            hConstraints = h1 + h2 + h3
                                            vConstraints = v1 + v2 + v3
                                            
                                            var textColorString = self.titleLabel!.textColor.hexString(.d6)
                                            var textBgColorString = self.backgroundColor!.hexString(.d6)
                                            
                                            if self.backgroundColor == UIColor.clear{
                                                textBgColorString = "clear"
                                            }
                                            
                                            if self.titleLabel?.textColor == UIColor.clear{
                                                textColorString = "clear"
                                            }
                                            
                                            
                                            params["title_id"] = name as AnyObject
                                            params["bundle_id"] = appId as AnyObject
                                            params["fontName"] = self.titleLabel!.font.fontName as AnyObject;
                                            params["fontSize"] = self.titleLabel!.font.pointSize as AnyObject
                                            params["textValue"] = self.titleLabel!.text! as AnyObject;
                                            params["textColour"] = textColorString as AnyObject;
                                            params["textBgColour"] = textBgColorString as AnyObject;
                                            params["textAlignment"] = "\(self.titleLabel!.textAlignment.rawValue)" as AnyObject;
                                            params["hConstraints"] = hConstraints as AnyObject;
                                            params["vConstraints"] = vConstraints as AnyObject;
                                            params["color"] = "" as AnyObject;
                                            params["bgColour"] = "" as AnyObject;
                                            params["cornerRadius"] = 0 as AnyObject;
                                            params["type"] = "UIButton" as AnyObject;
                                            params["source"] = screen as AnyObject;
                                            params["timestamp"] = timestamp as AnyObject;
                                            params["name"] = configuration as AnyObject;
                                            params["contentMode"] = "" as AnyObject;
                                            params["active"] = true as AnyObject;
                                            params["centerHorizontally"] = self.isHorizontallyCentered as AnyObject;
                                            params["centerVertically"] = self.isVerticallyCentered as AnyObject;
                                            params["imagedata"] = "" as AnyObject;
                                            
                                            
                                            request.httpBody = try? JSONSerialization.data(withJSONObject: params, options: [])
                                            
                                            let session = URLSession.shared
                                            let task = session.dataTask(with: request, completionHandler: { data, response, error -> Void in
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
                self.isHorizontallyCentered = true
            }
            
            if centerX == true {
                h1 = "H:"
                h2 = "[self(\(fixedWidth!))]"
                h3 = ""
                self.isVerticallyCentered = true
            }
            
            
            self.defaults.setValue("", forKey: "\(name)_id\(appId).png")
            
            if top != nil { v1 = "V:|-\(top!)-" }
            if bottom != nil { v3 = "-\(bottom!)-|" }
            if right != nil { h3 = "-\(right!)-|" }
            if left != nil { h1 = "H:|-\(left!)-" }
            if fixedWidth != nil { h2 = "[self(\(fixedWidth!))]" }
            if fixedHeight != nil { v2 = "[self(\(fixedHeight!))]" }
            
            hConstraints = h1 + h2 + h3
            vConstraints = v1 + v2 + v3
            
            let textColorString = self.inactiveTextColorString
            var textBgColorString = self.inactiveBackgroundColorString
            
            if textBgColorString == "#000000" && textColorString == "#000000" {
                textBgColorString = "#FFFFFF"
            }
            
            
            json = ["fontName": self.inactiveFontName, "fontSize": self.inactiveFontSize, "textValue": self.inactiveTextValue, "textColour": textColorString, "textBgColour": textBgColorString, "textAlignment" : "\(self.inactiveTextAlignment)", "hConstraints" : hConstraints, "vConstraints" : vConstraints, "cornerRadius": 0, "type": "UIButton", "source":screen, "timestamp":timestamp, "name":configuration, "active" : true, "centerHorizontally" : self.isHorizontallyCentered, "centerVertically": self.isVerticallyCentered, "imageString": self.inactiveImageString]
            
            self.setInitial(sourceParent: sourceParent, json: json)
        }
    }
    
    
    func setInitial(sourceParent: UIView, json: [String: Any]) {
        print("handling con")
        let config = json
        
        if let imageString = config["imageString"] as? String {
            if imageString != ""{
                let image = self.convertBase64ToImage(imageString: imageString)
                self.setBackgroundImage(image, for: .normal)
            }else{
                self.setBackgroundImage(nil, for: .normal)
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
        
        if let textValue = config["textValue"] as? String {
            if let textColour = config["textColour"] as? String {
                if let textAlignment = config["textAlignment"] as? String {
                    if let textBgColour = config["textBgColour"] as? String {
                        
                        DispatchQueue.main.async {
                            
                            self.setTitle(textValue, for: .normal)
                            self.titleLabel?.textColor = hexStringToUIColor(hex: textColour)
                            self.backgroundColor = hexStringToUIColor(hex: textBgColour)
                            
                            if textAlignment == "1"{
                                self.titleLabel?.textAlignment = .center
                            } else if textAlignment == "4"{
                                self.titleLabel?.textAlignment = .left
                            } else if textAlignment == "2"{
                                self.titleLabel?.textAlignment = .right
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
    
    convenience init() {
        self.init(frame: CGRect.zero)
        
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}



