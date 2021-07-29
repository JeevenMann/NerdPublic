//
//  Constants.swift
//  Studee
//
//  Created by Navjeeven Mann on 2021-01-25.
//  Copyright © 2021 Navjeeven Mann. All rights reserved.
//

import Foundation
import UIKit
enum imageType {
    case profilePicture
}
enum userData: String {
    case grade = "Grade"
    case points = "Points"
    case questions = "userQuestions"
    case bookmarkedQuestions = "bookmarkedQuestions"
    case likedContent
    case dislikedContent
}

enum userType {
    case registeredUser, anonymousUser
}

enum questionCategory: String, Codable {
    case biology, business, chemistry, physics, law, history, math, health, geography, computerscience
    
    func toString() -> String {
        
        switch self {
        case .biology:
            return "Biology"
        case .business:
            return "Business"
        case .chemistry:
            return "Chemistry"
        case .physics:
            return "Physics"
        case .law:
            return "Law"
        case .history:
            return "History"
        case .math:
            return "Math"
        case .health:
            return "Health"
        case .geography:
            return "Geography"
        case .computerscience:
            return "Computer Science"
            
        default:
            return "Unknown"
        }
    }
}

typealias CompletionHandler = (Any) -> Void
let interestialAdKey = ADD KEY
let bannerKey = ADD KEY
let inScrollAdKey = ADD KEY
