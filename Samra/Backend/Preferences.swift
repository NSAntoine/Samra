//
//  Preferences.swift
//  Samra
//
//  Created by Serena on 18/02/2023.
// 

import Foundation

@propertyWrapper
struct Storage<T> {
    let key: String
    var defaultValue: T
    
    var wrappedValue: T {
        get {
            UserDefaults.standard.object(forKey: key) as? T ?? defaultValue
        }
        
        set {
            UserDefaults.standard.set(newValue, forKey: key)
        }
    }
}

enum Preferences {
    @Storage(key: "RecentlyOpenedPaths", defaultValue: [])
    static var recentlyOpenedFilePaths: [String]
    
    @Storage(key: "ShowWelcomeViewControllerOnLaunch", defaultValue: true)
    static var showWelcomeVCOnLaunch: Bool
    
    /*
    static var recentlyOpenedFilePaths: [String] {
        get {
            let arr = UserDefaults.standard.stringArray(forKey: "RecentlyOpenedPaths") ?? []
            return arr
        }
        
        set {
            UserDefaults.standard.set(newValue, forKey: "RecentlyOpenedPaths")
        }
    }
     */
}
