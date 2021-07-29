//
//  GradeEntryViewController.swift
//  Studee
//
//  Created by Navjeeven Mann on 2021-02-01.
//  Copyright © 2021 Navjeeven Mann. All rights reserved.
//

import UIKit
import PickerView
class GradeEntryViewController: UIViewController {

    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var gradePicker: PickerView!
    let grades = ["Grade 1", "Grade 2", "Grade 3", "Grade 4", "Grade 5", "Grade 6", "Grade 7", "Grade 8", "Grade 9", "Grade 10", "Grade 11", "Grade 12", "1st Year", "2nd Year", "3rd Year", "4th Year", "Post-Grad"]

    @IBAction func nextButtonClick(_ sender: Any) {

        guard let usernameVC = self.storyboard?.instantiateViewController(identifier: "usernameVC") as? UsernameEntryViewController else {
            return
        }
        usernameVC.gradeSelected = String(gradePicker.currentSelectedIndex)
        self.navigationController?.setViewControllers([usernameVC], animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        nextButton.roundCorners()
        gradePicker.delegate = self
        gradePicker.dataSource = self

        // Do any additional setup after loading the view.
    }

    deinit {
        print("Deinit: Grade VC")
    }
}

extension GradeEntryViewController: PickerViewDelegate, PickerViewDataSource {
    func pickerViewHeightForRows(_ pickerView: PickerView) -> CGFloat {
        return 50
    }

    func pickerViewNumberOfRows(_ pickerView: PickerView) -> Int {
        return grades.count
    }

    func pickerView(_ pickerView: PickerView, titleForRow row: Int) -> String {
        return grades[row]
    }

    func pickerView(_ pickerView: PickerView, styleForLabel label: UILabel, highlighted: Bool) {
        if highlighted {
            label.font = UIFont.systemFont(ofSize: 25.0)
            label.textColor = UIColor(named: "Accent1")
        } else {
            label.font = UIFont.systemFont(ofSize: 15.0)
            label.textColor = .lightGray
        }
    }
}
