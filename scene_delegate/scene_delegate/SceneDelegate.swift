//
//  SceneDelegate.swift
//  scene_delegate
//
//  Created by Ben Scanlan on 8/1/23.
//

//import Foundation
//import UIKit
//import SwiftUI
//
//class SceneDelegate: UIResponder, UIWindowSceneDelegate {
//
//    var window: UIWindow?
//
//    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
//        // Create the SwiftUI view that provides the window contents.
//        let contentView = ContentView()
//
//        // Use a UIHostingController as window root view controller.
//        if let windowScene = scene as? UIWindowScene {
//            let window = UIWindow(windowScene: windowScene)
//            window.rootViewController = UIHostingController(rootView: contentView)
//            self.window = window
//            window.makeKeyAndVisible()
//        }
//    }
//
//    // ... (Other SceneDelegate methods)
//}

//import Foundation
//import UIKit
//import SwiftUI
//
//class SceneDelegate: UIResponder, UIWindowSceneDelegate {
//
//    var window: UIWindow?
//
//    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
//        // Show the launch screen as the initial content
//        let launchScreen = UIStoryboard(name: "LaunchScreen", bundle: nil)
//            .instantiateInitialViewController()
//
//        self.window?.rootViewController = launchScreen
//        self.window?.makeKeyAndVisible()
//
//        // After 1 second, replace the launch screen with the main content
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//            let contentView = ContentView()
//            let hostingController = UIHostingController(rootView: contentView)
//            self.window?.rootViewController = hostingController
//        }
//    }
//
//    // ... (Other SceneDelegate methods)
//}


//import UIKit
//import SwiftUI
//
//class SceneDelegate: UIResponder, UIWindowSceneDelegate {
//
//    var window: UIWindow?
//
//    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
//        // Create the launch screen view controller
//        let launchScreenViewController = LaunchScreenViewController()
//        self.window?.rootViewController = launchScreenViewController
//        self.window?.makeKeyAndVisible()
//
//        // After 1 second, replace the launch screen with the main content
//        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
//            let contentView = ContentView()
//            let hostingController = UIHostingController(rootView: contentView)
//            self.window?.rootViewController = hostingController
//        }
//    }
//
//    // ... (Other SceneDelegate methods)
//}

//
//import UIKit
//import SwiftUI
//
//class SceneDelegate: UIResponder, UIWindowSceneDelegate {
//
//    var window: UIWindow?
//
//    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
//        guard let windowScene = scene as? UIWindowScene else { return }
//
//        let window = UIWindow(windowScene: windowScene)
//
//        // Create the launch screen view
//        let launchScreenView = LaunchScreenView()
//
//        window.rootViewController = UIHostingController(rootView: launchScreenView)
//        self.window = window
//        window.makeKeyAndVisible()
//
//        // After 1 second, replace the launch screen with the main content
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//            let contentView = ContentView()
//            let hostingController = UIHostingController(rootView: contentView)
//            self.window?.rootViewController = hostingController
//        }
//    }
//
//    // ... (Other SceneDelegate methods)
//}



//import UIKit
//import SwiftUI
//
//class SceneDelegate: UIResponder, UIWindowSceneDelegate {
//
//    var window: UIWindow?
//
//    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
//        guard let windowScene = scene as? UIWindowScene else { return }
//
//        let window = UIWindow(windowScene: windowScene)
//
//        // Create the launch screen view
//        let launchScreenView = LaunchScreenView()
//
//        window.rootViewController = UIHostingController(rootView: launchScreenView)
//        self.window = window
//        window.makeKeyAndVisible()
//
//        // Show the launch screen for one second using DispatchQueue
//        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
//            let contentView = ContentView()
//            let hostingController = UIHostingController(rootView: contentView)
//            self.window?.rootViewController = hostingController
//        }
//    }
//
//    // ... (Other SceneDelegate methods)
//}


