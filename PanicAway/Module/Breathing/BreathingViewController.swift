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
    @IBOutlet weak var leftChevronImageView: UIImageView!
    @IBOutlet weak var rightChevronImageView: UIImageView!
    
    // MARK: - Variable
    var data = BreathingLoader()
    var state: BreathingState = .beforeBreathing
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
    
    var preparation: CADisplayLink?
    var breathing: CADisplayLink?
    
    // MARK: - ViewController LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        data.loadDataBreath()
        setupView()
        setupObserveAction()
        setupToDefaultBreathingTechnique()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupNavigationBar()
    }
    
    // MARK: - Setup View for ViewController
    
    private func setupView() {
        switch state {
        case .beforeBreathing:
            setupViewForState(topView: false, titleLabel: false, captionLabel: true, breathingMethodeStackView: false, safeAreaView: true, circularProgressBar: true)
        case .breathingOn:
            setupViewForState(topView: true, titleLabel: false, captionLabel: true, breathingMethodeStackView: true, safeAreaView: false, circularProgressBar: false)
        case .pause:
            setupViewForState(topView: true, titleLabel: false, captionLabel: true, breathingMethodeStackView: true, safeAreaView: false, circularProgressBar: false)
        case .finish:
            setupViewForState(topView: false, titleLabel: false, captionLabel: false, breathingMethodeStackView: false, safeAreaView: true, circularProgressBar: true)
        }
    }
    
    func setupToDefaultBreathingTechnique() {
        let idBreath = UserDefaults.standard.integer(forKey: "defaultBreatheId")
        technique = data.entries[idBreath]
    }
    
    func setupNavigationBar() {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    private func setupObserveAction() {
        settingsView.onTap {
            self.navigateToSettings()
        }
        
        leftChevronImageView.onTap {
            // Handle change breathing method
        }
        
        rightChevronImageView.onTap {
            // Handle change breathing method
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
    
    func setupViewForState(topView: Bool, titleLabel: Bool, captionLabel: Bool, breathingMethodeStackView: Bool, safeAreaView: Bool, circularProgressBar: Bool) {
        self.topView.isHidden = topView
        self.titleLabel.isHidden = titleLabel
        self.captionLabel.isHidden = captionLabel
        self.breathingMethodStackView.isHidden = breathingMethodeStackView
        self.safeAreaView.isHidden = safeAreaView
        self.circularProgressBar.isHidden = circularProgressBar
    }
    
    func navigateToSettings() {
        let vc = SettingsViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func startBreathing() {
        if state == .breathingOn {
            preparation = CADisplayLink(target: self, selector: #selector(runCountDown))
            breathing = CADisplayLink(target: self, selector: #selector(runPreparation))
        }
    }
    
    @objc func runCountDown() {
        // For handle progress
    }
    
    @objc func runPreparation() {
        // For handle countdown preparation
    }
}
