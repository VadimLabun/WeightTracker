//
//  SettingsItems.swift
//  Weight-tracker
//
//  Created by Vadim Labun on 11/6/19.
//  Copyright © 2019 Vadim Labun. All rights reserved.
//

import Foundation
import UserNotifications

enum Settings {
    
    enum State {
        case waiting
        case enabled
        case disabled
    }
    
    case units
    case height
    case notification(state: State)
    case accessToHealth(state: HealthKitStoreState)
    case privacyPolicy
    case tellAFriend
    case rateUs
    var name: String {
        switch self {
        case .units:
            return R.string.locolazible.settingsItemUnits()
        case .notification:
            return R.string.locolazible.settingsItemEnableNotification()
        case .privacyPolicy:
            return R.string.locolazible.settingsItemPrivacyPolicy()
        case .tellAFriend:
            return R.string.locolazible.settingsItemTellAFriend()
        case .rateUs:
            return R.string.locolazible.settingsItemRateUs()
        case .height:
            return R.string.locolazible.settingsItemHeight()
        case .accessToHealth:
            return R.string.locolazible.settingsItemAccessToHealth()
        }
    }
}


