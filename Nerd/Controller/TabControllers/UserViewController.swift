//
//  UserViewController.swift
//  Study
//
//  Created by Navjeeven Mann on 2020-12-25.
//  Copyright © 2020 Navjeeven Mann. All rights reserved.
//

import UIKit
import Firebase
class UserViewController: UIViewController, UINavigationControllerDelegate {

    @IBOutlet weak var settingView: UIView!
    @IBOutlet weak var embedView: UIView!
    @IBOutlet weak private var userProfileImage: UIButton!
    @IBOutlet weak private var usernameLabel: UILabel!
    @IBOutlet weak private var userView: UIView!
    @IBOutlet weak var pointsLabel: UILabel!
    @IBOutlet weak var gradeLabel: UILabel!
    @IBOutlet weak var userProfileImageView: UIView!
    var userTableView: UITableView?

    override func viewDidLoad() {
        super.viewDidLoad()

        if let tableView = embedView.subviews.first as? UITableView {
            self.userTableView = tableView
            self.userTableView?.delegate = self
        }

        self.setUIProperties()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        userProfileImage.imageView?.makeRounded()
    }

    func setUIProperties() {
        userProfileImage.activateShimmer()
        userView.roundBottomCorners()

        if let profileImage = userProfileImage.imageView {
            profileImage.translatesAutoresizingMaskIntoConstraints = false
            profileImage.contentMode = .scaleAspectFill
            profileImage.widthAnchor.constraint(equalTo: userProfileImage.widthAnchor).isActive = true
            profileImage.heightAnchor.constraint(equalTo: userProfileImage.heightAnchor).isActive = true
        }
        userTableView?.rowHeight = 65

        let imageAction = UIAction(title: "Select Image from Library", image: UIImage(systemName: "camera.fill"), state: .off, handler: {(_) in
            if self.checkUserStatus() {
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.imageExportPreset = .compatible
                imagePicker.sourceType = .photoLibrary
                self.present(imagePicker, animated: true, completion: nil)
            }
        })

        let cancelAction = UIAction(title: "Cancel", image: UIImage(systemName: "xmark"), attributes: .destructive, state: .off, handler: {(_) in
        })
        let profileMenu = UIMenu(title: "Select Your Profile Picture", image: nil, identifier: .none, children: [imageAction, cancelAction])

        userProfileImage.menu = profileMenu
        userProfileImage.showsMenuAsPrimaryAction = true
    }

    func loadUserProperties() {
            self.userProfileImage.deactivateSimmer()
            self.usernameLabel.text = ("@" + (User.sharedInstance.username))
            self.gradeLabel.text?.append(User.sharedInstance.userGrade ?? "0")
            self.pointsLabel.text?.append(String(User.sharedInstance.userPoints ?? 0))
            self.userProfileImage.setImage(User.sharedInstance.profileImage, for: .normal)
    }

    deinit {
        print("Deinit UserVC")
    }
}
extension UserViewController: UIImagePickerControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {

        if let image = info[.originalImage] as? UIImage, let imageURL = info[.imageURL] as? URL {
            self.userProfileImage.setImage(image, for: .normal)
            DatabaseManager.sharedInstance.uploadProfileImage(imageURL: imageURL.absoluteString, imageType: .profilePicture, completion: {(url) in

                if let photoURL = url as? URL {
                    User.sharedInstance.saveProfileImage(url: photoURL)
                }
            })
        }
        picker.dismiss(animated: true, completion: nil)
    }
}

extension UserViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return 5
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        switch indexPath.row {
        case 0:
            if checkUserStatus() {
            if let userQuestionVC = storyboard?.instantiateViewController(identifier: "userQuestionVC") as? UserQuestionViewController {
                userQuestionVC.modalPresentationStyle = .fullScreen
                self.navigationController?.pushViewController(userQuestionVC, animated: true)
            }
            }
        case 1:
            if let timerVC = storyboard?.instantiateViewController(identifier: "timerSettingVC") as? TimerSettingTableViewController {
                self.present(timerVC, animated: true, completion: nil)
            }
        case 2:
            if checkUserStatus() {
                print("Manage Account")
            }
        case 3:
            print("Privacy Policy")
        case 4:
            print("T&C")
        case 5:
            let alertController = UIAlertController(title: "", message: "Are you sure you would like to logout?", preferredStyle: .actionSheet)

            let confirmAction = UIAlertAction(title: "Logout", style: .destructive, handler: {(_) in

                if let splashVC = self.storyboard?.instantiateViewController(identifier: "splashVC") as? SplashViewController {
                    User.sharedInstance.logout()
                    splashVC.modalTransitionStyle = .crossDissolve
                self.navigationController?.setViewControllers([splashVC], animated: true)
                }
            })

            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)

            alertController.addAction(cancelAction)
            alertController.addAction(confirmAction)

            self.present(alertController, animated: true, completion: nil)
        default:
            print("Defuallt")
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {

        cell.accessoryView = UIImageView(image: UIImage(systemName: "chevron.forward")!)
    }
}
