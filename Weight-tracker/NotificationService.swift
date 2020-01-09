//
//  NotificationServiceImpl.swift
//  Weight-tracker
//
//  Created by Vadim Labun on 11/7/19.
//  Copyright © 2019 Vadim Labun. All rights reserved.
//

import Foundation
import UserNotifications
import UIKit

enum NotificationAuthorizationStatus {
    case enabled
    case disabled
    case provisional
    case notDetermined
}

class NotificationService: NSObject {
    
    
    func registerAuthorization(provisional: Bool, _ completion: @escaping () -> Void) {
        var authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        if #available(iOS 12.0, *), provisional {
            authOptions.insert(.provisional)
        }
        UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: { (granted, _) in
                DispatchQueue.main.async {
                    if granted {
                        UIApplication.shared.registerForRemoteNotifications()
                    }
                    completion()
                }
        })
        
        UNUserNotificationCenter.current().delegate = self
    }
    
    func getAuthorizationStatus(_ completion: @escaping (NotificationAuthorizationStatus) -> Void) {
        UNUserNotificationCenter.current().getNotificationSettings(completionHandler: { settings in
            DispatchQueue.main.async {
                let status = NotificationAuthorizationStatus(unAuthorizationStatus: settings.authorizationStatus)
                completion(status)
            }
        })
    }
    
    func enableNotification(_ isEnable: Bool, completion: @escaping ()->()) {

        getAuthorizationStatus { [weak self] status in
            guard let `self` = self else { return }

            switch status {
            case .notDetermined:
                self.registerAuthorization(provisional: false) {
                    completion()
                }
            default:
                if let url = URL(string: UIApplication.openSettingsURLString) {
                    if UIApplication.shared.canOpenURL(url) {
                        _ =  UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    }
                }
            }
        }
    }
}

extension NotificationService: UNUserNotificationCenterDelegate {
    
}

private extension NotificationAuthorizationStatus {
    init(unAuthorizationStatus: UNAuthorizationStatus) {
        switch unAuthorizationStatus {
        case .authorized:
            self = .enabled
        case .provisional:
            self = .provisional
        case .denied:
            self = .disabled
        case .notDetermined:
            self = .notDetermined
            #if swift(>=5.0)
        @unknown default:
            assertionFailure()
            self = .notDetermined
            #endif
        }
    }
}
