//
//  LocalizationMenuViewController.swift
//  PanicAway
//
//  Created by Javier Fransiscus on 23/08/21.
//

import Foundation
import UIKit

private let userLanguageKey = "applicationKey"
class LocalizationMenuViewController: UIViewController{
    
    var pickerData: [String] = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        pickerData = ["en","id"]
        print(UserDefaults.standard.string(forKey: userLanguageKey))
        
        
        self.navigationController?.navigationBar.isHidden = true
    }
    
    
    @IBAction func confirmSelectedLanguange(_ sender: Any) {
        navigateToProductShowcase()
    }
    
    func navigateToProductShowcase() {
        let vc = ProductShowcaseViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func setLanguange(language: String) {
        //Ini jangan lupa di ganti
        UserDefaults.standard.set(language, forKey: userLanguageKey)
        print("setting languange with this langunage \(language)")
    }
}

extension String{
    func localized() ->String {
        let selectedLanguage = UserDefaults.standard.string(forKey: userLanguageKey)
        let path = Bundle.main.path(forResource: selectedLanguage, ofType: "lproj")
        let bundle = Bundle(path: path!)
        
        return NSLocalizedString(self, tableName: nil, bundle: bundle!, value: "", comment: "")
        
    }
}
