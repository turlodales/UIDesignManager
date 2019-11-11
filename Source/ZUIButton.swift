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
    
override init (frame : CGRect) {
    super.init(frame : frame)
    
    if (self.backgroundColor) == nil {
        self.backgroundColor = generateRandomPastelColor(withMixedColor: UIColor.blue)
    }
    
    if (self.titleLabel?.textColor) == nil {
        self.titleLabel?.textColor = UIColor.white
        self.setTitleColor(UIColor.white, for: .normal)
    }
    
    if (self.titleLabel!.font.fontName) == ".SFUI-Regular" {
        self.titleLabel!.font = UIFont(name: "Avenir-Oblique", size: 12)
    }
    
}

open func configure(name: String, source: UIViewController, sourceParent: UIView, left: CGFloat? = nil, right: CGFloat? = nil, top: CGFloat? = nil, bottom: CGFloat? = nil, fixedWidth: CGFloat? = nil, fixedHeight: CGFloat? = nil, centerX: Bool, centerY: Bool) {
    
    if let imgData = defaults.value(forKey: "\(name)_id\(appId).png") as? NSData {
        DispatchQueue.main.async {
            let loadedImage : UIImage = UIImage(data: imgData as Data)!
            self.setBackgroundImage(loadedImage, for: .normal)
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
    
    let url = URL(string: "http://data.uidesignmanager.com/get.php")!
    var request = URLRequest(url: url)
    request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
    request.httpMethod = "POST"
    let parameters = "appId=\(appId)&name=\(name)"
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
                                                        self.translatesAutoresizingMaskIntoConstraints = false
                                                        sourceParent.addConstraints( NSLayoutConstraint.constraints(withVisualFormat: hConstraints, options: [], metrics: nil, views: ["self":self]))
                                                        sourceParent.addConstraints( NSLayoutConstraint.constraints(withVisualFormat: vConstraints, options: [], metrics: nil, views: ["self":self]))
                                                        //e
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
                                            
                                            if let imageToken = jsonData["imageUrl"] as? String{
                                                DispatchQueue.main.async {
                                                    if imageToken != ""{
                                                      let imageUrl  = "https://firebasestorage.googleapis.com/v0/b/uidesignmanager.appspot.com/o/images%2F%20\(configuration)_id\(appId).png?alt=media&token=\(imageToken)"
                                                      let url = URL(string: imageUrl)
                                                      let data = try? Data(contentsOf: url!)
                                                      
                                                    self.setBackgroundImage(UIImage(data: data!), for: .normal)
                                                      
                                                      self.defaults.setValue(data, forKey: "\(configuration)_id\(appId).png")
                                                    }else {
                                                        self.defaults.setValue(" ", forKey: "\(configuration)_id\(appId).png")
                                                        self.setBackgroundImage(nil, for: .normal)
                                                    }
                                                }
                                            }
                                            
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
                            
                            
                            json = ["fontName": self.titleLabel!.font.fontName, "fontSize": self.titleLabel!.font.pointSize, "textValue": self.titleLabel!.text!, "textColour": textColorString, "textBgColour": textBgColorString, "textAlignment" : "\(self.titleLabel!.textAlignment.rawValue)", "hConstraints" : hConstraints, "vConstraints" : vConstraints, "cornerRadius": 0, "type": "UIButton", "source":screen, "timestamp":timestamp, "name":configuration, "active" : true, "centerHorizontally" : self.isHorizontallyCentered, "centerVertically": self.isVerticallyCentered, "imageUrl": ""]
                            
                           
                            let jsonData = try? JSONSerialization.data(withJSONObject: json)
                            self.defaults.setValue(jsonData, forKey: configuration)
                            self.setInitial(sourceParent: sourceParent, json: json)
                            self.uploadData(configuration: configuration, source: screen, type: "UIButton", json: json)
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
        
        let textColorString = self.titleLabel!.textColor?.hexString(.d6)
        var textBgColorString = self.backgroundColor!.hexString(.d6)
        
        if textBgColorString == "#000000" && textColorString == "#000000" {
            textBgColorString = "#FFFFFF"
        }
        
        
        json = ["fontName": self.titleLabel!.font.fontName, "fontSize": self.titleLabel!.font.pointSize, "textValue": self.titleLabel!.text!, "textColour": textColorString!, "textBgColour": textBgColorString, "textAlignment" : "\(self.titleLabel!.textAlignment.rawValue)", "hConstraints" : hConstraints, "vConstraints" : vConstraints, "cornerRadius": 0, "type": "UIButton", "source":screen, "timestamp":timestamp, "name":configuration, "active" : true, "centerHorizontally" : self.isHorizontallyCentered, "centerVertically": self.isVerticallyCentered, "imageUrl": ""]
        
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

