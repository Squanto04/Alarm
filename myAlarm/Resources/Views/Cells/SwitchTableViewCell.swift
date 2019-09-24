//
//  SwitchTableViewCell.swift
//  myAlarm
//
//  Created by Jordan Lamb on 9/23/19.
//  Copyright © 2019 trevorAdcock. All rights reserved.
//

import UIKit

// Set 1 of 5
protocol AlarmTableViewCellDelegate: class {
    func enabledValueChanged(_ cell: SwitchTableViewCell, selected: Bool)
}

class SwitchTableViewCell: UITableViewCell {
    
    // Landing Pad
    var alarm: Alarm? {
        didSet {
            updateViews()
        }
    }
    
    // Step 2 of 5
    weak var delegate: AlarmTableViewCellDelegate?
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var alarmSwitch: UISwitch!
    
    
    // MARK: -Actions
    @IBAction func alarmSwitch(_ sender: Any) {
        delegate?.enabledValueChanged(self, selected: alarmSwitch.isOn)
        AlarmController.sharedInstance.savetoPresistantStore()
    }

    func updateViews() {
        guard let alarm = alarm else { return }
        nameLabel.text = alarm.alarmName
        timeLabel.text = alarm.fireTimeAsString
        alarmSwitch.isOn = alarm.enabled
    }
}
