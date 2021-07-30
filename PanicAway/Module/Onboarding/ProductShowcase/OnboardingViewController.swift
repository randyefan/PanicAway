//
//  OnboardingViewController.swift
//  PanicAway
//
//  Created by Javier Fransiscus on 26/07/21.
//

import UIKit
import HealthKit

class OnboardingViewController: UIViewController {
    
    var healthKitManager = HealthKitManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        // Do any additional setup after loading the view.
    }
    
    @IBAction func requestAccess(_ sender: Any) {
        healthKitManager.authorizeHealthKit {
            // langsung pindah ke next view regardless setelah hal ini
            nextView()
        }
    }
    

    @IBAction func skipAppleHealthSetup(_ sender: Any) {
        nextView()
    }
    
    func nextView(){
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
