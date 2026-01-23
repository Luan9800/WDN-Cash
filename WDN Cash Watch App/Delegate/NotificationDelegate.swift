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

class NotificationDelegate: NSObject, UNUserNotificationCenterDelegate {

    static let shared = NotificationDelegate()

    // Exemplo de método (opcional)
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        completionHandler()
    }
}



