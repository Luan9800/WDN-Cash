//
//   NotificationDelegate.swift
//  WDN Cash Watch App
//
//  Created by Luan Carlos on 18/01/26.
//

import Combine
import WatchKit
import Foundation
import UserNotifications


final class NotificationDelegate: NSObject, UNUserNotificationCenterDelegate {

    static let shared = NotificationDelegate()

    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler:
        @escaping (UNNotificationPresentationOptions)
    ) {
        completionHandler([.banner, .sound])
    }
}

