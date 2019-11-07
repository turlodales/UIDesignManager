
![alt text](https://firebasestorage.googleapis.com/v0/b/uidesignmanager.appspot.com/o/GitHub.png?alt=media&token=61e763fd-7e4e-4d09-8ac6-f6f8f1b874ca)

# UIDesignManager

[![CI Status](https://img.shields.io/travis/ben.swift@zivato.com/UIDesignManager.svg?style=flat)](https://travis-ci.org/ben.swift@zivato.com/UIDesignManager)
[![Version](https://img.shields.io/cocoapods/v/UIDesignManager.svg?style=flat)](https://cocoapods.org/pods/UIDesignManager)
[![License](https://img.shields.io/cocoapods/l/UIDesignManager.svg?style=flat)](https://cocoapods.org/pods/UIDesignManager)
[![Platform](https://img.shields.io/cocoapods/p/UIDesignManager.svg?style=flat)](https://cocoapods.org/pods/UIDesignManager)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Usage

UIView initialize full parameter setup:

```ruby
let customView = ZUIView()
self.view.addSubview(customView)
            
customView.configure(name: "home_background", source: self, sourceParent: self.view, left: 0.0, right: 0.0, top: 0.0, bottom: 0.0, fixedWidth: nil, fixedHeight: nil, centerX: false, centerY: false)
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
