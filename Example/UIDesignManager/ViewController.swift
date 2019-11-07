//
//  ViewController.swift
//  UIDesignManager
//
//  Created by ben.swift@zivato.com on 07/26/2019.
//  Copyright (c) 2019 ben.swift@zivato.com. All rights reserved.
//

import UIKit


class ViewController: UIViewController {
    
        let customView = ZUIView()
        let customLabel = ZUILabel()
        let customImage = ZUIImageView()
        let customButton = ZUIButton()
        let customTextView = ZUITextView()
        
        
        override func viewDidLoad() {
            super.viewDidLoad()
            

            
            //COLORS ONLY///////////////////////----->
            
            
            
            //set just color parameters for your UI components. NOTE: Using this color method in conjunction with the full parameter method is not advisable.
            
            //set view: property with the view you wish to configure
            
            //set name: property with a key name. NOTE: You can reuse the same name in multiple parts of your app. This will make changing colors on the client side much easier. eg: "primary_color" could be used to control colors for all UIButtons and UILabels
            
            //UIView --->
            
            let colorView = UIView(frame: view.bounds)
            self.view.addSubview(colorView)
            
            //UIView background color
            setUIViewColor(name: "primary_color", source: self, initialColor: UIColor.lightGray, view: colorView)
            
            //--------------<
            
            
            
            
            //UIImageView --->
            
            let img = UIImageView(frame: view.bounds)
            self.view.addSubview(img)
            
            //UIImageView background color
            setUIImageViewColor(name: "secondary_color", source: self, initialColor: UIColor.lightGray, view: img)
            
            //--------------<
            
            
            
            
            //UIButton --->
            
            let btn = UIButton(frame: view.bounds)
            btn.setTitle("HELLO", for: .normal)
            self.view.addSubview(btn)
            
            //UIButton background color
            setUIButtonBgColor(name: "secondary_color", source: self, initialColor: UIColor.lightGray, view: btn)
            
            //UIButton title color
            setUIButtonTitleColor(name: "std_btn_text_color", source: self, initialColor: UIColor.white, view: btn)
            
            //--------------<
            
            
            
            
            //UILabel --->
            
            let lbl = UILabel(frame: view.bounds)
            self.view.addSubview(lbl)
            
            //UILabel background color
            setUILabelBgColor(name: "std_label_bg_color", source: self, initialColor: UIColor.lightGray, view: lbl)
            
            //UILabel text color
            setUILabelTextColor(name: "std_label_text_color", source: self, initialColor: UIColor.white, view: lbl)
            
            //--------------<
            
            
            
            
            //UITextView --->
            
            let textView = UITextView(frame: view.bounds)
            self.view.addSubview(textView)
            
            //UITextView background color
            setUITextViewBgColor(name: "std_textview_bg_color", source: self, initialColor: UIColor.lightGray, view: textView)
            
            //UITextView text color
            setUITextViewTextColor(name: "std_textview_text_color", source: self, initialColor: UIColor.white, view: textView)
            
            //--------------<
            
            
            
            //COLORS ONLY///////////////////////-----<
            
            
            
            
            
            
            //---------------------------------------------------------------------------------------->
            
            
            
            
            
            
            //FULL PARAMETER COMPONENT SETUP///////////////////////----->
            
            
            
            //set all parameters for your UI components. NOTE: When running your configuration for the first time a configuration will be saved to our servers. All parameters can then be controlled via the UIDesigner iOS app
            
            //set view: property with the view you wish to configure
            

            
            //UIView --->
            
            self.view.addSubview(customView)
            
            //UIView initialize full parameter setup
            customView.configure(name: "home_background", source: self, sourceParent: self.view, left: 0.0, right: 0.0, top: 0.0, bottom: 0.0, fixedWidth: nil, fixedHeight: nil, centerX: false, centerY: false)
            
            //--------------<
            
            //UITextView --->
            
            customTextView.text = "This is a passage of text"
            customTextView.isEditable = false
            self.view.addSubview(customTextView)
            
            //UITextView initialize full parameter setup
            customTextView.configure(name: "home_textview", source: self, sourceParent: self.view, left: 40, right: 40, top: 180, bottom: 40, fixedWidth: nil, fixedHeight: nil, centerX: false, centerY: false)
            
            //--------------<
            
            
            
            //UILabel --->
            
            customLabel.text = "HEADER"
            self.view.addSubview(customLabel)
            
            //UILabel initialize full parameter setup
            customLabel.configure(name: "home_header", source: self, sourceParent: self.view, left: 40, right: 40, top: 40, bottom: nil, fixedWidth: nil, fixedHeight: 100.0, centerX: false, centerY: false)
            
            //--------------<
            
            
            
            
            //UIButton --->
            
            customButton.setTitle("HELLO", for: .normal)
            self.view.addSubview(customButton)
            
            //UIButton initialize full parameter setup
            customButton.configure(name: "home_button", source: self, sourceParent: self.view, left: 40, right: 40, top: nil, bottom: 40, fixedWidth: nil, fixedHeight: 50.0, centerX: false, centerY: false)
            
            //--------------<
            
            
            
            
            //UIImageView --->
            
            self.view.addSubview(customImage)
            
            //UIImageView initialize full parameter setup
            customImage.configure(name: "home_image", source: self, sourceParent: self.view, left: 60.0, right: 60.0, top: nil, bottom: 110.0, fixedWidth: nil, fixedHeight: 150, centerX: false, centerY: false, fallbackImage: "home_image_id7216")
            
            //--------------<

            
            
            //FULL PARAMETER COMPONENT SETUP///////////////////////-----<

            

        }
        
        @objc func function() {
            print("button tapped")
        }
        
        
        override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
            // Dispose of any resources that can be recreated.
        }
        
        
    }


