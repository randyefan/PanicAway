//
//  BreathingAnimationController.swift
//  PanicAway WatchKit Extension
//
//  Created by Javier Fransiscus on 01/08/21.
//

import UIKit
import WatchKit
import HealthKit

class BreathingAnimationController: WKInterfaceController {

    
    @IBOutlet weak var animationView: WKInterfaceImage!
    @IBOutlet weak var informationLabel: WKInterfaceLabel!
    @IBOutlet weak var heartImage: WKInterfaceImage!
    @IBOutlet weak var heartRateLabel: WKInterfaceLabel!
    @IBOutlet weak var tapBreathingAnimationGesture: WKTapGestureRecognizer!
    
    var isWorkoutLive = false
    var heartRate: Double = 120
    var isHeartBeatAnimated = false
    var duration: Double{
        return (60/heartRate)/2
    }
    var timer:Timer?
    
    let healthKitManager = HealthKitManager()
    
    override func awake(withContext context: Any?) {
//        super.awake(withContext: context)
//         loadAnimation(url: URL(string: "https://assets8.lottiefiles.com/packages/lf20_Zz37yH.json")!)
        
        heartRateLabel.setText("---")
        
        
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        requestHealthKit()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
//        self.healthKitManager.endWorkoutSession()
    }
    
    @IBAction func tapToStartClicked(_ sender: Any) {
           if isWorkoutLive {
               informationLabel.setText("Start")
   //            pauseBreathingAnimation()
               isWorkoutLive = false
               healthKitManager.endWorkoutSession()
               isHeartBeatAnimated = false
               stopHeartBeatAnimation()
               
               //invalidate timer
               timer?.invalidate()
           }else{
               informationLabel.setText("Stop")
   //            playBreathingAnimation()
               isWorkoutLive = true
               healthKitManager.startWorkoutSession()
               isHeartBeatAnimated = true
               startHeartBeatAnimation()
               startTimer()
           }
           
       }
    //Workout stuff
    
    func startTimer(){
        guard timer == nil else { return }
        
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (Timer) in
            self.heartRate = self.healthKitManager.heartRate
            
            var heartRateString = String(format: "%.0f", self.heartRate)
            
            self.heartRateLabel.setText("\(heartRateString) BPM")
            
            self.startHeartBeatAnimation()
        }
        
        
    }
    
    
    func requestHealthKit(){
        healthKitManager.authorizeHealthKit()
        
    }
    
    func startHeartBeatAnimation(){
        if isHeartBeatAnimated == true {
            self.animate(withDuration: duration) {
                self.heartImage.setWidth(21.375)
                self.heartImage.setHeight(18)
            }
            
            let when = DispatchTime.now() + Double((duration * double_t(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
            
            DispatchQueue.global(qos: .default).async {
                DispatchQueue.main.asyncAfter(deadline: when) {
                    self.animate(withDuration: self.duration, animations: {
                        self.heartImage.setWidth(19)
                        self.heartImage.setHeight(16)
                        
                    })            }
                
                
            }
            
        }
        
        //Logicnya (60 / BPM) untuk tahu kecepatan 1 beat itu berapa detik kan lalu dibagi 2 utk membesar dan mengecil nya dibagi 2
          
        
        
    }
    
    func stopHeartBeatAnimation(){
        isHeartBeatAnimated = false
    }

}
