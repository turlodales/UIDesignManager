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
    
    override init (frame : CGRect) {
        super.init(frame : frame)
        
        if (self.backgroundColor) == nil {
            self.backgroundColor = generateRandomPastelColor(withMixedColor: UIColor.blue)
        }
    }
    
    func uploadImage(image: UIImage, name: String, source: UIViewController, sourceParent: UIView, left: CGFloat? = nil, right: CGFloat? = nil, top: CGFloat? = nil, bottom: CGFloat? = nil, fixedWidth: CGFloat? = nil, fixedHeight: CGFloat? = nil, centerX: Bool, centerY: Bool) {
        
        print("uploading image")
        
        let configuration = name
        
        //save image to user defaults
        
        //if there exists an image, its png data saved to defaults
        if let imageData = image.pngData(){
            self.defaults.setValue(imageData, forKey: "\(configuration)_id\(appId).png")
        }
        
        //UPLOADING THE IMAGE TO FIREBASE STORAGE
        
        let url = URL(string: "https://firebasestorage.googleapis.com/v0/b/uidesignmanager.appspot.com/o/images%2F+\(configuration)_id\(appId).png")
        
        // generate boundary string using a unique per-app string
        let boundary = UUID().uuidString
        
        let session = URLSession.shared
        
        var path = ""
        
        // Set the URLRequest to POST and to the specified URL
        var urlRequest = URLRequest(url: url!)
        urlRequest.httpMethod = "POST"
        
        // Set Content-Type Header to multipart/form-data, this is equivalent to submitting form data with file upload in a web browser
        // And the boundary is also set here
        urlRequest.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        var data = Data()
        
        // Add the image data to the raw http request data
        data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
        data.append("Content-Disposition: form-data; name=\"\(configuration)\"; filename=\"\(configuration)_id\(appId).png\"\r\n".data(using: .utf8)!)
        
        data.append("Content-Type: image/png\r\n\r\n".data(using: .utf8)!)
        data.append(image.pngData()!)
        
        data.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)
        
        // Send a POST request to the URL, with the data we created earlier
        session.uploadTask(with: urlRequest, from: data, completionHandler: { responseData, response, error in
            if error == nil {
                let jsonData = try? JSONSerialization.jsonObject(with: responseData!, options: .allowFragments)
                if let json = jsonData as? [String: Any] {
                    print(json)
                    
                    if let token = json["downloadTokens"] as? String {
                        
                        //https://firebasestorage.googleapis.com/v0/b/uidesignmanager.appspot.com/o/
                        
                        path = token
                        
                        print("imagePath \(path)")
                        
                        DispatchQueue.main.async {
                            //uploads the initial config, once the image is in firebase storage and the image data is stored in defaults
                            
                            let colorString = self.backgroundColor?.hexString(.d6)
                            
                            
                            let contentMode = "Aspect Fill"
                            
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
                            
                            
                            json = [ "hConstraints" : hConstraints, "vConstraints" : vConstraints, "cornerRadius": self.layer.cornerRadius, "bgColour":colorString!, "contentMode": contentMode, "imageUrl" : path, "type": "UIImageView", "source":screen, "timestamp":timestamp, "name":configuration, "centerHorizontally": self.isHorizontallyCentered, "centerVertically": self.isVerticallyCentered, "active" : true]
                            
                            let jsonData = try? JSONSerialization.data(withJSONObject: json)
                            
                            //saves the config on firebase into defaults
                            self.defaults.setValue(jsonData, forKey: configuration)
                            self.setInitial(sourceParent: sourceParent, json: json)
                            self.uploadData(configuration: configuration, source: screen, type: "UIImageViews", json: json)
                        }
                        
                    }
                    
                }
            } else {
                print("image upload error \(error!)")
            }
        }).resume()
        
        
    }
    
    open func configure(name: String, source: UIViewController, sourceParent: UIView, left: CGFloat? = nil, right: CGFloat? = nil, top: CGFloat? = nil, bottom: CGFloat? = nil, fixedWidth: CGFloat? = nil, fixedHeight: CGFloat? = nil, centerX: Bool, centerY: Bool, fallbackImage: String) {
        
        let configuration = name
        
        if (self.backgroundColor) == nil {
            self.backgroundColor = generateRandomPastelColor(withMixedColor: UIColor.blue)
        }
        
        
        
        if let imgData = defaults.value(forKey: "\(name)_id\(appId).png") as? NSData {
            DispatchQueue.main.async {
                let loadedImage : UIImage = UIImage(data: imgData as Data)!
                self.image = loadedImage
                print("got image")
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
                                        self.defaults.setValue(jsonData, forKey: configuration) //puts the configurations in the user defaults as configuration
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
                                                
                                                
                                                if let image = jsonData["imageUrl"] as? String{
                                                    DispatchQueue.main.async {
                                                        if image != ""{
                                                            let imageUrl  = "https://firebasestorage.googleapis.com/v0/b/uidesignmanager.appspot.com/o/images%2F%20\(configuration)_id\(appId).png?alt=media&token=\(image)"
                                                            let url = URL(string: imageUrl)
                                                            let data = try? Data(contentsOf: url!)
                                                            
                                                            self.image = UIImage(data: data!)
                                                            
                                                            self.defaults.setValue(data, forKey: "\(configuration)_id\(appId).png")
                                                        }else {
                                                            self.image = nil
                                                            self.defaults.setValue(data, forKey: "")
                                                        }
                                                        
                                                    }
                                                }
                                            }else {
                                                self.revertToStoryboardUI(name: name, source: source, sourceParent: sourceParent, left: left, right: right, top: top, bottom: bottom, fixedWidth: fixedWidth, fixedHeight: fixedHeight, centerX: centerX, centerY: centerY, imageName: fallbackImage)
                                            }
                                        }
                                    }
                                }
                                
                            } catch {
                                print(error.localizedDescription)
                            }
                            
                        } else if dataString.contains("no data"){
                            //initial config
                            DispatchQueue.main.async {
                                
                                if (self.image) == nil {
                                    let image = UIImage(named: fallbackImage)
                                    self.image = image
                                    self.contentMode = .scaleAspectFill
                                    self.clipsToBounds = true
                                }
                                
                                self.uploadImage(image: self.image!, name: name, source: source, sourceParent: sourceParent, left: left, right: right, top: top, bottom: bottom, fixedWidth: fixedWidth, fixedHeight: fixedHeight, centerX: centerX, centerY: centerY)
                                self.revertToStoryboardUI(name: name, source: source, sourceParent: sourceParent, left: left, right: right, top: top, bottom: bottom, fixedWidth: fixedWidth, fixedHeight: fixedHeight, centerX: centerX, centerY: centerY, imageName: fallbackImage)
                            }
                        }
                    }
                }
            }
        }
        task.resume()
        
    }
    
    func revertToStoryboardUI(name: String, source: UIViewController, sourceParent: UIView, left: CGFloat? = nil, right: CGFloat? = nil, top: CGFloat? = nil, bottom: CGFloat? = nil, fixedWidth: CGFloat? = nil, fixedHeight: CGFloat? = nil, centerX: Bool, centerY: Bool, imageName: String) {
        DispatchQueue.main.async {
            let colorString = self.backgroundColor?.hexString(.d6)
            
            
            let contentMode = "Aspect Fill"
            
            let timestamp = NSDate().timeIntervalSince1970
            
            let data = self.image!.pngData()
            self.defaults.setValue(data, forKey: "\(name)_id\(appId).png")
            
            
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
            
            
            json = [ "hConstraints" : hConstraints, "vConstraints" : vConstraints, "cornerRadius": self.layer.cornerRadius, "bgColour":colorString!, "contentMode": contentMode, "imageName" : imageName, "type": "UIImageView", "source":screen, "timestamp":timestamp, "name":name, "centerHorizontally": self.isHorizontallyCentered, "centerVertically": self.isVerticallyCentered, "active" : true]
            
            print("2 \(json)")
            
            let jsonData = try? JSONSerialization.data(withJSONObject: json)
            self.defaults.setValue(jsonData, forKey: name)
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
        
        
        if let fallbackImage = config["imageName"] as? String {
            DispatchQueue.main.async {
                self.image = UIImage(named: fallbackImage)
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
        print("passed \(json)")
        
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
