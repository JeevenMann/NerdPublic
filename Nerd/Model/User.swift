//
//  User.swift
//  Study
//
//  Created by Navjeeven Mann on 2020-08-30.
//  Copyright © 2020 Navjeeven Mann. All rights reserved.
//

import Foundation
import Firebase
import FirebaseAuth
class User {
    // Declare user timer value
    static var sharedInstance = User()
    var isNewUser: Bool = true
    var UID: String? {
        return Firebase.Auth.auth().currentUser?.uid
    }
    var username: String {
        return Firebase.Auth.auth().currentUser?.displayName ?? "Guest"
    }
    var profileImage: UIImage?
    var userGrade: String?
    var userPoints: Int?
    var userType: userType = .anonymousUser
    var userQuestions: [Question]?
    var bookmarkedQuestions: [String]?
    var likedContent: [String]?
    var dislikedContent: [String]?

    func loadUser(completion: @escaping () -> Void) {
        let group = DispatchGroup()

        group.enter()
        DatabaseManager.sharedInstance.loadProfileImage(username: self.username, completion: {(profileImage) in

            if let profileImage = profileImage {

                self.profileImage = profileImage
                group.leave()
            }
        })

        group.enter()
        DatabaseManager.sharedInstance.loadUser(username: username, completion: {
            group.leave()
        })

        group.notify(queue: .main, execute: {
            completion()
        })
    }

    func logout() {
        try? Firebase.Auth.auth().signOut()
    }

    func getUserType() -> userType {
        return self.userType
    }

    func getUsername() -> String {
        return self.username
    }

    func saveProfileImage(url: URL?) {
        if let imageURL = url {
            let userChanges = Firebase.Auth.auth().currentUser?.createProfileChangeRequest()
            userChanges?.photoURL = imageURL
            userChanges?.commitChanges(completion: nil)
        }
    }
}
