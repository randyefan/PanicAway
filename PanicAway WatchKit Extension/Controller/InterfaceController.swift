//
//  InterfaceController.swift
//  PanicAway WatchKit Extension
//
//  Created by Randy Efan Jayaputra on 22/07/21.
//

import WatchKit
import Foundation
import HealthKit
import UIKit

class InterfaceController: WKInterfaceController {
    
    @IBOutlet weak var textLabel: WKInterfaceLabel!
    let store = HKHealthStore()
    let healthKitManager = HealthKitManager()

    typealias HKObserverQueryCompletionHandler = () -> Void
    
    @IBAction func allowToGetNotified() {
        listenForUpdates()
    }
    
    @IBAction func disallowToGetNotified() {
        
    }
    
    override func awake(withContext context: Any?) {
        // Configure interface objects here.

    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        healthKitManager.authorizeHealthKitForWatchOS {
            
        }
        //Mungkin disini berarti taro kalau first launch root view controllernya yang mana
        
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
    }
    
    func listenForUpdates(){
        //Tadi udah coba nyerah dulu bentar coba buat heart beat session dulu pusing yang ini kayak ngajak ribut gitu
    }

}
