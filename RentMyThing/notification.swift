//
//  notification.swift
//  RentMyThing
//
//  Created by vidit jindal on 20/12/18.
//  Copyright © 2018 vidit jindal. All rights reserved.
//

import Foundation
import UserNotifications
import UIKit

class NOtificationpublish: NSObject{
    func sendnotification(title: String, subtitle: String, body: String, badge: Int?, delayinterval: Int?) {
        let notificationcontent = UNMutableNotificationContent()
        notificationcontent.title = title
        notificationcontent.subtitle = subtitle
        notificationcontent.body = body
        var delaytimetrigger: UNTimeIntervalNotificationTrigger?
        if let delayinterval = delayinterval {
            delaytimetrigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(delayinterval), repeats: false)
        }
        if let badge = badge {
            var currentbadgecontent = UIApplication.shared.applicationIconBadgeNumber
            currentbadgecontent += badge
            notificationcontent.badge = NSNumber(integerLiteral: currentbadgecontent)
        }
        notificationcontent.sound = UNNotificationSound.default
        let request = UNNotificationRequest(identifier: "TestLocalNotification", content: notificationcontent, trigger: delaytimetrigger)
        UNUserNotificationCenter.current().add(request) { (error) in
            if error != nil {
                print(error?.localizedDescription ?? "")
            }
        }
    }
}
extension NOtificationpublish: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void){
        print("This notification is about to be printed")
        completionHandler([.badge, .sound, .alert])
    }
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        switch response.actionIdentifier {
        case UNNotificationDismissActionIdentifier:
            print("The notification was dismissed")
            completionHandler() 
        case UNNotificationDefaultActionIdentifier:
            print("The notification was OPENED")
            completionHandler()
        default:
            print("The Default")
            completionHandler()
        }
    }
}
