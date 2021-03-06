//
//  SceneDelegate.swift
//  b
//
//  Created by Navjeeven Mann on 2020-05-19.
//  Copyright © 2020 Navjeeven Mann. All rights reserved.
//

import UIKit
import Foundation
import ESTabBarController_swift
import FBSDKLoginKit
import FirebaseAuth
import AVKit
class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {

        guard let windowScene = (scene as? UIWindowScene) else {
            return
        }
        // Create UI elements
        window = UIWindow(windowScene: windowScene)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let navController = storyboard.instantiateViewController(identifier: "mainNavigation") as? UINavigationController else {
            return
        }

        // User split: Enter onboarding path or main menu path
        // if the user is signed in, enter the main app
        // else present the onboarding process
        if let currentUser = Auth.auth().currentUser {
            // safely initialize all the vc's
            if currentUser.isAnonymous {
                User.sharedInstance.userType = .anonymousUser
            } else {
                User.sharedInstance.userType = .registeredUser
            }
            if let tabBar = storyboard.instantiateViewController(identifier: "mainTB") as? ESTabBarController,
               let forumVC = storyboard.instantiateViewController(identifier: "forumVC") as? ForumViewController,
               let timerVC = storyboard.instantiateViewController(identifier: "timerVC") as? TimerViewController,
               let userVC = storyboard.instantiateViewController(identifier: "userVC") as? UserViewController {

                tabBar.tabBar.backgroundColor = .black

            // assign tab bar item images and titles
                timerVC.tabBarItem = ESTabBarItem(ExampleBouncesContentView(), title: "Focus", image: UIImage(systemName: "clock.fill"), selectedImage: UIImage(systemName: "clock.fill"), tag: 3)
                forumVC.tabBarItem = ESTabBarItem(ExampleBouncesContentView(), title: "Forum", image: UIImage(systemName: "rectangle.3.offgrid.bubble.left.fill"), selectedImage: UIImage(systemName: "rectangle.3.offgrid.bubble.left.fill"), tag: 1)
                userVC.tabBarItem = ESTabBarItem(ExampleBouncesContentView(), title: "User", image: UIImage(systemName: "person.fill"), selectedImage: UIImage(systemName: "person.fill"), tag: 4)
                tabBar.tabBar.isOpaque = false

            // set view controllers and selected index
                tabBar.viewControllers = [forumVC, timerVC, userVC]

                tabBar.selectedViewController = forumVC
                tabBar.selectedIndex = 0

                navController.setViewControllers([tabBar], animated: true)

                User.sharedInstance.loadUser {
                        userVC.loadViewIfNeeded()
                        userVC.loadUserProperties()
                        forumVC.setProfileImage()
                        forumVC.loadData()
                    }
            }
        } else {

            // Tell AVKit to not mute any other audio playing
            try? AVAudioSession.sharedInstance().setCategory(.playback)

            // present splash screen and load AVPlayer
            if let onboardingVC = storyboard.instantiateViewController(identifier: "splashVC") as? SplashViewController {
        
                navController.pushViewController(onboardingVC, animated: true)
            }
        }

        // set the current window's root VC
        window?.rootViewController = navController
    }

    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        guard let url = URLContexts.first?.url else {
            return
        }

        ApplicationDelegate.shared.application(
            UIApplication.shared,
            open: url,
            sourceApplication: nil,
            annotation: [UIApplication.OpenURLOptionsKey.annotation]
        )
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
        if Pomodoro.sharedInstance.backgroundDate != nil {
            Pomodoro.sharedInstance.returnFromBackground()
        }
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
        // Save changes in the application's managed object context when the application transitions to the background.
        if Pomodoro.sharedInstance.isStarted {
            Pomodoro.sharedInstance.backgroundDate = Date()
        }
    }
}
