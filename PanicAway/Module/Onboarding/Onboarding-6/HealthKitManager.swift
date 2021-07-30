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
            
            let readTypes =  Set([HKObjectType.categoryType(forIdentifier: .highHeartRateEvent)!])
            
            let writeTypes =  Set([HKObjectType.categoryType(forIdentifier: .mindfulSession)!])
            
            healthStore.requestAuthorization(toShare: writeTypes, read: readTypes as! Set<HKObjectType>) { (success, error) -> Void  in
                
            }
            
            
        }
        completion()
    }
    
    func saveMeditation(startDate:Date, minutes:UInt){
        let mindfulType = HKCategoryType.categoryType(forIdentifier: .mindfulSession)
               let mindfulSample = HKCategorySample(type: mindfulType!, value: 0, start: Date.init(timeIntervalSinceNow: -(15*60)), end: Date())
        healthStore.save(mindfulSample) { success, error in
                   if(error != nil) {
                       abort()
                   }
               }
    }
}
