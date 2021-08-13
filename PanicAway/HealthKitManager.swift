//
//  HealthKitManager.swift
//  PanicAway
//
//  Created by Javier Fransiscus on 30/07/21.
//

import Foundation
import UIKit
import HealthKit

class HealthKitManager{
    let healthStore = HKHealthStore()
    
    func authorizeHealthKit(completion: () -> Void){
        
        if HKHealthStore.isHealthDataAvailable(){
            
            let writeTypes =  Set([HKObjectType.categoryType(forIdentifier: .mindfulSession)!])
            
            healthStore.requestAuthorization(toShare: writeTypes, read: nil) { (success, error) -> Void  in
                
            }
            
        }
        completion()
    }
    
    func saveMeditation(startDate:Date, seconds:Double){
        let mindfulType = HKCategoryType.categoryType(forIdentifier: .mindfulSession)
        let mindfulSample = HKCategorySample(type: mindfulType!, value: 0, start: startDate, end: startDate.addingTimeInterval(seconds))
        healthStore.save(mindfulSample) { success, error in
                   if(error != nil) {
                       abort()
                   }
               }
    }
}
