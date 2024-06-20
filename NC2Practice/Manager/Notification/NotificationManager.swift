//
//  NotificationManager.swift
//  NC2Practice
//
//  Created by 신혜연 on 6/20/24.
//

import UserNotifications

class NotificationManager: NSObject, ObservableObject, UNUserNotificationCenterDelegate {
    static let shared = NotificationManager()
    
    private override init() {
        super.init()
        let center = UNUserNotificationCenter.current()
        center.delegate = self
    }

    func requestNotificationPermission() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            } else {
                print("Permission granted: \(granted)")
            }
        }
    }

    func scheduleLocalNotification() {
        let content = UNMutableNotificationContent()
        content.title = "띠딕빨래"
        content.body = "세탁이 완료되었어요!" //세탁,건조 구분 필요
        content.sound = UNNotificationSound.default

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 0.1, repeats: false) //타이머 완료 후 1초 뒤에 푸쉬 알림 전송. 필요에 따라 timeInterval 수정
        
        let userInfo: [AnyHashable: Any] = ["showFinishingView": true]
            content.userInfo = userInfo
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

        let center = UNUserNotificationCenter.current()
        center.add(request) { error in
            if let error = error {
                print("Error adding notification: \(error.localizedDescription)")
            } else {
                print("Notification scheduled successfully")
            }
        }
    }

    // MARK: UNUserNotificationCenterDelegate 메서드
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound, .badge])
    }
}
