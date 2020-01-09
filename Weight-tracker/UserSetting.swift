//
//  CustomSetting.swift
//  Weight-tracker
//
//  Created by Vadim Labun on 11/4/19.
//  Copyright © 2019 Vadim Labun. All rights reserved.
//

import UIKit

enum Unit: String {
    case pounds
    case kilograms
}


class UserSettings {
    
    static let shared = UserSettings()
    
    init() {
        let rawValue = UserDefaults.standard.value(forKey: "unit") as? String ?? Unit.kilograms.rawValue
        let emumPosition = Unit(rawValue: rawValue)
        unit = emumPosition
        height = UserDefaults.standard.value(forKey: "height") as? Int
        oldWeight = StorageManager.getPenultimateWeight()?.weight
        isOnboardingCompleted = UserDefaults.standard.bool(forKey: "isOnboardingCompleted")
    }
    
    var unit: Unit? {
        didSet{
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "unit changed"), object: nil)
            UserDefaults.standard.setValue(UserSettings.shared.unit?.rawValue, forKey: "unit")
        }
    }
    
    var height: Int? {
        didSet {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "height changed"), object: nil)
            UserDefaults.standard.set(UserSettings.shared.height, forKey: "height")
            if let height = height {
                HealthKitSetupAssistant.assistent.seveHeight(height: Double(height), date: Date())
            }
        }
    }
    
    var oldWeight: Double?
    
    var isOnboardingCompleted: Bool = false {
        didSet {
          UserDefaults.standard.set(isOnboardingCompleted, forKey: "isOnboardingCompleted")
        }
    }
}

