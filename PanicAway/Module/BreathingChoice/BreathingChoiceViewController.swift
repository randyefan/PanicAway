//
//  BreathingChoiceViewController.swift
//  PanicAway
//
//  Created by Randy Efan Jayaputra on 27/07/21.
//

import UIKit

// MARK: - ENUM For Entry Point

enum BreathingChoiceEntryPoint {
    case onBoarding
    case settings
}

class BreathingChoiceViewController: UIViewController {
    // MARK: - IBOutlet
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var buttonSelect: UIButton!
    @IBOutlet weak var buttonView: UIView!
    
    // MARK: - Variable
    
    private var entryPoint: BreathingChoiceEntryPoint?
    
    // MARK: - Initializer (Required)
    init(entryPoint: BreathingChoiceEntryPoint) {
        super.init(nibName: "BreathingChoiceViewController", bundle: nil)
        self.entryPoint = entryPoint
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - ViewController LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupView()
    }
    
    // MARK: - Setup Function for ViewController
    
    func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.register(UINib(nibName: "BreathingTechniqueCell", bundle: nil), forCellReuseIdentifier: "BreathingTechniqueCell")
    }
    
    func setupView() {
        switch entryPoint {
        case .settings:
            titleLabel.isHidden = true
            buttonView.isHidden = true
        default:
            self.navigationController?.navigationBar.isHidden = true
        }
    }
    
    // MARK: - Action Triggered
    
    @IBAction func selectAction(_ sender: Any) {
        navigateToEmergencyContact()
    }
    
    // MARK: - Functionality
    
    private func navigateToEmergencyContact() {
        let vc = EmergencyContactViewController(entryPoint: .onBoarding)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

// MARK: - UITABLEVIEW DATA SOURCE & UITABLEVIEW DELEGATE

extension BreathingChoiceViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "BreathingTechniqueCell", for: indexPath) as? BreathingTechniqueCell {
            cell.indexPath = indexPath
            cell.selectionStyle = .none
            return cell
        }
        return UITableViewCell()
    }
}
