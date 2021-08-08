//
//  BreathingViewController.swift
//  PanicAway
//
//  Created by Randy Efan Jayaputra on 26/07/21.
//

import UIKit
import AVFoundation
import EFCountingLabel

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
    @IBOutlet weak var safeAreaView: UIView!
    @IBOutlet weak var breathingMethodStackView: UIStackView!
    @IBOutlet weak var leftChevronView: UIView!
    @IBOutlet weak var leftChevronImageView: UIImageView!
    @IBOutlet weak var rightChevronView: UIView!
    @IBOutlet weak var rightChevronImageView: UIImageView!
    @IBOutlet weak var labelBottomView: UIView!
    @IBOutlet weak var bottomLabel: UILabel!
    @IBOutlet weak var firstStateAnimationImageView: UIImageView!
    @IBOutlet weak var centreAnimationView: UIView!
    @IBOutlet weak var closeView: UIImageView!
    
    // MARK: - Variable
    var breathingId: Int = 0
    var data = BreathingLoader()
    
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
    
    var isRunning: Bool = false
    var countdownTime = 3
    var breatheTime = 0 // Handle With data from model later! (REQUIRED)
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
            setupViewForState(topView: false, titleLabel: false, captionLabel: true, breathingMethodeStackView: false, safeAreaView: true, circularProgressBar: true, labelBottomView: true, closeView: true)
        case .breathingOn:
            setupViewForState(topView: true, titleLabel: false, captionLabel: true, breathingMethodeStackView: true, safeAreaView: false, circularProgressBar: false, labelBottomView: false, closeView: true)
        case .pause:
            setupViewForState(topView: false, titleLabel: false, captionLabel: true, breathingMethodeStackView: true, safeAreaView: false, circularProgressBar: false, labelBottomView: false, closeView: false)
            titleLabel.text = "Paused"
            firstStateAnimationImageView.image = UIImage(named: "ic_animation_state_no_breathing")
        case .finish:
            setupViewForState(topView: false, titleLabel: false, captionLabel: false, breathingMethodeStackView: false, safeAreaView: true, circularProgressBar: true, labelBottomView: true, closeView: true)
            circularProgressBar.progress = 0.2
            minutesTimer = 0
            secondsTimer = 0
            bottomLabel.text = String(format: "%02d:%02d", minutesTimer,secondsTimer)
            firstStateAnimationImageView.image = UIImage(named: "ic_animation_state_no_breathing")
            titleLabel.text = "Tap to Start Again"
            DispatchQueue.main.async {
                self.captionLabel.text = "Yay, you’ve finished your breathing exercise!"
            }
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
                if self.isRunning == false {
                    self.breathCycle = UserDefaults.standard.integer(forKey: "defaultBreathingCycle") - 1
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
        circularProgressBar.progress = 0.2
        
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
            breatheHold444Animation.append(UIImage(named: String(format: "Hold 444_%05d", frame))!)
        }
    }
    
    
    // MARK: - Functionality
    
    func setupViewForState(topView: Bool, titleLabel: Bool, captionLabel: Bool, breathingMethodeStackView: Bool, safeAreaView: Bool, circularProgressBar: Bool, labelBottomView: Bool, closeView: Bool) {
        self.topView.isHidden = topView
        self.titleLabel.isHidden = titleLabel
        self.captionLabel.isHidden = captionLabel
        self.breathingMethodStackView.isHidden = breathingMethodeStackView
        self.safeAreaView.isHidden = safeAreaView
        self.circularProgressBar.isHidden = circularProgressBar
        self.labelBottomView.isHidden = labelBottomView
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
    
    @objc func runCountDown() {
       // print("breathe time \(breatheTime)")
        
        //timer logic here
        bottomLabel.text = String(format: "%02d:%02d", minutesTimer,secondsTimer)
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
            filename = "inhale"
        case .breatheOut:
            filename = "exhale"
        default:
            filename = "hold"
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
