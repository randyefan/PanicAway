//
//  OnboardingViewController.swift
//  PanicAway
//
//  Created by Javier Fransiscus on 26/07/21.
//

import UIKit

class OnboardingViewController: UIViewController {
    
    var healthKitManager = HealthKitManager()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
    }
    
    @IBAction func requestAccess(_ sender: Any) {
        healthKitManager.authorizeHealthKit() {
            nextView()
        }
        
        
    }
    

    @IBAction func skipAppleHealthSetup(_ sender: Any) {
        nextView()
    }
    
    func nextView(){
        UserDefaults.standard.setValue(true, forKey: "isNotFirstLaunch")
        appDelegate.rootBreathingPage()
    }
}
