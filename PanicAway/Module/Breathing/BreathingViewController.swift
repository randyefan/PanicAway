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

class BreathingViewController: UIViewController {
    // MARK: - IBOutlet
    
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var circularProgressBar: CircularProgressBar!
    @IBOutlet weak var settingsView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var leftChevronView: UIView!
    @IBOutlet weak var breathingLabel: UILabel!
    @IBOutlet weak var rightChevronView: UIView!
    @IBOutlet weak var safeAreaView: UIView!
    @IBOutlet weak var breathingMethodStackView: UIStackView!
    
    // MARK: - Variable
    
    var state: BreathingState = .beforeBreathing
    var countdownTime = 3
    var breatheTime = 0 // Handle With data from model later! (REQUIRED)
    
    // MARK: - Variable DisplayLink (For working with timer)
    
    var preparation: CADisplayLink?
    var breathing: CADisplayLink?
    
    // MARK: - ViewController LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupObserveAction()
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
    
    func setupNavigationBar() {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    private func setupObserveAction() {
        settingsView.onTap {
            self.navigateToSettings()
        }
        
        leftChevronView.onTap {
            // Handle change breathing method
        }
        
        rightChevronView.onTap {
            // Handle change breathing method
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
