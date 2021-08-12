//
//  AlertView.swift
//  PanicAway
//
//  Created by Pegipegi on 07/08/21.
//

import UIKit

class AlertView: NSObject {

    class func showAlertComingSoonFeature(view: UIViewController , message: String) {
        let alert = UIAlertController(title: "Coming soon", message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))

        view.present(alert, animated: true, completion: nil)
    }
}