//import UIKit
//import SwiftUI
//
//class SceneDelegate: UIResponder, UIWindowSceneDelegate {
//
//    var window: UIWindow?
//
//    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
//        guard let windowScene = scene as? UIWindowScene else { return }
//
//        let window = UIWindow(windowScene: windowScene)
//
//        // Create the launch screen view
//        let launchScreenView = LaunchScreenView()
//
//        window.rootViewController = UIHostingController(rootView: launchScreenView)
//        self.window = window
//        window.makeKeyAndVisible()
//
//        // Optionally, you can add a delay here to make the launch screen stay for a specific duration.
//        // For example, to make it stay for 5 seconds, uncomment the following line:
//        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
//            let contentView = ContentView()
//            let hostingController = UIHostingController(rootView: contentView)
//            self.window?.rootViewController = hostingController
//            // }
//        }
//
//        // ... (Other SceneDelegate methods)
//    }
//}

//
//import UIKit
//import SwiftUI
//
//class SceneDelegate: UIResponder, UIWindowSceneDelegate {
//
//    var window: UIWindow?
//
//    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
//        guard let windowScene = scene as? UIWindowScene else { return }
//
//        let window = UIWindow(windowScene: windowScene)
//
//        // Create the launch screen view
//        let launchScreenView = LaunchScreenView()
//
//        window.rootViewController = UIHostingController(rootView: launchScreenView)
//        self.window = window
//        window.makeKeyAndVisible()
//
//        // Optionally, you can add a delay here to make the launch screen stay for a specific duration.
//        // For example, to make it stay for 5 seconds, uncomment the following line:
//        // DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
//        let contentView = ContentView()
//        let hostingController = UIHostingController(rootView: contentView)
//        self.window?.rootViewController = hostingController
//        // }
//    }
//
//    // ... (Other SceneDelegate methods)
//}


//import UIKit
//import SwiftUI
//
//class SceneDelegate: UIResponder, UIWindowSceneDelegate {
//
//    var window: UIWindow?
//
//    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
//        guard let windowScene = scene as? UIWindowScene else { return }
//
//        let window = UIWindow(windowScene: windowScene)
//
//        // Create the launch screen view
//        let launchScreenView = LaunchScreenView()
//
//        window.rootViewController = UIHostingController(rootView: launchScreenView)
//        self.window = window
//        window.makeKeyAndVisible()
//
//        // Optionally, you can add a delay here to make the launch screen stay for a specific duration.
//        // For example, to make it stay for 5 seconds, uncomment the following line:
//        // DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
//        let contentView = ContentView()
//        let hostingController = UIHostingController(rootView: contentView)
//        self.window?.rootViewController = hostingController
//        // }
//    }
//
//    // ... (Other SceneDelegate methods)
//}


//import UIKit
//import SwiftUI
//
//class SceneDelegate: UIResponder, UIWindowSceneDelegate {
//
//    var window: UIWindow?
//
//    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
//        guard let windowScene = scene as? UIWindowScene else { return }
//
//        let window = UIWindow(windowScene: windowScene)
//
//        // Create the launch screen view
//        let launchScreenView = LaunchScreenView()
//
//        window.rootViewController = UIHostingController(rootView: launchScreenView)
//        self.window = window
//        window.makeKeyAndVisible()
//
//        // Show the launch screen for 3 seconds using DispatchQueue
//        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
//            let contentView = ContentView()
//            let hostingController = UIHostingController(rootView: contentView)
//            self.window?.rootViewController = hostingController
//        }
//    }
//
//    // ... (Other SceneDelegate methods)
//}


//import UIKit
//import SwiftUI
//
//class SceneDelegate: UIResponder, UIWindowSceneDelegate {
//
//    var window: UIWindow?
//
//    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
//        guard let windowScene = scene as? UIWindowScene else { return }
//
//        let window = UIWindow(windowScene: windowScene)
//
//        // Create the launch screen view
//        let launchScreenView = LaunchScreenView()
//
//        window.rootViewController = UIHostingController(rootView: launchScreenView)
//        self.window = window
//        window.makeKeyAndVisible()
//
//        // Show the launch screen for 2 seconds using DispatchQueue
//        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//            let contentView = ContentView()
//            let hostingController = UIHostingController(rootView: contentView)
//            self.window?.rootViewController = hostingController
//        }
//    }
//
//    // ... (Other SceneDelegate methods)
//}


