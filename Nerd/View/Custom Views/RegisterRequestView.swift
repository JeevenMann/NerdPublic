//
//  RegisterRequestView.swift
//  Nerd
//
//  Created by Navjeeven Mann on 2021-06-24.
//  Copyright © 2021 Navjeeven Mann. All rights reserved.
//

import UIKit

class RegisterRequestView: UIViewController {

    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    let appStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)

    override func viewDidLoad() {
        super.viewDidLoad()
        loginButton.roundCorners()
        signupButton.roundCorners()
    }

    @IBAction func loginAction(_ sender: Any) {

        if let loginVC = appStoryboard.instantiateViewController(withIdentifier: "loginVC") as? LoginViewController {
            loginVC.modalPresentationStyle = .popover
            self.present(loginVC, animated: true)
        }
    }

    @IBAction func signupAction(_ sender: Any) {

        if let signUpVC = appStoryboard.instantiateViewController(withIdentifier: "signupVC") as? SignUpViewController {
            signUpVC.modalPresentationStyle = .popover
            self.present(signUpVC, animated: true)
        }
    }
}
