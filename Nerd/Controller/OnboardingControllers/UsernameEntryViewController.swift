//
//  UsernameEntryViewController.swift
//  Studee
//
//  Created by Navjeeven Mann on 2021-01-22.
//  Copyright © 2021 Navjeeven Mann. All rights reserved.
//

import UIKit

class UsernameEntryViewController: UIViewController {

    @IBOutlet weak private var usernameField: UITextField!
    @IBOutlet weak private var nextButton: UIButton!
    var gradeSelected: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        nextButton.roundCorners()
        self.hideKeyboardWhenTappedAround()

        // Do any additional setup after loading the view.
    }
    @IBAction private func nextButtonClicked(_ sender: Any) {
        if checkUsername(), let username = usernameField.text {
            DatabaseManager.sharedInstance.createNewUser(username: username, grade: gradeSelected ?? "", completion: {(result) in

                if let result = result as? Bool, result {
                    guard let tabBar = self.getTB() else {
                        return
                    }
   
                    self.navigationController?.setViewControllers([tabBar], animated: true)
                } else {
                    let popup = PopupView(frame: CGRect(x: 0, y: 0, width: 300, height: 75), text: "This username is already in use.", image: UIImage(systemName: "at.circle.fill")!)
                    self.view.addSubview(popup)
                    return
                }
            })
        } else {

            let popup = PopupView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width - 15, height: 75), text: "Please enter only lowercase letters and a length between 5-15.", image: UIImage(systemName: "at.circle.fill")!)
            self.view.addSubview(popup)
            return
        }
    }

    func checkUsername() -> Bool {
        var isValid: Bool = true
        guard let usernameText = usernameField.text, usernameField.hasText, usernameText.count >= 5 && usernameText.count <= 15 else {
            return false
        }

        for char in usernameText {
            if !char.isLowercase {
                isValid = false
            }
        }
        return isValid
    }

    deinit {
        print("Deinit: Username VC")
    }
}
extension UsernameEntryViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == usernameField {
            textField.resignFirstResponder()
        }
        return true
    }
}
