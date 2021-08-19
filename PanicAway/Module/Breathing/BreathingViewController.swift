//
//  BreathingViewController.swift
//  PanicAway
//
//  Created by Randy Efan Jayaputra on 26/07/21.
//

import UIKit
import AVFoundation
import EFCountingLabel
import CoreHaptics
import HealthKit

enum BreathingState {
    case beforeBreathing
    case breathingOn
    case pause
    case finish
}

enum BreathingStatus: String {
    case breatheIn = "Breathe In"
    case breatheOut = "Breathe Out"
    case holdBreathe = "Hold"
}

enum BreathingTechnique: Int {
    case one = 0
    case two = 1
    case three = 2
}

class BreathingViewController: UIViewController {
    // MARK: - IBOutlet
    
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var circularProgressBar: CircularProgressBar!
    @IBOutlet weak var settingsView: UIImageView!
    @IBOutlet weak var titleLabel: EFCountingLabel!
    @IBOutlet weak var captionLabel: EFCountingLabel!
    @IBOutlet weak var breathingLabel: UILabel!
    @IBOutlet weak var breathingMethodStackView: UIStackView!
    @IBOutlet weak var leftChevronView: UIView!
    @IBOutlet weak var leftChevronImageView: UIImageView!
    @IBOutlet weak var rightChevronView: UIView!
    @IBOutlet weak var rightChevronImageView: UIImageView!
    @IBOutlet weak var firstStateAnimationImageView: UIImageView!
    @IBOutlet weak var centreAnimationView: UIView!
    @IBOutlet weak var closeView: UIImageView!
    
    // MARK: - Variable
    var breathingId: Int = 0
    var data = BreathingLoader()
    let healthKitManager = HealthKitManager()
    var startDate = Date()
    var mindfulnessMinutes: Double{
        return Double((minutesTimer*60) + secondsTimer)
    }
    
    var state: BreathingState = .beforeBreathing {
        didSet {
            setupView()
            if state == .breathingOn {
                startPreparation()
            }
            if state == .finish {
                captionLabel.isHidden = true
                isRunning = false
            }
        }
    }
    
    var breathingStatus: BreathingStatus? {
        didSet {
            guard let technique = technique else { return }
            guard let breathingStat = breathingStatus else { return }
            self.playInstruction()
            titleLabel.text = breathingStat.rawValue
            captionLabel.text = "\(breatheTime)"
            if breathingStatus == .breatheIn {
                breatheTime = technique.breathInCount
                if technique.breathingName == "4-7-8" {
                    firstStateAnimationImageView.image = UIImage.animatedImage(with: breatheInAnimation, duration: TimeInterval((Double(technique.breathInCount) + 0.6)))
                } else if technique.breathingName == "7-11" {
                    firstStateAnimationImageView.image = UIImage.animatedImage(with: breatheInAnimation, duration: TimeInterval((Double(technique.breathInCount) + 0.3 + 0.10)))
                } else {
                    firstStateAnimationImageView.image = UIImage.animatedImage(with: breatheInAnimation, duration: TimeInterval((Double(technique.breathInCount) + 0.4)))
                }
            }
            else if breathingStatus == .breatheOut {
                breatheTime = technique.breathOutCount
                firstStateAnimationImageView.image = UIImage.animatedImage(with: breatheOutAnimation, duration: TimeInterval((Double(technique.breathOutCount) + 0.3 + 0.09)))

            }
            else if breathingStatus == .holdBreathe {
                breatheTime = technique.holdOnCount
                if technique.id == 0 {
                    firstStateAnimationImageView.image = UIImage.animatedImage(with: breatheHold478Animation, duration: TimeInterval((Double(technique.holdOnCount) + 0.3 + 0.09)))
                } else {
                    firstStateAnimationImageView.image = UIImage.animatedImage(with: breatheHold444Animation, duration: TimeInterval((Double(technique.holdOnCount) + 0.3 + 0.09)))
                }
            }
        }
    }
    
    override var prefersHomeIndicatorAutoHidden: Bool {
        return true
    }
    
    var isRunning: Bool = false
    var countdownTime = 3
    var breatheTime = 0 // Handle With data from model later! (REQUIRED)
    var engine: CHHapticEngine?
    var breathCycle = 0
    var progress: Float = 0.0
    var counter = 0
    var isPaused: Bool = false
    
    //timer
    var secondsTimer = 0
    var minutesTimer = 0
    
    //animation
    var breatheInAnimation = [UIImage]()
    var breatheOutAnimation = [UIImage]()
    var breatheHoldAnimation = [UIImage]()
    var breatheHold444Animation = [UIImage]()
    var breatheHold478Animation = [UIImage]()
    
    //AVFoundation
    var player: AVAudioPlayer?
    
