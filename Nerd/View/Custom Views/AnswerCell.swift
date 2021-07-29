//
//  AnswerCell.swift
//  Nerd
//
//  Created by Navjeeven Mann on 2021-05-28.
//  Copyright © 2021 Navjeeven Mann. All rights reserved.
//

import UIKit

protocol MarkProtocol: UIViewController {
    func cellMarked(markedCell: AnswerCell, markedCorrect: Bool)
}

class AnswerCell: UITableViewCell {

    @IBOutlet weak var answerBody: UITextView!
    @IBOutlet weak var dateLabel: UITextField!
    @IBOutlet weak var dataStackView: UIStackView!
    @IBOutlet weak var usernameLabel: UITextField!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var dislikeButton: UIButton!
    @IBOutlet weak var likeCount: UILabel!
    
    weak var markDelegate: MarkProtocol?

    var correctButton: UIButton?
    var answer: Answer?
    override func awakeFromNib() {
        super.awakeFromNib()

        answerBody.activateShimmer()
        dateLabel.activateShimmer()
        usernameLabel.activateShimmer()
        profileImage.activateShimmer()
        profileImage.makeRounded()
    }

    @objc func markAnswer() {
        guard let correctButton = self.correctButton else {
            return
        }
        
        switch correctButton.backgroundColor {
        
        case UIColor.gray:
            correctButton.backgroundColor = UIColor(named: "LightAccent")
            correctButton.setTitleColor(UIColor(named: "Accent1"), for: .normal)
            markDelegate?.cellMarked(markedCell: self, markedCorrect: true)
            
        case UIColor(named: "LightAccent"):
            correctButton.backgroundColor = .gray
            correctButton.setTitleColor(.darkGray, for: .normal)
            markDelegate?.cellMarked(markedCell: self, markedCorrect: false)

        default:
            break
        }
    }
    
    func markIncorrect() {
        correctButton?.backgroundColor = .gray
        correctButton?.setTitleColor(.darkGray, for: .normal)
    }
    
    @IBAction func likeAnswer(_ sender: Any) {

        if let answerPresented = answer {
            var pointValue = answerPresented.answerPoints
        switch likeButton.isSelected {
        case true:
            likeButton.isSelected = false
            likeButton.setImage( UIImage(named: "likeButton"), for: .normal)
                pointValue -= 1
            DatabaseManager.sharedInstance.likeContent(contentID: answerPresented.answerID, remove: true)

        case false:
            likeButton.isSelected = true
            likeButton.setImage( UIImage(named: "likeButtonFill"), for: .normal)
            DatabaseManager.sharedInstance.likeContent(contentID: answerPresented.answerID)

            if dislikeButton.isSelected {
                pointValue += 2
                dislikeButton.isSelected = false
                dislikeButton.setImage( UIImage(named: "dislikeButton"), for: .normal)
                DatabaseManager.sharedInstance.dislikeContent(contentID: answerPresented.answerID, remove: true)
            } else {
                pointValue += 1
            }
            }

        likeCount.text = "\(pointValue)"
        answerPresented.answerPoints = pointValue
        }
    }
    @IBAction func dislikeAnswer(_ sender: Any) {
 
        if let answerPresented = answer {
            var pointValue = answerPresented.answerPoints
            switch dislikeButton.isSelected {
            case true:
                dislikeButton.isSelected = false
                dislikeButton.setImage( UIImage(named: "dislikeButton"), for: .normal)
                DatabaseManager.sharedInstance.dislikeContent(contentID: answerPresented.answerID, remove: true)

                pointValue += 1

            case false:
                dislikeButton.isSelected = true
                dislikeButton.setImage( UIImage(named: "dislikeButtonFill"), for: .normal)
                DatabaseManager.sharedInstance.dislikeContent(contentID: answerPresented.answerID)

                if likeButton.isSelected {
                    likeButton.isSelected = false
                    likeButton.setImage( UIImage(named: "likeButton"), for: .normal)
                    DatabaseManager.sharedInstance.likeContent(contentID: answerPresented.answerID, remove: true)

                    pointValue -= 2
                } else {
                    pointValue -= 1
                }
            }

            likeCount.text = "\(pointValue)"
            answerPresented.answerPoints = pointValue
        }
    }

