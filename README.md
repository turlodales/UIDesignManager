
![alt text](https://firebasestorage.googleapis.com/v0/b/uidesignmanager.appspot.com/o/GitHub.png?alt=media&token=61e763fd-7e4e-4d09-8ac6-f6f8f1b874ca)

# UIDesignManager

[![CI Status](https://img.shields.io/travis/ben.swift@zivato.com/UIDesignManager.svg?style=flat)](https://travis-ci.org/ben.swift@zivato.com/UIDesignManager)
[![Version](https://img.shields.io/cocoapods/v/UIDesignManager.svg?style=flat)](https://cocoapods.org/pods/UIDesignManager)
[![License](https://img.shields.io/cocoapods/l/UIDesignManager.svg?style=flat)](https://cocoapods.org/pods/UIDesignManager)
[![Platform](https://img.shields.io/cocoapods/p/UIDesignManager.svg?style=flat)](https://cocoapods.org/pods/UIDesignManager)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

Integrate UIDesignManager with any Swift iOS application that is using UIKit. After your app runs for the first time your initial configurations will be saved and linked to our servers. To manage and control the properties of the individually configured UI components you will need to download the UIDesigner app from the app store. 

## Usage

Set full parameters for your UI components. NOTE: Using this full parameter method in conjunction with the color parameter method is not advisable.
        
Constraints: set constraints programatically within the configure method. All parameters can be changed later via the UIDesigner iOS app.

NOTE: All updated UI parameters are saved on device which ensures smooth fast rendering.

## UIView initialize full parameter setup:

```ruby
let customView = ZUIView()
self.view.addSubview(customView)
            
customView.configure(name: "home_background", source: self, sourceParent: self.view, left: 0.0, right: 0.0, top: 0.0, bottom: 0.0, fixedWidth: nil, fixedHeight: nil, centerX: false, centerY: false)
# This will act as a fallback configuration if switched to inactive in the UIDesigner app

```

## UIImageView initialize full parameter setup:

```ruby
let customImage = ZUIImageView()
self.view.addSubview(customImage)

customImage.configure(name: "home_image", source: self, sourceParent: self.view, left: 60.0, right: 60.0, top: nil, bottom: 110.0, fixedWidth: nil, fixedHeight: 150, centerX: false, centerY: false, fallbackImage: "YOUR_IMAGE")
# This will act as a fallback configuration if switched to inactive in the UIDesigner app

```

## UITextView initialize full parameter setup:

```ruby
let customTextView = ZUITextView()
customTextView.text = "This is a passage of text"
customTextView.isEditable = false
self.view.addSubview(customTextView)
        
customTextView.configure(name: "home_textview", source: self, sourceParent: self.view, left: 40, right: 40, top: 180, bottom: 40, fixedWidth: nil, fixedHeight: nil, centerX: false, centerY: false)
# This will act as a fallback configuration if switched to inactive in the UIDesigner app

```

## UILabel initialize full parameter setup:

```ruby
let customLabel = ZUILabel()
customLabel.text = "HEADER"
self.view.addSubview(customLabel)
        
customLabel.configure(name: "home_header", source: self, sourceParent: self.view, left: 40, right: 40, top: 40, bottom: nil, fixedWidth: nil, fixedHeight: 100.0, centerX: false, centerY: false)
# This will act as a fallback configuration if switched to inactive in the UIDesigner app

```

## UIButton initialize full parameter setup:

```ruby
let customButton = ZUIButton()
customButton.setTitle("HELLO", for: .normal)
self.view.addSubview(customButton)

customButton.configure(name: "home_button", source: self, sourceParent: self.view, left: 40, right: 40, top: nil, bottom: 40, fixedWidth: nil, fixedHeight: 50.0, centerX: false, centerY: false)
# This will act as a fallback configuration if switched to inactive in the UIDesigner app

```

## Colors

Set just color parameters for your UI components. NOTE: Using this color method in conjunction with the full parameter method is not advisable.
        
Set view: property with the view you wish to configure
        
Set name: property with a key name. NOTE: You can reuse the same name in multiple parts of your app. This will make changing colors on the client side much easier. eg: "primary_color" could be used to control colors for all UIButtons and UILabels.

## UIView set color:

```ruby
let colorView = UIView(frame: view.bounds)
self.view.addSubview(colorView)

# UIView background color
setUIViewColor(name: "primary_color", source: self, initialColor: UIColor.red, view: colorView)
```

## UILabel set color:

```ruby
let lbl = UILabel(frame: view.bounds)
self.view.addSubview(lbl)

# UILabel background color
setUILabelBgColor(name: "std_label_bg_color", source: self, initialColor: UIColor.lightGray, view: lbl)

# UILabel text color
setUILabelTextColor(name: "std_label_text_color", source: self, initialColor: UIColor.white, view: lbl)
```

## UIImageView set color:

```ruby
let img = UIImageView(frame: view.bounds)
self.view.addSubview(img)

# UIImageView background color
setUIImageViewColor(name: "secondary_color", source: self, initialColor: UIColor.yellow, view: img)
```

## UIButton set color:

```ruby
let btn = UIButton(frame: view.bounds)
btn.setTitle("HELLO", for: .normal)
self.view.addSubview(btn)

# UIButton background color
setUIButtonBgColor(name: "secondary_color", source: self, initialColor: UIColor.lightGray, view: btn)

# UIButton title color
setUIButtonTitleColor(name: "std_btn_text_color", source: self, initialColor: UIColor.white, view: btn)
```

## UITextView set color:

```ruby
let textView = UITextView(frame: view.bounds)
self.view.addSubview(textView)

# UITextView background color
setUITextViewBgColor(name: "std_textview_bg_color", source: self, initialColor: UIColor.lightGray, view: textView)

# UITextView text color
setUITextViewTextColor(name: "std_textview_text_color", source: self, initialColor: UIColor.white, view: textView)
```

## Installation

UIDesignManager is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'UIDesignManager'
```

## Author

ben.swift@zivato.com, =ben.swift@zivato.com

## License

UIDesignManager is available under the MIT license. See the LICENSE file for more info.
