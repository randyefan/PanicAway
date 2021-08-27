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
import SwiftMessages

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

enum Localization: String {
    case en = "Overlay"
    case id = "Overlay-Indo"
}

class BreathingViewController: UIViewController {
    // MARK: - IBOutlet
    
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var circularProgressBar: CircularProgressBar!
    @IBOutlet weak var settingsView: UIImageView!
    @IBOutlet weak var titleLabel: EFCountingLabel!
    @IBOutlet weak var captionLabel: EFCountingLabel!
    @IBOutlet weak var prepareLabel: UILabel!
    @IBOutlet weak var breathingLabel: UILabel!
    @IBOutlet weak var breathingMethodStackView: UIStackView!
    @IBOutlet weak var leftChevronView: UIView!
    @IBOutlet weak var leftChevronImageView: UIImageView!
    @IBOutlet weak var rightChevronView: UIView!
    @IBOutlet weak var rightChevronImageView: UIImageView!
    @IBOutlet weak var firstStateAnimationImageView: UIImageView!
    @IBOutlet weak var centreAnimationView: UIView!
    @IBOutlet weak var closeView: UIImageView!
    @IBOutlet weak var topChevronView: UIView!
    @IBOutlet weak var breatheTechniqueGoalLabel: LocalizedLabel!
    @IBOutlet weak var endBreathingButton: UIButton!
    @IBOutlet weak var breathingChoiceView: UIStackView!
    @IBOutlet weak var overlayImageView: UIImageView!
    
    
    // MARK: - Variable
    var defaultLanguage: Localization = .en
    var breathingId: Int = 0
    var data = BreathingLoader()
    var isFirstBreathingScreen = true
    let healthKitManager = HealthKitManager()
    var startDate = Date()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var mindfulnessMinutes: Double{
        return Double((minutesTimer*60) + secondsTimer)
    }
    
    var state: BreathingState = .beforeBreathing {
        didSet {
            setupView()
            if state == .breathingOn {
                guard let technique = self.technique else { return }
                self.breathCycle = UserDefaults.standard.integer(forKey: "defaultBreathingCycle") - 1
                self.progress = 1.0 / (Float(technique.breathInCount + technique.breathOutCount + technique.holdOnCount) * Float(self.breathCycle + 1))
                self.isRunning = true
                startPreparation()
            }
            if state == .finish {
                captionLabel.isHidden = true
                isRunning = false
                showFinishedBreathingPage()
            }
        }
    }
    
