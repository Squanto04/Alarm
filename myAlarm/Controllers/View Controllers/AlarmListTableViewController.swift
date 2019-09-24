//
//  AlarmListTableViewController.swift
//  myAlarm
//
//  Created by Jordan Lamb on 9/23/19.
//  Copyright © 2019 trevorAdcock. All rights reserved.
//

import UIKit

class AlarmListTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AlarmController.sharedInstance.alarms.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "alarmsCell", for: indexPath) as? SwitchTableViewCell
        let alarm = AlarmController.sharedInstance.alarms[indexPath.row]
        cell?.alarm = alarm
        
        // Step 5 of 5
        cell?.delegate = self
        
        return cell ?? UITableViewCell()
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let alarm = AlarmController.sharedInstance.alarms[indexPath.row]
            AlarmController.sharedInstance.deleteAlarm(alarm: alarm)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //IIDOO
        if segue.identifier == "toAlarmDetailVC" {
            guard let indexPath = tableView.indexPathForSelectedRow else { return }
            guard let destinationVC = segue.destination as? AlarmDetailTableViewController else { return }
            
            let objectToSend = AlarmController.sharedInstance.alarms[indexPath.row]
            destinationVC.alarm = objectToSend
        }
    }
} // End of Class


// Step 4 of 5
extension AlarmListTableViewController: AlarmTableViewCellDelegate {
    func enabledValueChanged(_ cell: SwitchTableViewCell, selected: Bool) {
        guard let alarm = cell.alarm else { return }
        alarm.enabled = selected
        cell.updateViews()
    }
    
}
