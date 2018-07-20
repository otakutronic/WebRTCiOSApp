//
//  AppData.swift
//  AppTapia
//
//  Created by Andy 01/09/17.
//

import Foundation
import UIKit
import CoreData

class AppData {
    
    var window: UIWindow?
    var sessionToken = ""
    var loginSuccess = false
    var firshRun = true
    var fmcToken = ""
    var voipToken = ""
    
    func applicationDidFinishLaunching(_ application: UIApplication) {
        // Override point for customization after application launch.
        UINavigationBar.appearance().barStyle = UIBarStyle.default
        UINavigationBar.appearance().barTintColor = COLOR_MAIN
        UINavigationBar.appearance().tintColor = UIColor.black
        UINavigationBar.appearance().backgroundColor = COLOR_MAIN
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName : UIColor.black]
    }
    
    
}
