//
//  TimerSettingTableViewController.swift
//  Studee
//
//  Created by Navjeeven Mann on 2021-05-18.
//  Copyright © 2021 Navjeeven Mann. All rights reserved.
//

import UIKit

class TimerSettingTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.backgroundColor = UIColor(named: "BackgroundColor")
        self.tableView.register(UINib(nibName: "TimerSettingTableViewCell", bundle: nil), forCellReuseIdentifier: "settingCell")
        self.tableView.register(UINib(nibName: "TimerColorCell", bundle: nil), forCellReuseIdentifier: "colorCell")
        self.tableView.backgroundColor = UIColor(named: "Accent1")
        self.hideKeyboardWhenTappedAround()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return (section == 0 || section == 2) ? 3 : 2
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let height = (tableView.frame.height - (tableView.sectionHeaderHeight * 3)) / 8
        return  70
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "settingCell") as? TimerSettingTableViewCell {

                switch indexPath.row {
                case 0:
                    cell.setValue(label: "Focus Length", time: Pomodoro.sharedInstance.normalTime, max: 60)
                    cell.tag = 0
                case 1:
                    cell.setValue(label: "Short Break Length", time: Pomodoro.sharedInstance.shortBreakTime, max: 60)
                    cell.tag = 1
                case 2:
                    cell.setValue(label: "Long Break Length", time: Pomodoro.sharedInstance.longBreakTime, max: 60)
                    cell.tag = 2
                default:
                    return cell
                }
                return cell
            }

        case 1:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "settingCell") as? TimerSettingTableViewCell {

            switch indexPath.row {
            case 0:
                cell.setValue(label: "Sprint Goal", time: Pomodoro.sharedInstance.sprintTarget, max: 100)
                cell.tag = 3
            case 1:
                cell.setValue(label: "Session Goal", time: Pomodoro.sharedInstance.sessionTarget, max: 100)
                cell.tag = 4
            default:
                return cell
            }
                return cell
            }

        case 2:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "colorCell") as? TimerColorCell {

                switch indexPath.row {
                case 0:
                    cell.setValues(title: "Focus Time", color: Pomodoro.sharedInstance.normalColor)
                    cell.tag = 5
                    cell.delegate = self
                case 1:
                    cell.setValues(title: "Short Break", color: Pomodoro.sharedInstance.shortBreakColor)
                    cell.tag = 6
                    cell.delegate = self
                case 2:
                    cell.setValues(title: "Long Break", color: Pomodoro.sharedInstance.longBreakColor)
                    cell.tag = 7
                    cell.delegate = self
                default:
                    return cell
                }
                return cell
            }
        default:
            return UITableViewCell()
        }
        return UITableViewCell()
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Timer Length"
        case 1:
            return "Session Length"
        case 2:
            return "Background Color"
        default:
            return "Def"
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        for cell in tableView.visibleCells {
            switch cell.tag {
            case 0:
                let timeCell = cell as? TimerSettingTableViewCell
                if let fieldValue = timeCell?.getField(), let timeValue = Int(fieldValue) {
                    Pomodoro.sharedInstance.normalTime = timeValue
                    print(timeValue)
                }
            case 1:
                let timeCell = cell as? TimerSettingTableViewCell
                if let fieldValue = timeCell?.getField(), let timeValue = Int(fieldValue) {
                    Pomodoro.sharedInstance.shortBreakTime = timeValue
                    print(timeValue)
                }
            case 2:
                let timeCell = cell as? TimerSettingTableViewCell
                if let fieldValue = timeCell?.getField(), let timeValue = Int(fieldValue) {
                    Pomodoro.sharedInstance.longBreakTime = timeValue
                    print(timeValue)
                }
            case 3:
                let timeCell = cell as? TimerSettingTableViewCell
                if let fieldValue = timeCell?.getField(), let lengthValue = Int(fieldValue) {
                    Pomodoro.sharedInstance.sprintTarget = lengthValue
                    print(lengthValue)
                }
            case 4:
                let timeCell = cell as? TimerSettingTableViewCell
                if let fieldValue = timeCell?.getField(), let lengthValue = Int(fieldValue) {
                    Pomodoro.sharedInstance.sessionTarget = lengthValue
                    print(lengthValue)
                }
            case 5:
                let colorCell = cell as? TimerColorCell
                if let colorValue = colorCell?.getColor() {
                    Pomodoro.sharedInstance.normalColor = colorValue
                }

            case 6:
                let colorCell = cell as? TimerColorCell
                if let colorValue = colorCell?.getColor() {
                    Pomodoro.sharedInstance.shortBreakColor = colorValue
                }

            case 7:
                let colorCell = cell as? TimerColorCell
                if let colorValue = colorCell?.getColor() {
                    Pomodoro.sharedInstance.longBreakColor = colorValue
                }
            default:
                return
            }
            Pomodoro.sharedInstance.restartTimer()
        }
    }
}
extension TimerSettingTableViewController: SelectColor {
    func openPicker(view: UIColorPickerViewController) {
        self.present(view, animated: true, completion: nil)
    }
}
