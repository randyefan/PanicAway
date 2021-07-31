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
    private var data = BreathingLoader()
    private var entryPoint: BreathingChoiceEntryPoint?
    private var selected: BreathingModel?
    
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
        data.loadDataBreath()
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
        guard let _ = selected else { return }
        setSelectedBreathingTechnique()
        navigateToEmergencyContact()
    }
    
    // MARK: - Functionality
    
    private func navigateToEmergencyContact() {
        let vc = EmergencyContactViewController(entryPoint: .onBoarding)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func setSelectedBreathingTechnique() {
        if let selected = selected {
            UserDefaults.standard.setValue(selected.id, forKey: "defaultBreatheId")
        }
    }
    
}

// MARK: - UITABLEVIEW DATA SOURCE & UITABLEVIEW DELEGATE

extension BreathingChoiceViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        data.entries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "BreathingTechniqueCell", for: indexPath) as? BreathingTechniqueCell {
            
            if let selected = selected, indexPath.row == selected.id {
                cell.setSelected(true, animated: true)
            }
            
            cell.indexPath = indexPath
            cell.model = data.entries[indexPath.row]
            cell.selectionStyle = .none
            return cell
            
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selected = data.entries[indexPath.row]
    }
}
