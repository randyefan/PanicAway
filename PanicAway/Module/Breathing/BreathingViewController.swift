//
//  BreathingViewController.swift
//  PanicAway
//
//  Created by Randy Efan Jayaputra on 26/07/21.
//

import UIKit
import AVFoundation

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
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var captionLabel: UILabel!
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
    
    // MARK: - Variable
    var breathingId: Int = 0
    var data = BreathingLoader()
    
    var state: BreathingState = .beforeBreathing {
        didSet {
            if state == .breathingOn {
                setupView()
                startPreparation()
            }
            
            if state == .finish {
                minutesTimer = 0
                secondsTimer = 0
                setupView()
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
                firstStateAnimationImageView.image = UIImage.animatedImage(with: breatheInAnimation, duration: TimeInterval(technique.breathInCount))
                breatheTime = technique.breathInCount
            }
            else if breathingStatus == .breatheOut {
                firstStateAnimationImageView.image = UIImage.animatedImage(with: breatheOutAnimation, duration: TimeInterval(technique.breathOutCount))
                breatheTime = technique.breathOutCount
            }
            else if breathingStatus == .holdBreathe {
                firstStateAnimationImageView.image = UIImage.animatedImage(with: breatheHoldAnimation, duration: TimeInterval(technique.holdOnCount))
                breatheTime = technique.holdOnCount
            }
        }
    }
    
    var isRunning: Bool = false
    var countdownTime = 3
    var breatheTime = 0 // Handle With data from model later! (REQUIRED)
    var breathCycle = 0
    var progress: Float = 0.0
    var counter = 0
    
    //timer
    var secondsTimer = 0
    var minutesTimer = 0
    
    //animation
    var breatheInAnimation = [UIImage]()
    var breatheOutAnimation = [UIImage]()
    var breatheHoldAnimation = [UIImage]()
    
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
        circularProgressBar.progress = 0.0
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
            setupViewForState(topView: false, titleLabel: false, captionLabel: true, breathingMethodeStackView: false, safeAreaView: true, circularProgressBar: true, labelBottomView: true)
        case .breathingOn:
            setupViewForState(topView: true, titleLabel: false, captionLabel: true, breathingMethodeStackView: true, safeAreaView: false, circularProgressBar: false, labelBottomView: false)
        case .pause:
            setupViewForState(topView: true, titleLabel: false, captionLabel: true, breathingMethodeStackView: true, safeAreaView: false, circularProgressBar: false, labelBottomView: false)
        case .finish:
            setupViewForState(topView: false, titleLabel: false, captionLabel: false, breathingMethodeStackView: false, safeAreaView: true, circularProgressBar: true, labelBottomView: true)
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
                    self.state = .breathingOn
                    self.isRunning = true
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
        for frame in (0...59){
            breatheInAnimation.append(UIImage(named: String(format: "Breathe In_%05d", frame))!)
        }
        
        for frame in (0...59).reversed(){
            breatheOutAnimation.append(UIImage(named: String(format: "Breathe In_%05d", frame))!)
        }
        
        for frame in (0...104){
            breatheHoldAnimation.append(UIImage(named: String(format: "Hold_%05d", frame))!)
        }
    }
    
    
    // MARK: - Functionality
    
    func setupViewForState(topView: Bool, titleLabel: Bool, captionLabel: Bool, breathingMethodeStackView: Bool, safeAreaView: Bool, circularProgressBar: Bool, labelBottomView: Bool) {
        self.topView.isHidden = topView
        self.titleLabel.isHidden = titleLabel
        self.captionLabel.isHidden = captionLabel
        self.breathingMethodStackView.isHidden = breathingMethodeStackView
        self.safeAreaView.isHidden = safeAreaView
        self.circularProgressBar.isHidden = circularProgressBar
        self.labelBottomView.isHidden = labelBottomView
    }
    
    func navigateToSettings() {
        let vc = SettingsViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func startPreparation() {
        guard let technique = technique else { return }
        
        if state == .breathingOn {
            breathCycle = UserDefaults.standard.integer(forKey: "defaultBreathingCycle") - 1
            progress = 1.0 / (Float(technique.breathInCount + technique.breathOutCount + technique.holdOnCount) * Float((breathCycle + 1)))
            preparation = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(runPreparation), userInfo: nil, repeats: true)
            RunLoop.current.add(preparation!, forMode: .common)
        }
    }
    
    func startBreathing() {
        breathingStatus = .breatheIn
        if state == .breathingOn {
            breathing = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(runCountDown), userInfo: nil, repeats: true)
            RunLoop.current.add(breathing!, forMode: .common)
        }
    }
    
    @objc func runCountDown() {
        print("breathe time \(breatheTime)")
        
        //timer logic here
        bottomLabel.text = String(format: "%02d:%02d", minutesTimer,secondsTimer)
        if secondsTimer == 60 {
            secondsTimer = 0
            minutesTimer += 1
        } else {
            secondsTimer += 1
        }
        counter += 1
        print(counter)
        
        //update circular
        circularProgressBar.progress +=  CGFloat(progress)
        captionLabel.isHidden = false
        
        // FIXME: EFAN PLS CHECK THIS OK
        // i dunno why it wont update if not in main thread
        DispatchQueue.main.async {
            self.captionLabel.text = "\(self.breatheTime)"
        }
       
        
        if breatheTime == 1 {
            if breathingStatus == .breatheIn {
                self.breathingStatus = .holdBreathe
                if breatheTime == 0 {
                    self.breathingStatus = .breatheOut
                }
            }
            else if breathingStatus == .holdBreathe {
                self.breathingStatus = .breatheOut
            }
            else if breathingStatus == .breatheOut {
                print(" breath :\(breathCycle)")
                //validasi breathing cycle
                if breathCycle != 0 {
                    self.breathingStatus = .breatheIn
                    breathCycle -= 1
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
    
    @objc func runPreparation() {
        titleLabel.isHidden = false
        titleLabel.text = "\(countdownTime)"
        
        if countdownTime == 0 {
            startBreathing()
            preparation?.invalidate()
            countdownTime = 3
            return
        }
        countdownTime -= 1
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
