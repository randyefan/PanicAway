//
//  AppDelegate.swift
//  PanicAway
//
//  Created by Randy Efan Jayaputra on 22/07/21.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        setupDefaultNavbar()
        checkUserFirstLaunch()
        return true
    }
    
    func checkUserFirstLaunch() {
        if UserDefaults.standard.bool(forKey: "isNotFirstLaunch") {
            rootBreathingPage()
            return
        }
        
        rootOnBoarding()
    }
    
    func rootBreathingPage() {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = UIColor.clear
        let viewController = BreathingViewController()
        let navigationBar = UINavigationController(rootViewController: viewController)
        window?.rootViewController = navigationBar
        window?.makeKeyAndVisible()
    }
    
    func rootOnBoarding() {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = UIColor.clear
        let viewController = ProductShowcaseViewController()
        let navigationBar = UINavigationController(rootViewController: viewController)
        window?.rootViewController = navigationBar
        window?.makeKeyAndVisible()
    }
}

fileprivate extension AppDelegate {
    func setupDefaultNavbar() {
        if #available(iOS 13.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = UIColor(named: "Background")

            UINavigationBar.appearance().standardAppearance = appearance
            UINavigationBar.appearance().scrollEdgeAppearance = appearance
            UINavigationBar.appearance().compactAppearance = appearance
            UINavigationBar.appearance().tintColor = UIColor(named: "MainHard")


        } else {
            UINavigationBar.appearance().barTintColor = UIColor(named: "Background")
            UINavigationBar.appearance().tintColor = UIColor(named: "MainHard")
        }
    }
}
