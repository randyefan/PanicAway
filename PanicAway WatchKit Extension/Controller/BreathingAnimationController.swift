//
//  BreathingAnimationController.swift
//  PanicAway WatchKit Extension
//
//  Created by Javier Fransiscus on 01/08/21.
//

import UIKit
import WatchKit
import SDWebImageLottieCoder
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
    
    
//    //Mark - Animation
//    private var coder: SDImageLottieCoder?
//    private var animationTimer: Timer?
//    private var currentFrame: UInt = 0
//    private var playing: Bool = false
//    private var speed: Double = 1.0
//
//    //Loads Animation Data
//    //Parameter url : url of animation JSON
//    private func loadAnimation(url: URL) {
//      let session = URLSession.shared
//      let dataTask = session.dataTask(with: URLRequest(url: url)) { (data, response, error) in
//        guard let data = data else { return }
//        DispatchQueue.main.async {
//          self.setupAnimation(with: data)
//        }
//      }
//      dataTask.resume()
//    }
//
//    //Decodify animation with given data
//    // - Parameter data : data of animation
//    private func setupAnimation(with data: Data) {
//      coder = SDImageLottieCoder(animatedImageData: data, options: [SDImageCoderOption.decodeLottieResourcePath: Bundle.main.resourcePath!])
//      // resets to first frame
//      currentFrame = 0
//      setImage(frame: currentFrame)
//    }
//
//    //Set Current Animation
//    // - Paramater frame : Set image for given frame
//    private func setImage(frame: UInt) {
//      guard let coder = coder else { return }
//      animationView.setImage(coder.animatedImageFrame(at: frame))
//    }
//
//    //Start Playing Animation
//    private func playBreathingAnimation() {
//      playing = true
//
//      animationTimer?.invalidate()
//      animationTimer = Timer.scheduledTimer(withTimeInterval: 0.05/speed, repeats: true, block: { (timer) in
//        guard self.playing else {
//          timer.invalidate()
//          return
//        }
//        self.nextFrame()
//      })
//    }
//
//    //Pauses animation
//    private func pauseBreathingAnimation() {
//      playing = false
//      animationTimer?.invalidate()
//    }
//
//    //Replace current frame with the next one
//    private func nextFrame() {
//      guard let coder = coder else { return }
//
//      currentFrame += 1
//      // make sure that current frame is within frame count
//      // if reaches the end, we set it back to 0 so it loops
//      if currentFrame >= coder.animatedImageFrameCount {
//        currentFrame = 0
//      }
//      setImage(frame: currentFrame)
//    }
    
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
