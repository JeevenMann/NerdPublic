//
//  DatabaseManager.swift
//  Studee
//
//  Created by Navjeeven Mann on 2021-01-22.
//  Copyright © 2021 Navjeeven Mann. All rights reserved.
//

import Foundation
import Firebase
import FirebaseFirestore
class DatabaseManager {

    static let sharedInstance = DatabaseManager()
    let databaseObj = Firestore.firestore()
    let storageObj = Storage.storage()
    var lastQuestion: QueryDocumentSnapshot?

    func createNewUser(username: String, grade: String, completion: @escaping CompletionHandler) {

        let document = databaseObj.collection("usernames").document(username)

        document.getDocument(completion: {  (document, _) in

            if let document = document, document.exists {
                 completion(false)
            } else {
                let userChanges = Firebase.Auth.auth().currentUser?.createProfileChangeRequest()
                userChanges?.displayName = username
                userChanges?.commitChanges(completion: nil)

                self.databaseObj.collection("usernames").document(username).setData(["UID": User.sharedInstance.UID ?? "", "Points": 0, "Grade": grade, "Questions": []], completion: {(error) in
                    if error != nil {
                        completion(false)
                    } else {
                        completion(true)
                    }
                })
            }
        })
    }

    func loadUser(username: String, completion: @escaping () -> Void) {
        let documents = databaseObj.collection("usernames").document(username)
        var questionArray: [Question] = []
        var questionRef = databaseObj.collection("questions")
        var dispatchGroup = DispatchGroup()
        dispatchGroup.enter()
        documents.getDocument(completion: { (document, _) in

            if let document = document, document.exists {
                guard let data = document.data() else {
                    return
                }

                User.sharedInstance.userGrade = data[userData.grade.rawValue] as? String ?? ""
                User.sharedInstance.userPoints = data[userData.points.rawValue] as? Int ?? 0
                User.sharedInstance.bookmarkedQuestions = data[userData.bookmarkedQuestions.rawValue] as? [String]
                User.sharedInstance.likedContent = data[userData.likedContent.rawValue] as? [String]
                User.sharedInstance.dislikedContent = data[userData.dislikedContent.rawValue] as? [String]
                print(data[userData.likedContent.rawValue] as? String)
                for questionID in data[userData.questions.rawValue] as? [String] ?? [] {
                    dispatchGroup.enter()

                    let questionDocument = questionRef.document(questionID)

                    questionDocument.getDocument(completion: {(snapshot, error) in

                        if error != nil {
                            print(error?.localizedDescription)
                        } else {
                            guard let snapshot = snapshot else {
                                User.sharedInstance.userQuestions = []
                                return
                            }
                            if let question = try? snapshot.data(as: Question.self) {
                                questionArray.append(question)
                                question.userProfileImage = User.sharedInstance.profileImage
                                dispatchGroup.leave()
                            }
                        }
                    })
                }
            }
            dispatchGroup.leave()
        })

        dispatchGroup.notify(queue: .main) {
            User.sharedInstance.userQuestions = questionArray
            completion()
        }
    }

    func uploadQuestion(_ question: Question) {
        var storageRef: StorageReference = storageObj.reference().child("QuestionAttatchments/")
        var attatchmentLocation: [String] = []
        
        for attatchment in question.questionAttatchments {

            let fileRef = storageRef.child("\(UUID().uuidString)")
            fileRef.putFile(from: attatchment.attatchmentURL!, metadata: nil)
            attatchmentLocation.append(fileRef.fullPath)
        }
        question.firebaseAttatchments = attatchmentLocation
        let questionDocument = databaseObj.collection("questions")

        if let documentReference = try? questionDocument.addDocument(from: question) {

        let userDocument = databaseObj.collection("usernames").document(User.sharedInstance.username)
        userDocument.updateData([
            userData.questions.rawValue: FieldValue.arrayUnion(["\(documentReference.documentID)"])
        ])
        }
        User.sharedInstance.userQuestions?.append(question)
    }

