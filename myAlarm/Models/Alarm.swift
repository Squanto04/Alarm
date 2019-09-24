//
//  Alarm.swift
//  myAlarm
//
//  Created by Jordan Lamb on 9/23/19.
//  Copyright © 2019 trevorAdcock. All rights reserved.
//

import Foundation

class Alarm: Codable {
    var fireDate: Date
    var alarmName: String
    var enabled: Bool
    var uuid: String
    var fireTimeAsString: String {
            let timeFormat = DateFormatter()
            timeFormat.dateStyle = .none
            timeFormat.timeStyle = .short
            return timeFormat.string(from: fireDate)
        }
    
    init(fireDate: Date, alarmName: String, enabled: Bool = true, uuid: String = UUID().uuidString) {
        self.fireDate = fireDate
        self.alarmName = alarmName
        self.enabled = enabled
        self.uuid = uuid
    }

}// End of class


extension Alarm: Equatable {
    static func == (lhs: Alarm, rhs: Alarm) -> Bool {
        return lhs.alarmName == rhs.alarmName && lhs.fireDate == rhs.fireDate
    }
}
