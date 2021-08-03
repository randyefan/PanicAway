//
//  BreathingViewController.swift
//  PanicAway
//
//  Created by Randy Efan Jayaputra on 26/07/21.
//

import UIKit

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
                breathingStatus = .breatheIn
            }
        }
    }
    
    var breathingStatus: BreathingStatus? {
        didSet {
            guard let technique = technique else { return }
            if breathingStatus == .breatheIn {
                breatheTime = technique.breathInCount
                startPreparation()
            }
        }
    }
    var countdownTime = 3
    var breatheTime = 0 // Handle With data from model later! (REQUIRED)
    
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
        circularProgressBar.progress = 0.5
        data.loadDataBreath()
        setupView()
        setupObserveAction()
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
                self.state = .breathingOn
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
        if state == .breathingOn {
            preparation = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(runPreparation), userInfo: nil, repeats: true)
            RunLoop.current.add(preparation!, forMode: .common)
        }
    }
    
    func startBreathing() {
        if state == .breathingOn {
            breathing = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(runCountDown), userInfo: nil, repeats: true)
            RunLoop.current.add(breathing!, forMode: .common)
        }
    }
    
    @objc func runCountDown() {
        guard let breathingStat = breathingStatus else { return }
        guard let technique = technique else { return }
        
        titleLabel.isHidden = false
        captionLabel.isHidden = false
        titleLabel.text = breathingStat.rawValue
        captionLabel.text = "\(breatheTime)"
        
        if breatheTime == 0 {
            if breathingStatus == .breatheIn {
                breatheTime = technique.holdOnCount
                if breatheTime != 0 {
                    self.breathingStatus = .holdBreathe
                } else {
                    breatheTime = technique.breathOutCount
                    self.breathingStatus = .breatheOut
                }
                
            }
            
            else if breathingStatus == .holdBreathe {
                breatheTime = technique.breathOutCount
                self.breathingStatus = .breatheOut
            }
            
            else if breathingStatus == .breatheOut {
                state = .finish
                breathing?.invalidate()
                setupView()
                return
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
}
