//
//  NotifyFriendInterfaceController.swift
//  PanicAway WatchKit Extension
//
//  Created by Javier Fransiscus on 28/07/21.
//

import WatchKit
import Foundation

class NotifyFriendInterfaceController: WKInterfaceController {
    @IBOutlet weak var contactsTable: WKInterfaceTable!
    
    let tableData = ["Feby","Efan","Martin"]
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        loadTableData()
    }
    
    override func willActivate() {
        
    }
    
    override func willDisappear() {
        
    }
    
    private func loadTableData(){
        
        
        contactsTable.setNumberOfRows(tableData.count, withRowType: "ContactRowController")
        
        for(index, rowModel) in tableData.enumerated(){
            
            if let contactRowController = contactsTable.rowController(at: index) as? ContactRowController{
                contactRowController.friendNameLabel.setText(tableData[index])
                
            }
        }
    }
    
}
