//
//  LocalizationMenuViewController.swift
//  PanicAway
//
//  Created by Javier Fransiscus on 23/08/21.
//

import Foundation
import UIKit

private let userLanguangeKey = "applicationKey"
class LocalizationMenuViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
       setLanguange(language: pickerData[row])
        print(pickerData[row])
    }
    
    @IBAction func confirmSelectedLanguange(_ sender: Any) {
        navigateToProductShowcase()
    }
    
    func navigateToProductShowcase() {
        let vc = ProductShowcaseViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBOutlet weak var pickerView: UIPickerView!
    
    var pickerData: [String] = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pickerView.dataSource = self
        pickerView.delegate = self

        // Do any additional setup after loading the view.
        pickerData = ["en","id"]
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    func setLanguange(language: String) {
        
        UserDefaults.standard.set(language, forKey: userLanguangeKey)
    }
}

extension String{
    func localized() ->String {
        let selectedLanguage = UserDefaults.standard.string(forKey: userLanguangeKey)

        let path = Bundle.main.path(forResource: selectedLanguage, ofType: "lproj")
        let bundle = Bundle(path: path!)

        return NSLocalizedString(self, tableName: nil, bundle: bundle!, value: "", comment: "")
    }
}
