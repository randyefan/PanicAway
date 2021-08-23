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
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        if url.scheme == "panicaway" {
            openBreathingFromScheme()
        }
        
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
    
    func openBreathingFromScheme() {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = UIColor.clear
        let viewController = BreathingViewController()
        let navigationBar = UINavigationController(rootViewController: viewController)
        viewController.openUsingScheme()
        window?.rootViewController = navigationBar
        window?.makeKeyAndVisible()
    }
    
    func sendMessage() {
        // Variable for Emergency Contact Number
        var number = [String]()
        let message = "Test API \(getFullName()) 1... 2... 3..." // Handle With Default Message
        let emergencyContact = getEmergencyContact()
        
        guard let contact = emergencyContact, contact.count != 0 else {
            // TODO: - Handle With Poptip Error Belum menambahkan contact
            print("Anda belum menambahkan contact")
            return
        }
        
        number.append(contentsOf: contact.map { $0.phoneNumber.toPhoneNumber() })
        
        for i in number {
            print("Phone Number: \(i)")
            NetworkingManager.shared.postMessage(phoneNumber: i, message: message)
        }
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
    
    private func getEmergencyContact() -> [EmergencyContactModel]? {
        // Get Emergency Contact Number in userDefaults
        if let data = UserDefaults.standard.data(forKey: "defaultEmergencyContact") {
            do {
                let decoder = JSONDecoder()
                let emergencyContact = try decoder.decode([EmergencyContactModel].self, from: data)
                return emergencyContact
            } catch {
                print("Unable to Decode (\(error))")
                return nil
            }
        }
        
        return nil
    }
    
    private func getFullName() -> String {
        if let fullName = UserDefaults.standard.string(forKey: "fullName") {
            return fullName
        }
        
        return "No Name"
    }
}
