//
//  Question.swift
//  Studee
//
//  Created by Navjeeven Mann on 2021-02-16.
//  Copyright © 2021 Navjeeven Mann. All rights reserved.
//

import Foundation
import FirebaseFirestoreSwift
class Question: Codable {
    
    var questionTitle: String
    var questionBody: String
    var questionAttatchments = [Attatchment]()
    var firebaseAttatchments = [String]()
    var username: String
    var userProfileImage: UIImage?
    var questionDate: String
    var questionID: String?
    var questionAnswered: Bool = false
    var questionPoints: Int = 0
    var answerCount: Int = 0
    var category: questionCategory
    var isBookmarked: Bool = false
    init(_ title: String, _ body: String, _ attatchments: [Attatchment], _ username: String, _ questionDate: String, questionCategory: questionCategory) {
        self.questionTitle = title
        self.questionBody = body
        self.questionAttatchments = attatchments
        self.username = username
        self.questionDate = questionDate
        self.category = questionCategory
    }

    init(_ title: String, _ body: String, _ firebaseAttatchments: [String], _ username: String, questionDate: String, questionCategory: questionCategory) {
        self.questionTitle = title
        self.questionBody = body
        self.firebaseAttatchments = firebaseAttatchments
        self.username = username
        self.questionDate = questionDate
        self.category = questionCategory
    }

    enum CodingKeys: String, CodingKey {
        case questionTitle, questionBody, firebaseAttatchments = "questionAttatchments", username, questionDate, questionAnswered, questionPoints, answerCount, category
    }

    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.questionTitle = try values.decodeIfPresent(String.self, forKey: .questionTitle) ?? "Unable to Fetch Question"
        self.questionBody = try values.decodeIfPresent(String.self, forKey: .questionBody) ?? "Unable to Fetch Question Body"
        self.firebaseAttatchments = try values.decode([String].self, forKey: .firebaseAttatchments)
        self.username = try values.decode(String.self, forKey: .username)
        self.questionDate = try values.decode(String.self, forKey: .questionDate)
        self.questionAnswered = try values.decode(Bool.self, forKey: .questionAnswered)
        self.questionPoints = try values.decode(Int.self, forKey: .questionPoints)
        self.answerCount = try values.decode(Int.self, forKey: .answerCount)
        self.category = try values.decode(questionCategory.self, forKey: .category)
    }
}
