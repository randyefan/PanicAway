//
//  BreathingAnimationController.swift
//  PanicAway WatchKit Extension
//
//  Created by Javier Fransiscus on 01/08/21.
//

import UIKit
import WatchKit
import HealthKit

enum BreathingStateWatch: String {
    case breatheIn = "Breathe In"
    case breatheOut = "Breathe Out"
    case hold = "Hold"
}

class BreathingAnimationController: WKInterfaceController {

    
    @IBOutlet weak var animationView: WKInterfaceImage!
    @IBOutlet weak var informationLabel: WKInterfaceLabel!
    @IBOutlet weak var heartImage: WKInterfaceImage!
    @IBOutlet weak var heartRateLabel: WKInterfaceLabel!
    @IBOutlet weak var tapBreathingAnimationGesture: WKTapGestureRecognizer!
    
    var isWorkoutLive = false {
        didSet {
            if !isWorkoutLive {
                informationLabel.setText("Tap To Start")
            }
        }
    }
    
    // isFinish di set true ketika sudah satu putaran breathing (in-hold-out),
    var isFinish: Bool = false
    
    var heartRate: Double = 120
    var isHeartBeatAnimated = false
    var duration: Double{
        return (60/heartRate)/2
    }
    var timer:Timer?
    var breathingCycle: Int?
    var data = BreathingLoader()
    
    // Ini state harus diset ke nil, kalau dia ga breathing ya, soalnya di todo kita bisa balikin dia ke state awal
    var state: BreathingStateWatch? {
        didSet {
            guard let _ = state else {
                //TODO: - Handle With State when they doesnt in breathing mode
                return
            }
            self.updateView()
        }
    }
    var breathingTechnique: BreathingModel?
    
    let healthKitManager = HealthKitManager()
    
    override func awake(withContext context: Any?) {
        heartRateLabel.setText("---")
    }
    
    override func willActivate() {
        requestHealthKit()
        data.loadDataBreath()
        breathingTechnique = data.entries[0]
        breathingCycle = 2
    }
    
    override func didDeactivate() {
    }
    
    @IBAction func tapToStartClicked(_ sender: Any) {
        // State ketika tap start
        // Cek dulu apakah isWorkoutLive nya true atau tidak (kalau true berarti dia sedang breath -> dan harusnya dia finish breath, kalau false -> harusnya dia mulai breath)
        if isWorkoutLive {
            // Masuk kesini ketika sedang berjalan breathing tapi user tap watch
            // Update Label
            informationLabel.setText("Start")
            print("Finish")
            // Update Variable
            isWorkoutLive = false
            isHeartBeatAnimated = false
            
            // Workout session
            healthKitManager.endWorkoutSession()
            stopHeartBeatAnimation()
            
            // Validate Timer
            timer?.invalidate()
        } else {
            // Masuk kesini ketika sedang tidak workout tapi user tap watch
            // Update Label
            informationLabel.setText("Stop")
            
            // Update Variable
            isWorkoutLive = true
            isHeartBeatAnimated = true
            
            // Handle Breathing State & update view
            state = .breatheIn
            updateView()
            
            // Workout stuff
            healthKitManager.startWorkoutSession()
            startHeartBeatAnimation()
            
            // Timer stuff
            startTimer()
        }
    }
    
    func updateView() {
        if isWorkoutLive {
            guard let breathingState = state else { return }
            switch breathingState {
            case .breatheIn:
                //TODO: - Handle Setup Animation Breathe In Here
                print("Breathe In")
                
            case .breatheOut:
                //TODO: - Handle Setup Animation Breathe Out Here
                print("Breathe Out")
                
            case .hold:
                //TODO: - Handle Animation Hold State Here
                print("Handle Hold")
            }
        }
    }
    //Workout stuff
    
    func startTimer(){
        guard timer == nil else { return }
        
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (Timer) in
            self.heartRate = self.healthKitManager.heartRate
            
            let heartRateString = String(format: "%.0f", self.heartRate)
            
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
        
        //Logicnya (60 / BPM) untuk tahu kecepatan 1 beat itu berapa detik kan lalu dibagi 2 utk membesar dan mengecil nya dibagi 2 -- Comment From Javier
          
        
        
    }
    
    func stopHeartBeatAnimation(){
        isHeartBeatAnimated = false
    }

}