    // MARK: - Computed Properties
    var technique: BreathingModel? {
        didSet {
            guard let technique = technique else { return }
            breathingLabel.text = technique.breathingName
            setupChevronByPosition(position: BreathingTechnique(rawValue: technique.id)!)
        }
    }
    
    // MARK: - Variable DisplayLink (For working with timer)
    
    var preparation: Timer?
    var breathing: Timer?
    
    // MARK: - ViewController LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        data.loadDataBreath()
        setupView()
        setupObserveAction()
        setupHaptic()
        setupAnimation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupNavigationBar()
        setupToDefaultBreathingTechnique()
    }
    
    // MARK: - Setup View for ViewController
    
    private func setupView() {
        switch state {
        case .beforeBreathing:
            setupViewForState(topView: false, titleLabel: false, captionLabel: true, breathingMethodeStackView: false, circularProgressBar: true, closeView: true)
        case .breathingOn:
            setupViewForState(topView: true, titleLabel: false, captionLabel: true, breathingMethodeStackView: true, circularProgressBar: false, closeView: true)
        case .pause:
            setupViewForState(topView: false, titleLabel: false, captionLabel: true, breathingMethodeStackView: true, circularProgressBar: false, closeView: false)
            titleLabel.text = "Paused"
            firstStateAnimationImageView.image = UIImage(named: "ic_animation_state_no_breathing")
        case .finish:
            setupViewForState(topView: false, titleLabel: false, captionLabel: false, breathingMethodeStackView: false, circularProgressBar: true, closeView: true)
            circularProgressBar.progress = 0
            healthKitManager.saveMeditation(startDate: startDate, seconds: mindfulnessMinutes)
            minutesTimer = 0
            secondsTimer = 0
            firstStateAnimationImageView.image = UIImage(named: "ic_animation_state_no_breathing")
            titleLabel.text = "Tap to Start Again"
            DispatchQueue.main.async {
                self.captionLabel.text = "Yay, you’ve finished your breathing exercise!"
            }
        }
    }
    
    func setupHaptic() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }

        do {
            engine = try CHHapticEngine()
            try engine?.start()
        } catch {
            print("There was an error creating the engine: \(error.localizedDescription)")
        }
    }
    
    func setupToDefaultBreathingTechnique() {
        let idBreath = UserDefaults.standard.integer(forKey: "defaultBreatheId")
        breathingId = idBreath
        technique = data.entries[idBreath]
    }
    
    func setupNavigationBar() {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    private func setupObserveAction() {
        settingsView.onTap {
            self.navigateToSettings()
        }
        
        closeView.onTap {
            self.state = .finish
        }
        
        leftChevronView.onTap {
            if !self.leftChevronImageView.isHidden {
                self.breathingId -= 1
                self.technique = self.data.entries[self.breathingId]
            }
        }
        
        rightChevronView.onTap {
            if !self.rightChevronImageView.isHidden {
                self.breathingId += 1
                self.technique = self.data.entries[self.breathingId]
            }
        }
        
        if state == .beforeBreathing {
            centreAnimationView.onTap {
                guard let technique = self.technique else { return }
                if self.isRunning == false {
                    self.breathCycle = UserDefaults.standard.integer(forKey: "defaultBreathingCycle") - 1
                    self.progress = 1.0 / (Float(technique.breathInCount + technique.breathOutCount + technique.holdOnCount) * Float(self.breathCycle + 1))
                    self.state = .breathingOn
                    self.isRunning = true
                } else if self.state == .breathingOn {
                    self.state = .pause
                    self.preparation?.invalidate()
                    self.breathing?.invalidate()
                } else if self.state == .pause{
                    self.state = .breathingOn
                }
            }
        }
    }
    
    func setupChevronByPosition(position: BreathingTechnique) {
        switch position {
        case .one:
            leftChevronImageView.isHidden = true
            rightChevronImageView.isHidden = false
        case .two:
            leftChevronImageView.isHidden = false
            rightChevronImageView.isHidden = false
        default:
            leftChevronImageView.isHidden = false
            rightChevronImageView.isHidden = true
        }
    }
    
    func setupAnimation(){
        
        
        circularProgressBar.progress = 0
        
        
        
        for frame in (0...95){
            breatheInAnimation.append(UIImage(named: String(format: "Breathe In 3_%05d", frame))!)
        }
        
        for frame in (0...95).reversed(){
            breatheOutAnimation.append(UIImage(named: String(format: "Breathe In 3_%05d", frame))!)
        }
        
        for frame in (0...167){
            breatheHold478Animation.append(UIImage(named: String(format: "Hold 478_%05d", frame))!)
        }
        
        for frame in (0...95){
            breatheHold444Animation.append(UIImage(named: String(format: "Hold 3_%05d", frame))!)
        }
    }
    
    
    // MARK: - Functionality
    
    func setupViewForState(topView: Bool, titleLabel: Bool, captionLabel: Bool, breathingMethodeStackView: Bool, circularProgressBar: Bool, closeView: Bool) {
        self.topView.isHidden = topView
        self.titleLabel.isHidden = titleLabel
        self.captionLabel.isHidden = captionLabel
        self.breathingMethodStackView.isHidden = breathingMethodeStackView
        self.circularProgressBar.isHidden = circularProgressBar
        self.closeView.isHidden = closeView
    }
    
    func navigateToSettings() {
        let vc = SettingsViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func startPreparation() {
        if state == .breathingOn {
            titleLabel.countFrom(CGFloat(countdownTime + 1), to: 1, withDuration: 3.0)
            titleLabel.completionBlock = {
                self.startBreathing()
            }
        }
    }
    
    func startBreathing() {
        breathingStatus = .breatheIn
        if state == .breathingOn {
            captionLabel.isHidden = false
            breathing = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(runCountDown), userInfo: nil, repeats: true)
            RunLoop.current.add(breathing!, forMode: .common)
            guard let techniqueCount = technique?.breathInCount else { return }
            captionLabel.countFrom(CGFloat(techniqueCount + 1), to: 1, withDuration: (Double(techniqueCount)))
        }
    }
    
    func updateLabelBreathing() {
        guard let techniqueCount = technique else { return }
        if breathingStatus == .breatheOut {
            captionLabel.countFrom(CGFloat(techniqueCount.breathOutCount + 1), to: 1, withDuration: (Double(techniqueCount.breathOutCount)))
        } else if breathingStatus == .breatheIn{
            captionLabel.countFrom(CGFloat(techniqueCount.breathInCount + 1), to: 1, withDuration: (Double(techniqueCount.breathInCount)))
        } else if breathingStatus == .holdBreathe {
            captionLabel.countFrom(CGFloat(techniqueCount.holdOnCount + 1), to: 1, withDuration: (Double(techniqueCount.holdOnCount)))
        }
    }
    
    func setHapticForASecond(duration: Float) {
        let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: 0)
        let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: 1)

        let start = CHHapticParameterCurve.ControlPoint(relativeTime: 0, value: duration)
        let end = CHHapticParameterCurve.ControlPoint(relativeTime: Double(duration), value: 0)

        let parameter = CHHapticParameterCurve(parameterID: .hapticIntensityControl, controlPoints: [start, end], relativeTime: 0)

        let event = CHHapticEvent(eventType: .hapticContinuous, parameters: [sharpness, intensity], relativeTime: 0, duration: Double(duration))

        do {
            let pattern = try CHHapticPattern(events: [event], parameterCurves: [parameter])

            let player = try self.engine?.makePlayer(with: pattern)
            try player?.start(atTime: 0)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    @objc func runCountDown() {
       // print("breathe time \(breatheTime)")
        
        //timer logic here
        if secondsTimer == 60 {
            secondsTimer = 0
            minutesTimer += 1
        } else {
            secondsTimer += 1
        }
        counter += 1
        //print(counter)
        
        // MARK: - TODO: CGFloat(progress) not counting (0,0), so the circularProgressBar still 0.2
        circularProgressBar.progress +=  CGFloat(progress)
        captionLabel.isHidden = false
        print(circularProgressBar.progress)
        
        if breatheTime == 1 {
            if breathingStatus == .breatheIn {
                self.breathingStatus = .holdBreathe
                updateLabelBreathing()
                if breatheTime == 0 {
                    self.breathingStatus = .breatheOut
                    updateLabelBreathing()
                }
            }
            else if breathingStatus == .holdBreathe {
                self.breathingStatus = .breatheOut
                updateLabelBreathing()
            }
            else if breathingStatus == .breatheOut {
                print(" breath :\(breathCycle)")
                //validasi breathing cycle
                if breathCycle != 0 {
                    self.breathingStatus = .breatheIn
                    breathCycle -= 1
                    updateLabelBreathing()
                } else {
                    print("FINISH")
                    state = .finish
                    breathing?.invalidate()
                    return
                }
            }
        } else {
            breatheTime -= 1
        }
    }
    
    func playInstruction() {
        var filename = ""
        switch breathingStatus {
        case .breatheIn:
            filename = "VO - Breath In"
        case .breatheOut:
            filename = "VO - Breath Out"
        default:
            filename = "VO - Hold"
        }
        
        guard let path = Bundle.main.path(forResource: filename, ofType: "mp3") else { return }
        
        let url = URL(fileURLWithPath: path)
        do{
            player = try AVAudioPlayer(contentsOf: url)
            player?.play()
        } catch let error {
            print(error.localizedDescription)
        }
    }
}
