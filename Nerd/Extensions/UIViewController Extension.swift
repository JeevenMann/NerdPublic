//
//  UIViewController Extension.swift
//  Studee
//
//  Created by Navjeeven Mann on 2020-12-29.
//  Copyright © 2020 Navjeeven Mann. All rights reserved.
//

import Foundation
import UIKit
import ESTabBarController_swift
extension UIViewController {

    func hideKeyboardWhenTappedAround() {
        // Create gesture recognizer to dismiss keyboard
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
 
        func getTB() -> ESTabBarController? {
            // Return the main TB after login
            
            // safely initialize all the vc's
            if let tabBar = storyboard?.instantiateViewController(identifier: "mainTB") as? ESTabBarController,
               let forumVC = storyboard?.instantiateViewController(identifier: "forumVC") as? ForumViewController,
               let timerVC = storyboard?.instantiateViewController(identifier: "timerVC") as? TimerViewController,
               let userVC = storyboard?.instantiateViewController(identifier: "userVC") as? UserViewController {

                // assign tab bar item images and titles
                timerVC.tabBarItem = ESTabBarItem(ExampleBouncesContentView(), title: "Focus", image: UIImage(systemName: "clock.fill"), selectedImage: UIImage(systemName: "clock.fill"), tag: 3)
                forumVC.tabBarItem = ESTabBarItem(ExampleBouncesContentView(), title: "Forum", image: UIImage(systemName: "rectangle.3.offgrid.bubble.left.fill"), selectedImage: UIImage(systemName: "rectangle.3.offgrid.bubble.left.fill"), tag: 1)
                userVC.tabBarItem = ESTabBarItem(ExampleBouncesContentView(), title: "User", image: UIImage(systemName: "person.fill"), selectedImage: UIImage(systemName: "person.fill"), tag: 4)

                // set view controllers and selected index
                tabBar.viewControllers = [forumVC, timerVC, userVC]

                User.sharedInstance.loadUser {
                    
                        userVC.loadViewIfNeeded()
                        userVC.loadUserProperties()
                }
                tabBar.selectedViewController = timerVC
                tabBar.selectedIndex = 0
            return tabBar
           }
            return nil
        }

    func checkUserStatus() -> Bool {

        if User.sharedInstance.getUserType() == .anonymousUser {
            self.presentGuestAlert()
            return false
        } else {
            return true
        }
    }

    func presentGuestAlert() {
        let alertView = AlertViewController()
         alertView.modalPresentationStyle = .custom
         alertView.transitioningDelegate = self
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn, animations: {
            self.view.alpha = 0.5
        }, completion: nil)

        self.present(alertView, animated: true, completion: nil)
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(removeTapGesture(_:)))
        self.view.addGestureRecognizer(tapGestureRecognizer)
    }

    func hideGuestAlert() {
        self.presentedViewController?.dismiss(animated: true, completion: nil)

        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn, animations: {
            self.view.alpha = 1
        }, completion: nil)

        self.view.gestureRecognizers?.removeAll()
    }

    @objc func removeTapGesture(_ sender: UITapGestureRecognizer) {
        self.presentedViewController?.dismiss(animated: true, completion: nil)

        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn, animations: {
            self.view.alpha = 1
        }, completion: nil)

        self.view.removeGestureRecognizer(sender)
   }
}
extension UIViewController: UIViewControllerTransitioningDelegate {
    public func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return AlertPresentationController(presentedViewController: presented, presenting: presenting)
    }
}
