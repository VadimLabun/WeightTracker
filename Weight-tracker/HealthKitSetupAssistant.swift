//
//  HealthKitSetupAssistant.swift
//  Weight-tracker
//
//  Created by Vadim Labun on 11/12/19.
//  Copyright © 2019 Vadim Labun. All rights reserved.
//

import Foundation
import HealthKit

private enum HealthkitSetupError: Error {
    case notAvailableOnDevice
    case dataTypeNotAvailable
}

enum HealthKitStoreState {
    case enabled
    case disabled
}

class HealthKitSetupAssistant {
    
    let healthKitStore: HKHealthStore = HKHealthStore()
    
    static let assistent: HealthKitSetupAssistant = HealthKitSetupAssistant()
    
    private init() {}
    
    func authorizeHealthKit(completion: @escaping (Bool, Error?) -> Swift.Void) {
        guard HKHealthStore.isHealthDataAvailable() else {
            completion(false, HealthkitSetupError.notAvailableOnDevice)
            return print(completion)
        }
        guard let bodyMassIndex = HKObjectType.quantityType(forIdentifier: .bodyMassIndex),
            let height = HKObjectType.quantityType(forIdentifier: .height),
            let bodyMass = HKObjectType.quantityType(forIdentifier: .bodyMass)
            else {
                
                completion(false, HealthkitSetupError.dataTypeNotAvailable)
                return
        }
        let healthKitTypesToWrite: Set<HKSampleType> = [bodyMassIndex,
                                                        height,
                                                        bodyMass]
        
        let healthKitTypesToRead: Set<HKObjectType> = [bodyMassIndex,
                                                       height,
                                                       bodyMass]
        
        healthKitStore.requestAuthorization(toShare: healthKitTypesToWrite,
                                            read: healthKitTypesToRead) { (success, error) in
                                                DispatchQueue.main.async {
                                                    completion(success, error)
                                                }
                                                
        }
    }
    
    func seveWeight(weight: Double, date: Date) {
        
        guard let bodyMassType = HKQuantityType.quantityType(forIdentifier: .bodyMass) else {
            fatalError("Body Mass Type is no longer available in HealthKit")
        }
        
        let bodyMassQuantity = HKQuantity(unit: HKUnit.gramUnit(with: .kilo), doubleValue: weight)
        let bodyMassSample = HKQuantitySample(type: bodyMassType,
                                              quantity: bodyMassQuantity,
                                              start: date,
                                              end: date)
        
        healthKitStore.save(bodyMassSample) { (success, error) in
            if let error = error {
                print("Error Saving weight Sample: \(error.localizedDescription)")
            } else {
                print("Successfully saved weight Sample")
            }
        }
    }
    
    func seveHeight(height: Double, date: Date) {
        
        guard let heightType = HKQuantityType.quantityType(forIdentifier: .height) else {
            fatalError("Body Mass Type is no longer available in HealthKit")
        }
        
        let heightQuantity = HKQuantity(unit: HKUnit.meterUnit(with: .centi), doubleValue: height)
        let heightSample = HKQuantitySample(type: heightType,
                                            quantity: heightQuantity,
                                            start: date,
                                            end: date)
        
        healthKitStore.save(heightSample) { (success, error) in
            if let error = error {
                print("Error Saving Height Sample: \(error.localizedDescription)")
            } else {
                print("Successfully saved Height Sample")
            }
        }
    }
    
    func seveBodyMassIndex(bodyMassIndex: Double, date: Date) {
        
        guard let bodyMassIndexType = HKQuantityType.quantityType(forIdentifier: .bodyMassIndex) else {
            fatalError("Body Mass Index Type is no longer available in HealthKit")
        }
        
        let bodyMassIndexQuantity = HKQuantity(unit: HKUnit.count(), doubleValue: bodyMassIndex)
        let bodyMassIndexSample = HKQuantitySample(type: bodyMassIndexType,
                                                   quantity: bodyMassIndexQuantity,
                                                   start: date,
                                                   end: date)
        
        healthKitStore.save(bodyMassIndexSample) { (success, error) in
            if let error = error {
                print("Error Saving Body Mass Index Sample: \(error.localizedDescription)")
            } else {
                print("Successfully saved Body Mass Index Sample")
            }
        }
    }
    
    func determineState() -> HealthKitStoreState  {
        let bodyMass = HKObjectType.quantityType(forIdentifier: .bodyMass)!
            let state = healthKitStore.authorizationStatus(for: bodyMass)
        if state == .sharingAuthorized {
            return .enabled
        } else {
            return .disabled
        }
    }
    
    
}
