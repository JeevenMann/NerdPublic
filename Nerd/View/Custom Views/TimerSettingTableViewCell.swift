//
//  TimerSettingTableViewCell.swift
//  Studee
//
//  Created by Navjeeven Mann on 2021-05-18.
//  Copyright © 2021 Navjeeven Mann. All rights reserved.
//

import UIKit

class TimerSettingTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var incrementField: UITextField!
    @IBOutlet weak var stepperButton: UIStepper!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        incrementField.delegate = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func setValue(label: String, time: Int, max: Int) {
        self.titleLabel.text = label
        self.incrementField.text = String(time)
        self.stepperButton.value = Double(time)
    }

    func getField() -> String? {
        return self.incrementField.text
    }

    @IBAction func valueChanged(_ sender: Any) {
        self.incrementField.text = String(format: "%d", Int(self.stepperButton.value))
    }
}
extension TimerSettingTableViewCell: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let fieldValue = textField.text, let timeValue = Int(fieldValue) {
            if timeValue > 59 {
                textField.text = "59"
            }
        }
    }
}