//import UIKit
//import SwiftUI
//
//class SceneDelegate: UIResponder, UIWindowSceneDelegate {
//
//    var window: UIWindow?
//
//    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
//        guard let windowScene = scene as? UIWindowScene else { return }
//
//        let window = UIWindow(windowScene: windowScene)
//
//        // Create the launch screen view
//        let launchScreenView = LaunchScreenView()
//
//        window.rootViewController = UIHostingController(rootView: launchScreenView)
//        self.window = window
//        window.makeKeyAndVisible()
//
//        // Show the launch screen for 2 seconds using DispatchQueue
//        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//            let contentView = ContentView()
//            let hostingController = UIHostingController(rootView: contentView)
//            self.window?.rootViewController = hostingController
//        }
//    }
//
//    // ... (Other SceneDelegate methods)
//}


//import UIKit
//import SwiftUI
//
//class SceneDelegate: UIResponder, UIWindowSceneDelegate {
//
//    var window: UIWindow?
//
//    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
//        guard let windowScene = scene as? UIWindowScene else { return }
//
//        let window = UIWindow(windowScene: windowScene)
//
//        // Set the ContentView as the root view
//        let contentView = ContentView()
//        window.rootViewController = UIHostingController(rootView: contentView)
//
//        self.window = window
//        window.makeKeyAndVisible()
//    }
//
//    // ... (Other SceneDelegate methods)
//}


//import UIKit
//import SwiftUI
//
//class SceneDelegate: UIResponder, UIWindowSceneDelegate {
//
//    var window: UIWindow?
//
//    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
//        guard let windowScene = scene as? UIWindowScene else { return }
//
//        let window = UIWindow(windowScene: windowScene)
//
//        let contentView = ContentView()
//        window.rootViewController = UIHostingController(rootView: contentView)
//        self.window = window
//        window.makeKeyAndVisible()
//
//        // Show the launch screen for 2 seconds using DispatchQueue
//        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//            self.showLaunchScreen(false)
//        }
//    }
//
//    // Helper function to show/hide the launch screen
//    func showLaunchScreen(_ show: Bool) {
//        let launchScreenView = LaunchScreenView()
//        let launchScreenController = UIHostingController(rootView: launchScreenView)
//
//        if show {
//            window?.rootViewController = launchScreenController
//        } else {
//            window?.rootViewController = UIHostingController(rootView: ContentView())
//        }
//    }
//
//    // ... (Other SceneDelegate methods)
//}


import UIKit
import SwiftUI

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = scene as? UIWindowScene else { return }

        let window = UIWindow(windowScene: windowScene)

        let launchScreenView = LaunchScreenView()
        print("SceneDelegate - scene will connect")
        window.rootViewController = UIHostingController(rootView: launchScreenView)

        self.window = window
        window.makeKeyAndVisible()

        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            let contentView = ContentView()
            let hostingController = UIHostingController(rootView: contentView)
            self.window?.rootViewController = hostingController
        }
    }

    // ... (Other SceneDelegate methods)
}

//human V

//func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
//
//    /// 1. Capture the scene
//    guard let windowScene = (scene as? UIWindowScene) else { return }
//
//    /// 2. Create a new UIWindow using the windowScene constructor which takes in a window scene.
//    let window = UIWindow(windowScene: windowScene)
//
//    /// 3. Create a view hierarchy programmatically
//    let viewController = ArticleListViewController()
//    let navigation = UINavigationController(rootViewController: viewController)
//
//    /// 4. Set the root view controller of the window with your view controller
//    window.rootViewController = navigation
//
//    /// 5. Set the window and call makeKeyAndVisible()
//    self.window = window
//    window.makeKeyAndVisible()
//}
