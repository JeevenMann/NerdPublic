//
//  Answer.swift
//  Nerd
//
//  Created by Navjeeven Mann on 2021-05-28.
//  Copyright © 2021 Navjeeven Mann. All rights reserved.
//

import Foundation
import UIKit
class Answer: Codable {
    var answerBody: String
    var markedCorrect: Bool = false
    var answerDate: String
    var questionAnswered: Question?
    var username: String
    var profileImage: UIImage?
    var answerID: String?
    var answerPoints: Int = 0

    enum CodingKeys: String, CodingKey {
        case answerBody, markedCorrect, answerDate, username, answerPoints
    }

    init(answerBody: String, answerDate: String, questionAnswered: Question, username: String) {
        self.answerBody = answerBody
        self.answerDate = answerDate
        self.questionAnswered = questionAnswered
        self.username = username
    }

    func encode(to encoder: Encoder) throws {
        var encodedValues = encoder.container(keyedBy: CodingKeys.self)
        try encodedValues.encode(self.username, forKey: .username)
        try encodedValues.encode(self.answerBody, forKey: .answerBody)
        try encodedValues.encode(self.markedCorrect, forKey: .markedCorrect)
        try encodedValues.encode(self.answerDate, forKey: .answerDate)
        try encodedValues.encode(self.answerPoints, forKey: .answerPoints)
    }

    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.username = try values.decode(String.self, forKey: .username)
        self.answerBody = try values.decode(String.self, forKey: .answerBody)
        self.answerDate = try values.decode(String.self, forKey: .answerDate)
        self.markedCorrect = try values.decode(Bool.self, forKey: .markedCorrect)
        self.answerPoints = try values.decode(Int.self, forKey: .answerPoints)
    }
}
