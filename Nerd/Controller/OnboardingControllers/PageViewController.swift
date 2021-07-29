//
//  PageViewController.swift
//  Studee
//
//  Created by Navjeeven Mann on 2021-01-30.
//  Copyright © 2021 Navjeeven Mann. All rights reserved.
//

import UIKit

class PageViewController: UIViewController {
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var skipButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.loginButton.roundCorners()
        self.signupButton.roundCorners()
        self.loginButton.layer.borderWidth = 1
        self.loginButton.layer.borderColor = UIColor(named: "Accent1")?.cgColor

        self.skipButton.layer.cornerRadius = self.skipButton.frame.height / 2
        // Do any additional setup after loading the view.
    }
    
    @IBAction func loginClick(_ sender: Any) {
        if let loginVC = self.storyboard?.instantiateViewController(identifier: "loginVC") as? LoginViewController {
            self.navigationController?.setViewControllers([loginVC], animated: true)
        }
    }

    @IBAction func signupClick(_ sender: Any) {
        if let signupVC = self.storyboard?.instantiateViewController(identifier: "signupVC") as? SignUpViewController {
            self.navigationController?.setViewControllers([signupVC], animated: true)
        }
    }
    @IBAction func skipClick(_ sender: Any) {
        if let tabBar = self.getTB() {
            self.navigationController?.setViewControllers([tabBar], animated: true)
        }
    }

    deinit {
        print("Deinit: Page VC")
    }
}
