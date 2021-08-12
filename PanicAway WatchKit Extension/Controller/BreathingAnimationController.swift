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
    
    
    @IBOutlet weak var breatheInView: WKInterfaceImage!
    @IBOutlet weak var holdAnimationView: WKInterfaceImage!
    @IBOutlet weak var breatheOutAnimationView: WKInterfaceImage!
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
    var breathingCycle: Int = 0
    var breatheTimer: Int = 0
    var data = BreathingLoader()
    
    // Ini state harus diset ke nil, kalau dia ga breathing ya, soalnya di todo kita bisa balikin dia ke state awal
    var state: BreathingStateWatch? {
        didSet {
            guard let _ = state else {
                //TODO: - Handle With State when they doesnt in breathing mode
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
        setupAnimation()
    }
    
    override func didDeactivate() {
    }
    
    func setupAnimation(){
        breatheInView.setImageNamed("breathIn")
        holdAnimationView.setImageNamed("holdTujuh")
        breatheOutAnimationView.setImageNamed("breathIn")
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
            
            state = nil
            holdAnimationView.stopAnimating()
            breatheOutAnimationView.stopAnimating()
            breatheInView.stopAnimating()
            
            // Validate Timer
            timer?.invalidate()
        } else {
            breathingCycle = 2
            // Masuk kesini ketika sedang tidak workout tapi user tap watch
            // Update Label
            informationLabel.setText("Stop")
            
            // Update Variable
            isWorkoutLive = true
            isHeartBeatAnimated = true
            
            // Handle Breathing State & update view
            state = .breatheIn
            
            //updateView()
            
            // Workout stuff
            healthKitManager.startWorkoutSession()
            startHeartBeatAnimation()
            
            // Timer stuff
            
            startTimer()
        }
    }
    
    func updateView() {
        guard let technique = breathingTechnique else { return }
        if isWorkoutLive {
            guard let breathingState = state else { return }
            switch breathingState {
            case .breatheIn:
                //TODO: - Handle Setup Animation Breathe In Here
                print("Breathe In")
                breatheTimer = technique.breathInCount
                
                holdAnimationView.setHidden(true)
                breatheOutAnimationView.setHidden(true)
                breatheInView.setHidden(false)
                
                breatheInView.startAnimatingWithImages(in: NSRange(location: 0, length: 95), duration: TimeInterval(technique.breathInCount), repeatCount: 1)
                
                
            case .breatheOut:
                //TODO: - Handle Setup Animation Breathe Out Here
                print("Breathe Out")
                breatheTimer = technique.breathOutCount
                
                holdAnimationView.setHidden(true)
                breatheOutAnimationView.setHidden(false)
                breatheInView.setHidden(true)
                breatheOutAnimationView.startAnimatingWithImages(in: NSRange(location: 0, length: 95), duration: TimeInterval(technique.breathOutCount), repeatCount: 1)
                
            case .hold:
                //TODO: - Handle Animation Hold State Here
                print("Handle Hold")
                breatheTimer = technique.holdOnCount
                
                holdAnimationView.setHidden(false)
                breatheOutAnimationView.setHidden(true)
                breatheInView.setHidden(true)
                holdAnimationView.startAnimatingWithImages(in: NSRange(location: 0, length: 167), duration: TimeInterval(technique.holdOnCount), repeatCount: 1)
            }
        }
    }
    
    //Workout stuff
    func startTimer(){
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(runCountDown), userInfo: nil, repeats: true)
    }
    
    @objc func runCountDown(){
        
        //heart rate nya javier
        self.heartRate = healthKitManager.heartRate
        let heartRateString = String(format: "%.0f", heartRate)
        heartRateLabel.setText("\(heartRateString) BPM")
        //----------------------------------------------------
        
        //print("breathe time \(breatheTimer)")
        
        if breatheTimer == 1 {
            if state == .breatheIn{
                self.state = .hold
                if breatheTimer == 0 {
                    self.state = .breatheOut
                }
            }
            else if state == .hold{
                self.state = .breatheOut
            }
            else if state == .breatheOut {
                print("cycle: \(breathingCycle)")
                if breathingCycle != 1 {
                    self.state = .breatheIn
                    breathingCycle -= 1
                } else {
                    //breathing finished
                    state = nil
                    print("breathing finished")
                    return
                }
            }
        } else {
            breatheTimer -= 1
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