    func uploadAnswer(_ answer: Answer) {
        guard let questionAnswered = answer.questionAnswered else {
            return
        }
        let answerRef = databaseObj.collection("questions").document(questionAnswered.questionID ?? "").collection("Answers")

        do {
            try answerRef.addDocument(from: answer)
        } catch {
            print(error)
        }

        let questionRef = databaseObj.collection("questions").document(answer.questionAnswered?.questionID ?? "")
        questionRef.updateData(["answerCount": questionAnswered.answerCount + 1])
    }

    func getQuestions( completion: @escaping ([Question]) -> Void) {
        var questionArray: [Question] = []
        let dispatchGroup = DispatchGroup()
      
        var query = lastQuestion != nil ? self.databaseObj.collection("questions").order(by: "questionTitle", descending: false).limit(to: 10).start(afterDocument: lastQuestion!) : self.databaseObj.collection("questions").order(by: "questionTitle", descending: false).limit(to: 10)
        DispatchQueue.global().async {

        dispatchGroup.enter()

            query.getDocuments(completion: { (snapshot, error) in

                if error != nil {
                    print(error?.localizedDescription)
                } else {
                    guard snapshot?.documents.last != nil else {
                        return
                    }
                    self.lastQuestion = snapshot?.documents.last
                    for document in snapshot!.documents {
                        if let question = try? document.data(as: Question.self) {
                            print(question.questionID)
                            question.questionID = document.documentID
                            questionArray.append(question)
                            dispatchGroup.enter()
                            self.loadProfileImage(username: question.username, completion: {(profileImage) in

                                if let image = profileImage {
                                    question.userProfileImage = image
                                    dispatchGroup.leave()
                                }
                            })
                        }
                    }
                    dispatchGroup.leave()
                }
            })

        dispatchGroup.notify(queue: .main) {
            completion(questionArray)
        }
        }
    }

    func getAnswers(_ question: Question, completion: @escaping ([Answer]) -> Void) {
        let answerCollection = databaseObj.collection("questions").document(question.questionID ?? "").collection("Answers")
        var answerArray: [Answer] = []
        let dispatchGroup = DispatchGroup()

        dispatchGroup.enter()
        answerCollection.getDocuments(completion: { (snapshot, error) in

            if error != nil {
                print(error)
            } else {

                guard let snapshotDoucments = snapshot?.documents else {
                    return
                }

                for document in snapshotDoucments {
                    dispatchGroup.enter()
                    if var answer = try? document.data(as: Answer.self) {
                        answer.questionAnswered = question
                        
                        dispatchGroup.enter()
                        self.loadProfileImage(username: answer.username, completion: {(image) in
                            if let profileImage = image {
                                answer.profileImage = profileImage
                                answer.answerID = document.documentID
                                if answer.markedCorrect {
                                    answerArray.insert(answer, at: 0)
                                } else {
                                    answerArray.append(answer)
                                }
                                dispatchGroup.leave()
                            }
                        })

                        dispatchGroup.leave()
                    } else {
                        print("Unable to decode")
                    }
                    }

                dispatchGroup.leave()
            }
        })

        dispatchGroup.notify(queue: .main) {
            completion(answerArray)
        }
    }

    func updateQuestion(toUpdate: Question) {
        let databaseRef = databaseObj.collection("questions").document(toUpdate.questionID ?? "")
        DispatchQueue.global().async {
            databaseRef.updateData(["questionPoints": toUpdate.questionPoints])
        }
    }
    
    func bookmarkQuestion(toBookmark: String, _ remove: Bool = false) {
        let userRef = databaseObj.collection("usernames").document(User.sharedInstance.getUsername())
    
        DispatchQueue.global().async {
            
            if remove {
                userRef.updateData(["bookmarkedQuestions": FieldValue.arrayRemove([toBookmark])])
            } else {
            userRef.updateData(["bookmarkedQuestions": FieldValue.arrayUnion([toBookmark])])
            }
            }
    }
    
