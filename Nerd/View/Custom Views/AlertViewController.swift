//
//  AlertViewController.swift
//  Nerd
//
//  Created by Navjeeven Mann on 2021-06-15.
//  Copyright © 2021 Navjeeven Mann. All rights reserved.
//

import UIKit
import ESTabBarController_swift

class AlertViewController: UIViewController {

    @IBOutlet weak var slideView: UIView!

    var originPoint: CGPoint?
    let appStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
    override func viewDidLoad() {
        super.viewDidLoad()

        slideView.roundCorners()

         let registerView = RegisterRequestView(nibName: "RegisterRequestView", bundle: nil)

        self.view.addSubview(registerView.view)
        registerView.view.translatesAutoresizingMaskIntoConstraints = false
        registerView.view.topAnchor.constraint(equalTo: slideView.bottomAnchor).isActive = true
        registerView.view.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        registerView.view.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        registerView.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        self.addChild(registerView)
        
        let slideGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(slideRecognizer(_:)))
        self.view.addGestureRecognizer(slideGestureRecognizer)

        // Do any additional setup after loading the view.
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.originPoint = view.frame.origin
    }

    @objc func slideRecognizer(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: self.view)
        guard translation.y >= 0 else { return }

        self.view.frame.origin = CGPoint(x: 0, y: translation.y)

        if sender.state == .ended {
            if translation.y >= 75 {
                if let tabBarVC = (self.presentingViewController as? UINavigationController)?.viewControllers.first as? ESTabBarController {
                  
                    if let presentingVC = tabBarVC.navigationController?.topViewController {
                        self.view.removeGestureRecognizer(sender)
                        presentingVC.hideGuestAlert()
                    }
                }
            } else {
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.1, options: .curveEaseIn, animations: {
                    self.view.frame.origin = self.originPoint ?? CGPoint(x: 0, y: 0)
                }, completion: nil)
            }
        }
    }
}
