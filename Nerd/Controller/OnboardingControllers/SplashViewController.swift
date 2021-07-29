//
//  SplashViewController.swift
//  Studee
//
//  Created by Navjeeven Mann on 2021-01-01.
//  Copyright © 2021 Navjeeven Mann. All rights reserved.
//

import UIKit
import AVKit

class SplashViewController: UIViewController {

    // MARK: IB Outlet/Actions
    @IBOutlet weak var getStartedButton: UIButton!
    @IBOutlet weak var signInButton: UIButton!

    @IBAction private func startClick(_ sender: Any) {

        if let pageView = self.storyboard?.instantiateViewController(identifier: "PageVC") as? PageViewController {
        self.navigationController?.setViewControllers([pageView], animated: true)
        }
    }

    @IBAction func signInClick(_ sender: Any) {
        if let signInVC = self.storyboard?.instantiateViewController(identifier: "loginVC") as? LoginViewController {
            self.navigationController?.pushViewController(signInVC, animated: true)
        }
    }
    // MARK: View Function/Variables

    override func viewDidLoad() {
        super.viewDidLoad()
        getStartedButton.alpha = 0
        signInButton.alpha = 0
        getStartedButton.roundCorners()
        signInButton.roundCorners()

        if self.traitCollection.userInterfaceStyle == .light {
            self.view.backgroundColor = UIColor(named: "Accent1")
            getStartedButton.backgroundColor = .white
            getStartedButton.titleLabel?.textColor = UIColor(named: "Accent1")
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        UIView.animate(withDuration: 0.75, delay: 0, options: .curveEaseInOut, animations: {
            self.getStartedButton.alpha = 1
            self.signInButton.alpha = 1
        }, completion: nil)
    }
}
