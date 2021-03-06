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
    
    
    @IBOutlet weak var titleView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var buttonSelect: UIButton!
    @IBOutlet weak var buttonView: UIView!
    
    // MARK: - Variable
    private var data = BreathingLoader()
    private var entryPoint: BreathingChoiceEntryPoint?
    var selected: BreathingModel?
    
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
        setupSelectedCell()
    }
    
    // MARK: - Setup Function for ViewController
    
    func setupSelectedCell() {
        if let selected = selected {
            tableView.selectRow(at: IndexPath(row: selected.id, section: 0), animated: true, scrollPosition: .none)
        }
    }
    
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
            title = "Breathing Method"
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveChanges))
            navigationItem.rightBarButtonItem?.isEnabled = false
            titleView.isHidden = true
            buttonView.isHidden = true
        default:
            buttonSelect.isEnabled = false
            self.navigationController?.navigationBar.isHidden = true
        }
    }
    
    // MARK: - Action Triggered
    
    @IBAction func selectAction(_ sender: Any) {
        guard let _ = selected else { return }
        setSelectedBreathingTechnique()
        setDefaultBreathingCycle()
        navigateToAppleHealthAuthorize()
    }
    
    // MARK: - Functionality
    
    private func navigateToEmergencyContact() {
        let vc = EmergencyContactViewController(entryPoint: .onBoarding)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func navigateToAppleHealthAuthorize() {
        let vc = OnboardingViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func setSelectedBreathingTechnique() {
        if let selected = selected {
            UserDefaults.standard.setValue(selected.id, forKey: "defaultBreatheId")
        }
    }
    
    private func setDefaultBreathingCycle() {
        UserDefaults.standard.setValue(4, forKey: "defaultBreathingCycle")
    }
    
    @objc func saveChanges() {
        setSelectedBreathingTechnique()
        self.navigationController?.popViewController(animated: true)
    }
    
}

// MARK: - UITABLEVIEW DATA SOURCE & UITABLEVIEW DELEGATE

extension BreathingChoiceViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        data.entries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "BreathingTechniqueCell", for: indexPath) as? BreathingTechniqueCell {
            
            cell.indexPath = indexPath
            cell.model = data.entries[indexPath.row]
            cell.selectionStyle = .none
            
            return cell
            
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if entryPoint == .settings {
            if selected?.id != indexPath.row {
                navigationItem.rightBarButtonItem?.isEnabled = true
            }
        }
        
        buttonSelect.isEnabled = true
        selected = data.entries[indexPath.row]
    }
}
