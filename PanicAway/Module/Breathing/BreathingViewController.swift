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
    
    var state: BreathingState = .breathingOn
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
    }
    
    // MARK: - Setup View for ViewController
    
    private func setupView() {
        switch state {
        case .beforeBreathing:
            topView.isHidden = false
            titleLabel.isHidden = false
            captionLabel.isHidden = true
            breathingMethodStackView.isHidden = false
            safeAreaView.isHidden = true
            circularProgressBar.isHidden = true
        case .breathingOn:
            topView.isHidden = true
            titleLabel.isHidden = false
            captionLabel.isHidden = true
            breathingMethodStackView.isHidden = true
            safeAreaView.isHidden = false
            circularProgressBar.isHidden = false
        case .pause:
            topView.isHidden = true
            titleLabel.isHidden = false
            captionLabel.isHidden = true
            breathingMethodStackView.isHidden = true
            safeAreaView.isHidden = false
            circularProgressBar.isHidden = false
        case .finish:
            topView.isHidden = false
            titleLabel.isHidden = false
            captionLabel.isHidden = false
            breathingMethodStackView.isHidden = false
            safeAreaView.isHidden = true
            circularProgressBar.isHidden = true
        }
    }
    
    private func setupObserveAction() {
        settingsView.onTap {
            // Handle to go to settings
        }
        
        leftChevronView.onTap {
            // Handle change breathing method
        }
        
        rightChevronView.onTap {
            // Handle change breathing method
        }
    }

    
    // MARK: - Functionality
    
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