    func setData(_ answer: Answer) {
        self.answer = answer
        
        if answer.questionAnswered?.username == User.sharedInstance.getUsername() {
            let answeredButton = UIButton()
              answeredButton.roundCorners()
              answeredButton.backgroundColor = UIColor(named: "LightAccent")
              answeredButton.setTitle("Correct Answer", for: .normal)
              answeredButton.titleLabel?.font = UIFont(name: "AirbnbCerealApp-Medium", size: 13)
            answeredButton.titleLabel?.adjustsFontSizeToFitWidth = true
            answeredButton.setTitleColor(UIColor(named: "Accent1"), for: .normal)
              answeredButton.titleEdgeInsets = UIEdgeInsets(top: 3, left: 8, bottom: 3, right: 8)
              self.addSubview(answeredButton)
              answeredButton.translatesAutoresizingMaskIntoConstraints = false
              answeredButton.widthAnchor.constraint(equalToConstant: 90).isActive = true
              answeredButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
              answeredButton.leadingAnchor.constraint(equalTo: dataStackView.trailingAnchor).isActive = true
              answeredButton.centerYAnchor.constraint(equalTo: dataStackView.centerYAnchor).isActive = true
              answeredButton.addTarget(self, action: #selector(markAnswer), for: .touchUpInside)
            
            if !answer.markedCorrect {
                answeredButton.backgroundColor = .gray
                answeredButton.setTitleColor(.darkGray, for: .normal)
            }
            
            self.correctButton = answeredButton
        } else if answer.markedCorrect {
            let answeredButton = UIButton()
              answeredButton.roundCorners()
              answeredButton.backgroundColor = UIColor(named: "LightAccent")
              answeredButton.setTitle("Correct Answer", for: .normal)
              answeredButton.titleLabel?.font = UIFont(name: "AirbnbCerealApp-Medium", size: 13)
            answeredButton.titleLabel?.adjustsFontSizeToFitWidth = true
            answeredButton.setTitleColor(UIColor(named: "Accent1"), for: .normal)
              answeredButton.titleEdgeInsets = UIEdgeInsets(top: 3, left: 8, bottom: 3, right: 8)
              self.addSubview(answeredButton)
              answeredButton.translatesAutoresizingMaskIntoConstraints = false
              answeredButton.widthAnchor.constraint(equalToConstant: 90).isActive = true
              answeredButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
              answeredButton.leadingAnchor.constraint(equalTo: dataStackView.trailingAnchor).isActive = true
              answeredButton.centerYAnchor.constraint(equalTo: dataStackView.centerYAnchor).isActive = true
            answeredButton.isUserInteractionEnabled = false
            self.correctButton = answeredButton
        }

        if let likedContent = User.sharedInstance.likedContent, let answerID = answer.answerID, likedContent.contains(answerID) {
                likeButton.setImage(UIImage(named: "likeButtonFill"), for: .normal)
                likeButton.isSelected = true
        } else if let dislikedContent = User.sharedInstance.dislikedContent, let answerID = answer.answerID, dislikedContent.contains(answerID) {
                dislikeButton.setImage(UIImage(named: "dislikeButtonFill"), for: .normal)
                dislikeButton.isSelected = true
        }
        
        answerBody.deactivateSimmer()
        dateLabel.deactivateSimmer()
        usernameLabel.deactivateSimmer()
        profileImage.deactivateSimmer()

        if let userImage = answer.profileImage {
            self.profileImage.image = userImage
        }
                self.answerBody.backgroundColor = .clear
                self.dateLabel.backgroundColor = .clear
                self.usernameLabel.backgroundColor = .clear
                self.answerBody.text = answer.answerBody
                self.dateLabel.text = Date().todayDate()
                self.usernameLabel.text = "@\(answer.username)"
    }
}
