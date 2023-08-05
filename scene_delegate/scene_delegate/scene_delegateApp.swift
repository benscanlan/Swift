//
//  scene_delegateApp.swift
//  scene_delegate
//
//  Created by Ben Scanlan on 8/1/23.
//

import SwiftUI

@main
struct scene_delegateApp: App {
    var body: some Scene {
        WindowGroup {
            //scene(_:willConnectTo:options:)
            //SceneDelegate()
            ContentView()
            scene(_:willConnectTo:options:)
        }
    }
}


//import UIKit
//
//@main
//class AppDelegate: UIResponder, UIApplicationDelegate {
//
//    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
//        // Override point for customization after application launch.
//        return true
//    }
//
//    // ... (Other AppDelegate methods if needed)
//}


//scene(_:willConnectTo:options:)
