//
//  OnboardingViewController.swift
//  PanicAway
//
//  Created by Javier Fransiscus on 26/07/21.
//

import UIKit

class OnboardingViewController: UIViewController {
    
    @IBOutlet weak var allowAccessButton: UIButton!
    @IBOutlet weak var skipButton: UIButton!
    
    var healthKitManager = HealthKitManager()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        allowAccessButton.setTitle("Allow Access".localized(), for: .normal)
        skipButton.setTitle("Skip".localized(), for: .normal)
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
