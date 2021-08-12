//
//  BreathingMethodController.swift
//  PanicAway WatchKit Extension
//
//  Created by Javier Fransiscus on 01/08/21.
//

import UIKit
import WatchKit

class BreathingMethodController: WKInterfaceController {

    override func awake(withContext context: Any?) {
        
    }
    
    @IBAction func methodOneButtonClicked() {
        WKInterfaceController.reloadRootPageControllers(withNames: ["BreathingAnimation", "NotifyFriend"], contexts: nil, orientation: .horizontal, pageIndex: 0)
    }
}