    func likeContent(contentID: String?, remove: Bool = false) {
        guard let contentID = contentID else { return }
        let userRef = databaseObj.collection("usernames").document(User.sharedInstance.getUsername())
    
        if remove {
            userRef.updateData([userData.likedContent.rawValue: FieldValue.arrayRemove([contentID])])
        } else {
            userRef.updateData([userData.likedContent.rawValue: FieldValue.arrayUnion([contentID])])
        }
    }
    
    func dislikeContent(contentID: String?, remove: Bool = false) {
        guard let contentID = contentID else { return }
        let userRef = databaseObj.collection("usernames").document(User.sharedInstance.getUsername())
    
        DispatchQueue.global().async {
            if remove {
                userRef.updateData([userData.dislikedContent.rawValue: FieldValue.arrayRemove([contentID])])
            } else {
                userRef.updateData([userData.dislikedContent.rawValue: FieldValue.arrayUnion([contentID])])
            }
            }
    }

    func updateAnswer(oldAnswer: Answer, newAnswer: Answer? = nil) {
        guard let questionRef = oldAnswer.questionAnswered?.questionID else { return }

        let databaseRef = databaseObj.collection("questions").document(questionRef)
      
        DispatchQueue.global().async {

        if let newAnswer = newAnswer {
           
            databaseRef.collection("Answers").document(oldAnswer.answerID ?? "").updateData(["markedCorrect": oldAnswer.markedCorrect])
            databaseRef.collection("Answers").document(newAnswer.answerID ?? "").updateData(["markedCorrect": newAnswer.markedCorrect])
        } else {
            databaseRef.collection("Answers").document(oldAnswer.answerID ?? "").updateData(["markedCorrect": oldAnswer.markedCorrect])
            databaseRef.updateData(["questionAnswered": oldAnswer.markedCorrect])
        }
        }
    }

    func uploadProfileImage(imageURL: String, imageType: imageType, completion: @escaping CompletionHandler) {
        var storageRef: StorageReference = storageObj.reference()

        if imageType == .profilePicture {
            storageRef = storageRef.child("ProfilePictures/\(User.sharedInstance.username ?? "user")")
        }

        guard let imageFile = URL(string: imageURL) else {
            return
        }

        storageRef.putFile(from: imageFile, metadata: nil)

        storageRef.downloadURL(completion: { (urlLink, _) in

            if let url = urlLink {

                completion(url)
            }
        })
    }

    func loadProfileImage(username: String, completion: @escaping (UIImage?) -> Void) {

        var storageRef = storageObj.reference().child("ProfilePictures/\(username)")

        storageRef.getData(maxSize: 1 * 1024 * 1024, completion: { (data, error) in

            if error != nil {
                print(error?.localizedDescription)
                completion(UIImage(systemName: "person.fill"))
            } else {

                if let data = data {
                    let image = UIImage(data: data)
                    completion(image)
                }
            }
        })
        }

    func loadAttatchments(question: Question, completion: @escaping ([Attatchment]) -> Void) {
        var attatchmentArray: [Attatchment] = []

        var dispatchGroup = DispatchGroup()

        for location in question.firebaseAttatchments {
            print(location)
            var storageRef = storageObj.reference().child(location)
            dispatchGroup.enter()
            storageRef.getMetadata(completion: { (meta, error) in
                guard let metadata = meta, error == nil else {
                    dispatchGroup.leave()
                    return
                }

                let tmporaryDirectoryURL = FileManager.default.temporaryDirectory

                let fileType = metadata.contentType!.split(separator: "/").last!
                let localURL = tmporaryDirectoryURL.appendingPathComponent("\(metadata.name!).\(String(fileType))")
                    storageRef.write(toFile: localURL, completion: { (url, _) in

                        if let fileURL = url {
                        let attatchment = Attatchment(url: fileURL)
                        attatchmentArray.append(attatchment)
                            dispatchGroup.leave()
                        }
                    })
            })
        }

        dispatchGroup.notify(queue: .main) {
            completion(attatchmentArray)
        }
    }
}
