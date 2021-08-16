//
//  LocalNotificationManager.swift
//  MinHall
//
//  Created by 박종석 on 2021/08/15.
//

import Foundation
import UserNotifications


class LocalNotificationManager {
    func requestPermission() {
        let notificationCenter = UNUserNotificationCenter.current()
        
        notificationCenter.getNotificationSettings { settings in
            switch settings.authorizationStatus {
            case .notDetermined:
                notificationCenter.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
                    if granted == true && error == nil {
                        // We have permission!
                    }
                }
            default:
                break
            }
        }
    }
    
    func scheduleNotification(title: String, body: String, hour: Int, minute: Int) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default
        
        var date = DateComponents()
        date.hour = hour
        date.minute = minute
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: date, repeats: false)

        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        UNUserNotificationCenter.current().add(request) { error in
            guard error == nil else { return }
        }
    }
}
