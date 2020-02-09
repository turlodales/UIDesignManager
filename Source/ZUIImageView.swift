//
//  ZUIImageView.swift
//  UIDesignManager
//
//  Created by Zivato Limited on 23/09/2019.
//

import Foundation
import UIKit

open class ZUIImageView: UIImageView {
    
    let defaults = UserDefaults.standard
    
    var isHorizontallyCentered = false
    var isVerticallyCentered = false
    
    var inactiveBackgroundColorString = ""
    var inactiveCornerRadius = 0
    var inactiveImageString = ""
    
    override init (frame : CGRect) {
        super.init(frame : frame)
    }
    
    func convertBase64ToImage(imageString: String) -> UIImage {
        let imageData = Data(base64Encoded: imageString, options: Data.Base64DecodingOptions.ignoreUnknownCharacters)!
        return UIImage(data: imageData) ?? UIImage()
    }
    
    open func configure(name: String, source: UIViewController, sourceParent: UIView, left: CGFloat? = nil, right: CGFloat? = nil, top: CGFloat? = nil, bottom: CGFloat? = nil, fixedWidth: CGFloat? = nil, fixedHeight: CGFloat? = nil, centerX: Bool, centerY: Bool, fallbackImage: String) {
        
        let configuration = name
        
        if self.layer.backgroundColor != nil {
        inactiveBackgroundColorString = UIColor(cgColor: self.layer.backgroundColor!).hexString(.d6)
        }
        
        inactiveCornerRadius = Int(self.layer.cornerRadius)
        inactiveImageString = (UIImage(named: fallbackImage)?.pngData()?.base64EncodedString(options: .lineLength64Characters))!
        
        
        if let imageString = defaults.value(forKey: "\(name)_id\(appId).png") as? String {
            DispatchQueue.main.async {
                let image = self.convertBase64ToImage(imageString: imageString)
                self.image = image
            }
        }
        
        if let config = defaults.value(forKey: name) as? [String: Any] {
            if let status = config["active"] as? Bool {
                if status == true {
                    if let bgColour = config["bgColour"] as? String {
                        DispatchQueue.main.async {
                            self.backgroundColor = hexStringToUIColor(hex: bgColour)
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
                    
                    if let contentMode = config["contentMode"] as? String{
                        DispatchQueue.main.async {
                            if contentMode == "Scale to Fill"{
                                self.contentMode = .scaleToFill
                            }
                            
                            if contentMode == "Aspect Fit"{
                                self.contentMode = .scaleAspectFit
                            }
                            
                            if contentMode == "Aspect Fill"{
                                self.contentMode = .scaleAspectFill
                            }
                        }
                    }
                }else {
                    self.revertToStoryboardUI(name: name, source: source, sourceParent: sourceParent, left: left, right: right, top: top, bottom: bottom, fixedWidth: fixedWidth, fixedHeight: fixedHeight, centerX: centerX, centerY: centerY, imageName: fallbackImage)
                }
            }
        }
        
        let url = URL(string: "https://uidesignmanager.herokuapp.com/v1/getasset/id/\(name)/\(appId)")!
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
                                                
                                                if let color = jsonData["bgColour"] as? String{
                                                    if let cR = jsonData["cornerRadius"] as? CGFloat{
                                                        DispatchQueue.main.async {
                                                            self.backgroundColor = hexStringToUIColor(hex: color)
                                                            
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
                                                
                                                if let contentMode = jsonData["contentMode"] as? String{
                                                    DispatchQueue.main.async {
                                                        if contentMode == "Scale to Fill"{
                                                            self.contentMode = .scaleToFill
                                                        }
                                                        
                                                        
                                                        if contentMode == "Aspect Fit"{
                                                            self.contentMode = .scaleAspectFit
                                                        }
                                                        
                                                        if contentMode == "Aspect Fill"{
                                                            self.contentMode = .scaleAspectFill
                                                        }
                                                    }
                                                }
                                                
                                                
                                                if let imageurl = jsonData["imageurl"] as? String{
                                                    
                                                    DispatchQueue.main.async {
                                                        if let url = URL(string: imageurl) {
                                                            do {
                                                                let contents = try String(contentsOf: url)
                                                                let image = self.convertBase64ToImage(imageString: contents)
                                                                self.defaults.setValue(image.pngData()?.base64EncodedString(options: .lineLength64Characters), forKey: "\(configuration)_id\(appId).png")
                                                                self.image = image
                                                            } catch {
                                                                // contents could not be loaded
                                                                self.image = nil
                                                                self.defaults.setValue(" ", forKey: "\(configuration)_id\(appId).png")
                                                                
                                                            }
                                                        }else{
                                                            self.image = nil
                                                            self.defaults.setValue(" ", forKey: "\(configuration)_id\(appId).png")
                                                            
                                                        }
                                                    }
                                                }
                                            }else {
                                                self.revertToStoryboardUI(name: name, source: source, sourceParent: sourceParent, left: left, right: right, top: top, bottom: bottom, fixedWidth: fixedWidth, fixedHeight: fixedHeight, centerX: centerX, centerY: centerY, imageName: fallbackImage)
                                            }
                                        }
                                    }else if components.count == 0{
                                        
                                        self.revertToStoryboardUI(name: name, source: source, sourceParent: sourceParent, left: left, right: right, top: top, bottom: bottom, fixedWidth: fixedWidth, fixedHeight: fixedHeight, centerX: centerX, centerY: centerY, imageName: fallbackImage) //sets the initial
                                        
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
                                            
                                            if (self.image) == nil {
                                                let image = UIImage(named: fallbackImage)
                                                self.image = image
                                                self.contentMode = .scaleAspectFill
                                                self.clipsToBounds = true
                                            }
                                            
                                            let imageInBase64 = self.image?.pngData()!.base64EncodedString(options: .lineLength64Characters)
                                            
                                            self.defaults.setValue(imageInBase64, forKey: "\(name)_id\(appId).png")
                                            
                                            params["title_id"] = name as AnyObject
                                            params["bundle_id"] = appId as AnyObject
                                            params["fontName"] = "" as AnyObject;
                                            params["fontSize"] = 0 as AnyObject
                                            params["bgColour"] = "" as AnyObject
                                            params["textValue"] = "" as AnyObject;
                                            params["textColour"] = "" as AnyObject;
                                            params["textBgColour"] = "" as AnyObject;
                                            params["textAlignment"] = 0 as AnyObject;
                                            params["hConstraints"] = hConstraints as AnyObject;
                                            params["vConstraints"] = vConstraints as AnyObject;
                                            params["color"] = "" as AnyObject;
                                            params["cornerRadius"] = 0 as AnyObject;
                                            params["type"] = "UIImageView" as AnyObject;
                                            params["source"] = screen as AnyObject;
                                            params["timestamp"] = timestamp as AnyObject;
                                            params["name"] = configuration as AnyObject;
                                            params["contentMode"] = "Aspect Fill" as AnyObject;
                                            params["active"] = true as AnyObject;
                                            params["centerHorizontally"] = self.isHorizontallyCentered as AnyObject;
                                            params["centerVertically"] = self.isVerticallyCentered as AnyObject;
                                            params["imagedata"] = imageInBase64 as AnyObject;
                                            
                                            
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
    
    func revertToStoryboardUI(name: String, source: UIViewController, sourceParent: UIView, left: CGFloat? = nil, right: CGFloat? = nil, top: CGFloat? = nil, bottom: CGFloat? = nil, fixedWidth: CGFloat? = nil, fixedHeight: CGFloat? = nil, centerX: Bool, centerY: Bool, imageName: String) {
        DispatchQueue.main.async {
            let colorString = self.inactiveBackgroundColorString
            
            
            let contentMode = "Aspect Fill"
            
            let timestamp = NSDate().timeIntervalSince1970
            
            if (self.image) == nil {
                let image = UIImage(named: imageName)
                self.image = image
                self.contentMode = .scaleAspectFill
                self.clipsToBounds = true
            }
            
            let imageString = self.inactiveImageString
            self.defaults.setValue(imageString, forKey: "\(name)_id\(appId).png")
            
            
            
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
            
            
            json = [ "hConstraints" : hConstraints, "vConstraints" : vConstraints, "cornerRadius": self.inactiveCornerRadius, "bgColour":colorString, "contentMode": contentMode, "imageString" : self.inactiveImageString, "type": "UIImageView", "source":screen, "timestamp":timestamp, "name":name, "centerHorizontally": self.isHorizontallyCentered, "centerVertically": self.isVerticallyCentered, "active" : true]
            
            _ = try? JSONSerialization.data(withJSONObject: json)
            // self.defaults.setValue(jsonData, forKey: name)
            self.setInitial(sourceParent: sourceParent, json: json)
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
    
    func setInitial(sourceParent: UIView, json: [String: Any]) {
        print("handling con")
        let config = json
        
        
        if let image = config["imageString"] as? String {
            DispatchQueue.main.async {
                self.image = self.convertBase64ToImage(imageString: image)
            }
        }
        
        
        if let bgColour = config["bgColour"] as? String {
            DispatchQueue.main.async {
                self.backgroundColor = hexStringToUIColor(hex: bgColour)
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
                DispatchQueue.main.async {
                    self.translatesAutoresizingMaskIntoConstraints = false
                    sourceParent.addConstraints( NSLayoutConstraint.constraints(withVisualFormat: hConstraints, options: [], metrics: nil, views: ["self":self]))
                    sourceParent.addConstraints( NSLayoutConstraint.constraints(withVisualFormat: vConstraints, options: [], metrics: nil, views: ["self":self]))
                }
            }
        }
        
        if let cornerRadius = config["cornerRadius"] as? CGFloat {
            DispatchQueue.main.async {
                self.layer.cornerRadius = cornerRadius
                self.layer.masksToBounds = true
            }
        }
        
        
        
        if let contentMode = config["contentMode"] as? String{
            DispatchQueue.main.async {
                if contentMode == "Scale to Fill"{
                    self.contentMode = .scaleToFill
                }
                
                
                if contentMode == "Aspect Fit"{
                    self.contentMode = .scaleAspectFit
                }
                
                if contentMode == "Aspect Fill"{
                    self.contentMode = .scaleAspectFill
                }
            }
        }
        
    }
    
    func uploadData(configuration: String, source: String, type: String, json: [String: Any]) {
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        let jsonStr = String(data: jsonData!, encoding: .utf8)!
        let jsonString = jsonStr.replacingOccurrences(of: "\\", with: "")
        let url = URL(string: "http://data.uidesignmanager.com/post.php")!
        var request = URLRequest(url: url)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        let parameters = "appId=\(appId)&name=\(configuration)&json=\(jsonString)"
        print("code \(parameters)")
        request.httpBody = parameters.data(using: .utf8)
        print("request \(String(describing: request.url))")
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
    
    public convenience init() {
        self.init(frame: CGRect.zero)
        
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

extension UIColor {
    func image(_ size: CGSize = CGSize(width: 1, height: 1)) -> UIImage {
        return UIGraphicsImageRenderer(size: size).image { rendererContext in
            self.setFill()
            rendererContext.fill(CGRect(origin: .zero, size: size))
        }
    }
}
