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
    
    @IBOutlet weak var tapBreathingAnimationGesture: WKTapGestureRecognizer!
    
    @IBAction func tapToStartClicked(_ sender: Any) {
        startBreathing()
        
    }
    
    func startBreathing(){
        tapBreathingAnimationGesture.isEnabled = false
        playAnimation()
        startWorkout()
     
        
    }
    
    func startWorkout(){
        print("workout started")
    }
    
    func endWorkout(){
        print("workout is ended")
    }
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
         loadAnimation(url: URL(string: "https://assets8.lottiefiles.com/packages/lf20_Zz37yH.json")!)
    }
    
    //Mark - Animation
    private var coder: SDImageLottieCoder?
    private var animationTimer: Timer?
    private var currentFrame: UInt = 0
    private var playing: Bool = false
    private var speed: Double = 1.0
    
    //Loads Animation Data
    //Parameter url : url of animation JSON
    private func loadAnimation(url: URL) {
      let session = URLSession.shared
      let dataTask = session.dataTask(with: URLRequest(url: url)) { (data, response, error) in
        guard let data = data else { return }
        DispatchQueue.main.async {
          self.setupAnimation(with: data)
        }
      }
      dataTask.resume()
    }
    
    //Decodify animation with given data
    // - Parameter data : data of animation
    private func setupAnimation(with data: Data) {
      coder = SDImageLottieCoder(animatedImageData: data, options: [SDImageCoderOption.decodeLottieResourcePath: Bundle.main.resourcePath!])
      // resets to first frame
      currentFrame = 0
      setImage(frame: currentFrame)
    }
    
    //Set Current Animation
    // - Paramater frame : Set image for given frame
    private func setImage(frame: UInt) {
      guard let coder = coder else { return }
      animationView.setImage(coder.animatedImageFrame(at: frame))
    }
    
    //Start Playing Animation
    private func playAnimation() {
      playing = true
      
      animationTimer?.invalidate()
      animationTimer = Timer.scheduledTimer(withTimeInterval: 0.05/speed, repeats: true, block: { (timer) in
        guard self.playing else {
          timer.invalidate()
          return
        }
        self.nextFrame()
      })
    }
    
    //Pauses animation
    private func pause() {
      playing = false
      animationTimer?.invalidate()
    }
    
    //Replace current frame with the next one
    private func nextFrame() {
      guard let coder = coder else { return }
      
      currentFrame += 1
      // make sure that current frame is within frame count
      // if reaches the end, we set it back to 0 so it loops
      if currentFrame >= coder.animatedImageFrameCount {
        currentFrame = 0
      }
      setImage(frame: currentFrame)
    }
    
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        endWorkout()
    }


}