    var breathingStatus: BreathingStatus? {
        didSet {
            guard let technique = technique else { return }
            guard let breathingStat = breathingStatus else { return }
            self.playInstruction()
            titleLabel.text = breathingStat.rawValue.localized()
            captionLabel.text = "\(breatheTime)"
            if breathingStatus == .breatheIn {
                breatheTime = technique.breathInCount
                if technique.breathingName == "4-7-8" {
                    setHapticForASecond(duration: Float(technique.breathInCount))
                    firstStateAnimationImageView.image = UIImage.animatedImage(with: breatheInAnimation.reversed(), duration: TimeInterval((Double(technique.breathInCount) + 0.6)))
                } else if technique.breathingName == "7-11" {
                    setHapticForASecond(duration: Float(technique.breathInCount))
                    firstStateAnimationImageView.image = UIImage.animatedImage(with: breatheInAnimation.reversed(), duration: TimeInterval((Double(technique.breathInCount) + 0.3 + 0.10)))
                } else {
                    setHapticForASecond(duration: Float(technique.breathInCount))
                    firstStateAnimationImageView.image = UIImage.animatedImage(with: breatheInAnimation.reversed(), duration: Double(technique.breathInCount) + 0.4)
                }
            }
            else if breathingStatus == .breatheOut {
                breatheTime = technique.breathOutCount
                firstStateAnimationImageView.image = UIImage.animatedImage(with: breatheInAnimation, duration: TimeInterval((Double(technique.breathOutCount) + 0.3 + 0.09)))
                
            }
            else if breathingStatus == .holdBreathe {
                breatheTime = technique.holdOnCount
                firstStateAnimationImageView.image = UIImage.animatedImage(with: breatheHoldAnimation, duration: TimeInterval((Double(technique.holdOnCount) + 0.3 + 0.09)))
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
    
    // MARK: - Computed Propertiesa
    var technique: BreathingModel? {
        didSet {
            guard let technique = technique else { return }
            breathingLabel.text = technique.breathingName
            breatheTechniqueGoalLabel.text = technique.breathGoal
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
        setupLocalization()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupNavigationBar()
        setupFirstBreathingScreen()
        setupToDefaultBreathingTechnique()
        setupLocalization()
        
    }
    
    // MARK: - Setup View for ViewController
    
    private func setupView() {
        switch state {
        case .beforeBreathing:
            setupViewForState(topView: false, titleLabel: false, captionLabel: true, breathingMethodeStackView: false, circularProgressBar: true, endButton: true, breathingChoiceView: false)
        case .breathingOn:
            setupViewForState(topView: true, titleLabel: false, captionLabel: true, breathingMethodeStackView: true, circularProgressBar: false, endButton: false, breathingChoiceView: true)
        case .pause:
            setupViewForState(topView: false, titleLabel: false, captionLabel: true, breathingMethodeStackView: true, circularProgressBar: false, endButton: false, breathingChoiceView: true)
            firstStateAnimationImageView.image = UIImage(named: "breatheOut329")
            titleLabel.text = "Paused".localized()
        case .finish:
            setupViewForState(topView: false, titleLabel: false, captionLabel: false, breathingMethodeStackView: false, circularProgressBar: true, endButton: true, breathingChoiceView: false)
            circularProgressBar.progress = 0
            healthKitManager.saveMeditation(startDate: startDate, seconds: mindfulnessMinutes)
            minutesTimer = 0
            secondsTimer = 0
            firstStateAnimationImageView.image = UIImage(named: "breatheOut329")
            titleLabel.text = "Tap to start again".localized()
            DispatchQueue.main.async {
                self.captionLabel.text = "Yay, you’ve finished your breathing exercise!".localized()
            }
        }
    }
    
    func setupFirstBreathingScreen() {
        if UserDefaults.standard.bool(forKey: "isNotFirstBreathingScreen") {
            isFirstBreathingScreen = false
            overlayImageView.isHidden = true
        } else {
            isFirstBreathingScreen = true
            if defaultLanguage == .en {
                overlayImageView.image = UIImage(named: "Overlay")
            }
            switch defaultLanguage {
            case .en:
                overlayImageView.image = UIImage(named: defaultLanguage.rawValue)
            default:
                overlayImageView.image = UIImage(named: defaultLanguage.rawValue)
            }
            overlayImageView.isHidden = false
        }
    }
    
    func setupLocalization(){
        titleLabel.text = "Tap to start".localized()
        prepareLabel.text = "Be still, and bring your attention to your breath.".localized()
        captionLabel.text = "Yay, you’ve finished your breathing exercise!".localized()
        endBreathingButton.setTitle("End".localized(), for: .normal)
        breatheTechniqueGoalLabel.reloadText()
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
            //self.setHapticForASecond(duration: 10)
            self.navigateToSettings()
        }
        
        closeView.onTap {
            self.preparation?.invalidate()
            self.breathing?.invalidate()
            self.state = .finish
        }
        
        endBreathingButton.onTap {
            self.breathing?.invalidate()
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
        
        topChevronView.onTap {
            self.showBreathingChoiceModal()
        }
        
        overlayImageView.onTap {
            self.overlayImageView.isHidden = true
            self.isFirstBreathingScreen = false
            UserDefaults.standard.setValue(true, forKey: "isNotFirstBreathingScreen")
        }
        
        if state == .beforeBreathing {
            centreAnimationView.onTap {
                if self.isRunning == false {
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
        
        for frame in (0...329){
            breatheInAnimation.append(UIImage(named: String(format: "breatheOut%d", frame))!)
        }
        for frame in (0...349){
            breatheHoldAnimation.append(UIImage(named: String(format: "Hold%d", frame))!)
        }
    }
    
    
    // MARK: - Functionality
    
    func setupViewForState(topView: Bool, titleLabel: Bool, captionLabel: Bool, breathingMethodeStackView: Bool, circularProgressBar: Bool, endButton: Bool, breathingChoiceView: Bool) {
        self.topView.isHidden = topView
        self.titleLabel.isHidden = titleLabel
        self.captionLabel.isHidden = captionLabel
        self.breathingMethodStackView.isHidden = breathingMethodeStackView
        self.circularProgressBar.isHidden = circularProgressBar
        self.closeView.isHidden = true
        self.endBreathingButton.isHidden = endButton
        self.breathingChoiceView.isHidden = breathingChoiceView
    }
    
    func navigateToSettings() {
        let vc = SettingsViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func showBreathingChoiceModal() {
        let vc = BreathingChoiceViewController(entryPoint: .homePage)
        
        vc.selected = self.technique
        
        vc.changeBreathingTechnieque = { newBreathingTechnique in
            self.technique = newBreathingTechnique
        }
        
        self.navigationController?.present(vc, animated: true, completion: nil)
    }
    
    func showFinishedBreathingPage() {
        let vc = BreatheFinishedViewController()
        
        vc.finishBreathing = {
            self.state = .beforeBreathing
        }
        
        vc.repeatBreathing = {
            self.state = .breathingOn
        }
        
        
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .overCurrentContext
        self.navigationController?.present(nav, animated: true, completion: nil)
    }
    
    
    func startPreparation() {
        if state == .breathingOn {
            prepareLabel.isHidden = false
            endBreathingButton.isHidden = true
            titleLabel.countFrom(CGFloat(countdownTime + 1), to: 1, withDuration: 3.0)
            titleLabel.completionBlock = {
                self.startBreathing()
                self.endBreathingButton.isHidden = false
                self.prepareLabel.isHidden = true
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
        } else if breathingStatus == .breatheIn {
            captionLabel.countFrom(CGFloat(techniqueCount.breathInCount + 1), to: 1, withDuration: (Double(techniqueCount.breathInCount)))
        } else if breathingStatus == .holdBreathe {
            captionLabel.countFrom(CGFloat(techniqueCount.holdOnCount + 1), to: 1, withDuration: (Double(techniqueCount.holdOnCount)))
        }
    }
    
    func setHapticForASecond(duration: Float) {
        print(duration)
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
        if breathingStatus == .holdBreathe{
            setHapticForASecond(duration: 1.0)
        }
        
        
        counter += 1
        //print(counter)
        
        // MARK: - TODO: CGFloat(progress) not counting (0,0), so the circularProgressBar still 0.2
        circularProgressBar.progress += CGFloat(progress)
        captionLabel.isHidden = false
        
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
        if UserDefaults.standard.bool(forKey: "defaultAudioState") {
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
            do {
                player = try AVAudioPlayer(contentsOf: url)
                player?.play()
            } catch let error {
                print(error.localizedDescription)
            }
        }
    }
    
    func getSentMessagePopUp() {
        let view = MessageView.viewFromNib(layout: .cardView)
        view.configureTheme(.success)
        view.configureTheme(backgroundColor: UIColor(named: "Main")!, foregroundColor: .white)
        view.button?.isHidden = true
        view.configureContent(title: nil, body: "Whatsapp message to your emergency contact has been sent", iconImage: nil, iconText: nil, buttonImage: nil, buttonTitle: nil, buttonTapHandler: nil)
        view.configureDropShadow()
        view.layoutMarginAdditions = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        SwiftMessages.show(view: view)
    }
    
    func getNoContactPopUp() {
        let view = MessageView.viewFromNib(layout: .cardView)
        view.configureTheme(.error)
        view.button?.isHidden = true
        view.configureContent(title: nil, body: "You haven't added your emergency contact yet", iconImage: nil, iconText: nil, buttonImage: nil, buttonTitle: nil, buttonTapHandler: nil)
        view.configureDropShadow()
        view.layoutMarginAdditions = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        SwiftMessages.show(view: view)
    }
    
    private func getEmergencyContact() -> [EmergencyContactModel]? {
        // Get Emergency Contact Number in userDefaults
        if let data = UserDefaults.standard.data(forKey: "defaultEmergencyContact") {
            do {
                let decoder = JSONDecoder()
                let emergencyContact = try decoder.decode([EmergencyContactModel].self, from: data)
                return emergencyContact
            } catch {
                print("Unable to Decode (\(error))")
                return nil
            }
        }
        
        return nil
    }
}

extension BreathingViewController {
    func openUsingScheme() {
        let emergencyContact = getEmergencyContact()
        guard let contact = emergencyContact, contact.count != 0 else {
            getNoContactPopUp()
            return
        }
        getSentMessagePopUp()
        appDelegate.sendMessage()
        print("opening from scheme")
    }
}
