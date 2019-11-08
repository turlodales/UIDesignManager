//
//  UIDesignManager.swift
//  UIDesignManager
//
//  Created by Zivato Limited on 08/11/2019.
//

import Foundation

public func set(passKey: String) {
    key = passKey
    appId = "\(Bundle.main.bundleIdentifier!)\(key)".validString
}

public var key = String()

public var appId = String()

extension String {
    var validString: String {
        let okayChars = Set("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLKMNOPQRSTUVWXYZ1234567890")
        return self.filter {okayChars.contains($0) }
    }
}
