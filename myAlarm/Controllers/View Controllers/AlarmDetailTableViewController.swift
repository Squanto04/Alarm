//
//  AlarmDetailTableViewController.swift
//  myAlarm
//
//  Created by Jordan Lamb on 9/23/19.
//  Copyright © 2019 trevorAdcock. All rights reserved.
//

import UIKit

class AlarmDetailTableViewController: UITableViewController {

    var alarm: Alarm?
    var alarmIsOn = true
    
    // MARK: - Outlets
    @IBOutlet weak var alarmTimePicker: UIDatePicker!
    @IBOutlet weak var alarmNameTextField: UITextField!
    @IBOutlet weak var disableButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }
    
    
    // MARK: - Actions
    @IBAction func enableButtonTapped(_ sender: Any) {
        guard let alarm = alarm else { return }
        if alarmIsOn == true {
            alarmIsOn = false
            disableButton.setTitle("Enable", for: .normal)
            AlarmController.sharedInstance.scheduleUserNotifications(for: alarm)
        } else {
            alarmIsOn = true
            disableButton.setTitle("Disable", for: .normal)
            AlarmController.sharedInstance.cancelUserNotifications(for: alarm)
        }
    }
    
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        guard let alarmName = alarmNameTextField.text,
        let alarmTime = alarmTimePicker?.date,
        !alarmName.isEmpty
            else { return }
        
        if let alarm = alarm {
            AlarmController.sharedInstance.updateAlarm(to: alarm, fireDate: alarmTime, name: alarmName, enabled: alarmIsOn)
        } else {
            AlarmController.sharedInstance.addAlarm(fireDate: alarmTime, name: alarmName, enabled: alarmIsOn)
        }
        
        navigationController?.popViewController(animated: true)
    }

    
    private func updateViews() {
        guard let alarm = alarm else { return }
        alarmTimePicker.date = alarm.fireDate
        alarmNameTextField.text = alarm.alarmName
        self.title = alarm.alarmName
        self.alarmIsOn = alarm.enabled
        if alarmIsOn == true {
            disableButton.setTitle("Disable", for: .normal)
        } else {
            disableButton.setTitle("Enable", for: .normal)
        }
    }
}
