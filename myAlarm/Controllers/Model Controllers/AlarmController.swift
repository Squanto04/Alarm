//
//  AlarmController.swift
//  myAlarm
//
//  Created by Jordan Lamb on 9/23/19.
//  Copyright © 2019 trevorAdcock. All rights reserved.
//

import Foundation
import UserNotifications

protocol AlarmScheduler: class {
    func scheduleUserNotifications(for alarm: Alarm)
    func cancelUserNotifications(for alarm: Alarm)
}

extension AlarmScheduler {
    
    func scheduleUserNotifications(for alarm: Alarm) {
        let notificationContent = UNMutableNotificationContent()
        notificationContent.title = "Alarm"
        notificationContent.body = alarm.alarmName
        notificationContent.sound = UNNotificationSound.default
        let dateComponents = Calendar.current.dateComponents([.hour, .minute], from: alarm.fireDate)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(identifier: alarm.uuid, content: notificationContent, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { (error) in
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                }
        }
        print("Notification Scheduled")
    }
    
    func cancelUserNotifications(for alarm: Alarm) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [alarm.uuid])
        print("Notification Cancelled")
    }
}

class AlarmController: AlarmScheduler {
    
    // Shared Instance
    static let sharedInstance = AlarmController()
    
    // Source of Truth
    var alarms: [Alarm] = []
    
    // CRUD
    
    // Create
    func addAlarm(fireDate: Date, name: String, enabled: Bool) {
        let newAlarm = Alarm(fireDate: fireDate, alarmName: name, enabled: enabled)
        alarms.append(newAlarm)
        scheduleUserNotifications(for: newAlarm)
        savetoPresistantStore()
    }

    // Update
    func updateAlarm(to alarm: Alarm, fireDate: Date, name: String, enabled: Bool) {
        alarm.fireDate = fireDate
        alarm.alarmName = name
        alarm.enabled = enabled
        scheduleUserNotifications(for: alarm)
        savetoPresistantStore()
    }
    
    // Delete
    func deleteAlarm(alarm: Alarm) {
        guard let alarmIndex = alarms.firstIndex(of: alarm) else { return }
        alarms.remove(at: alarmIndex)
        cancelUserNotifications(for: alarm)
        savetoPresistantStore()
    }
    
    // SAVE
    private func fileURL() -> URL {
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let fileName = "myAlarm.json"
        let documentsDirectoryURL = urls[0].appendingPathComponent(fileName)
        return documentsDirectoryURL
    }
    
    func savetoPresistantStore() {
        let jsonEncoder = JSONEncoder()
        do {
            let jsonAlarms = try jsonEncoder.encode(alarms)
            try jsonAlarms.write(to: fileURL())
        } catch let encodingError {
            print("There was an error encoding the data: \(encodingError.localizedDescription)")
        }
    }
    
    func loadFromPresistentStore() {
        let jsonDecoder = JSONDecoder()
        do {
            let jsonData = try Data(contentsOf: fileURL())
            let decodedAlarms = try jsonDecoder.decode([Alarm].self, from: jsonData)
            alarms = decodedAlarms
        } catch let decodedError {
            print("There was an error decoding the data: \(decodedError)")
        }
    }
    
} // End of Class


let mockAlarms: [Alarm] = {
    let alarmOne = Alarm(fireDate: Date(timeIntervalSinceNow: 5000), alarmName: "Alarm One", enabled: true, uuid: "")
    let alarmTwo = Alarm(fireDate: Date(timeIntervalSinceNow: 6000), alarmName: "Alarm Two", enabled: true, uuid: "")
    let alarmThree = Alarm(fireDate: Date(timeIntervalSinceNow: 7000), alarmName: "Alarm Three", enabled: false, uuid: "")
    
    return [alarmOne, alarmTwo, alarmThree]
}()
