//
//  QuestionCell.swift
//  Studee
//
//  Created by Navjeeven Mann on 2021-02-13.
//  Copyright © 2021 Navjeeven Mann. All rights reserved.
//

import UIKit
import AudioToolbox
protocol PresentAlertProtocol: UIViewController {
    func presentAlert()
}

class QuestionCell: UITableViewCell {

    @IBOutlet weak var answerCountLabel: UILabel!
    @IBOutlet weak var bookmarkButton: UIButton!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var upArrow: UIButton!
    @IBOutlet weak var downArrow: UIButton!
    @IBOutlet weak var pointLabel: UILabel!
    
    weak var alertDelegate: PresentAlertProtocol?
    var questionPresented: Question?
    override func awakeFromNib() {
        super.awakeFromNib()

        bookmarkButton.imageView?.contentMode = .scaleAspectFit
        bookmarkButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        self.profileImage.makeRounded()
        self.usernameLabel.activateShimmer()
        self.dateLabel.activateShimmer()
        self.profileImage.activateShimmer()
        self.textView.activateShimmer()
        self.answerCountLabel.activateShimmer()
        self.backgroundColor = .darkGray
        self.contentView.backgroundColor = UIColor(named: "BackgroundColor")

        upArrow.titleLabel?.text = ""
        downArrow.titleLabel?.text = ""

        upArrow.roundCorners()
        downArrow.roundCorners()

        // Initialization code
        upArrow.tintColor = .black
        downArrow.tintColor = .black

        textView.textContainer.lineFragmentPadding = 0
        textView.textContainerInset = .zero
    }

    deinit {
        print("Deinit Cell")
    }

    @IBAction func bookmarkQuestion(_ sender: Any) {
        let tapticFeedback = UINotificationFeedbackGenerator()
        tapticFeedback.notificationOccurred(.success)
        
        guard let questionPresented = self.questionPresented, let questionID = self.questionPresented?.questionID else {
            return
        }
        
        if questionPresented.isBookmarked {
            bookmarkButton.setImage(UIImage(named: "Bookmark"), for: .normal)
            questionPresented.isBookmarked = false
            DatabaseManager.sharedInstance.bookmarkQuestion(toBookmark: questionID, true)
            User.sharedInstance.bookmarkedQuestions?.append(questionID)
        } else {
            bookmarkButton.setImage(UIImage(named: "BookmarkFill"), for: .normal)
            questionPresented.isBookmarked = true
            DatabaseManager.sharedInstance.bookmarkQuestion(toBookmark: questionID)
        }
    }

    @IBAction func upClick(_ sender: Any) {

        guard User.sharedInstance.getUserType() != .anonymousUser else {
            alertDelegate?.presentAlert()
            return
        }

        if let questionPresented = questionPresented {
            var pointValue = questionPresented.questionPoints
        switch upArrow.isSelected {
        case true:
            upArrow.isSelected = false
            upArrow.setImage( UIImage(named: "likeButton"), for: .normal)
                pointValue -= 1
            DatabaseManager.sharedInstance.likeContent(contentID: questionPresented.questionID, remove: true)
        case false:
            upArrow.isSelected = true
            upArrow.setImage( UIImage(named: "likeButtonFill"), for: .normal)
            DatabaseManager.sharedInstance.likeContent(contentID: questionPresented.questionID)

            if downArrow.isSelected {
                pointValue += 2
                downArrow.isSelected = false
                downArrow.setImage( UIImage(named: "dislikeButton"), for: .normal)
                DatabaseManager.sharedInstance.dislikeContent(contentID: questionPresented.questionID, remove: true)
            } else {
                pointValue += 1
            }
            }

        pointLabel.text = "\(pointValue)"
        questionPresented.questionPoints = pointValue
        DatabaseManager.sharedInstance.updateQuestion(toUpdate: questionPresented)
        }
    }
    @IBAction func downClick(_ sender: Any) {
        guard User.sharedInstance.getUserType() != .anonymousUser else {
            alertDelegate?.presentAlert()
            return
        }

        if let questionPresented = questionPresented {
            var pointValue = questionPresented.questionPoints
            switch downArrow.isSelected {
            case true:
                downArrow.isSelected = false
                downArrow.setImage( UIImage(named: "dislikeButton"), for: .normal)
                DatabaseManager.sharedInstance.dislikeContent(contentID: questionPresented.questionID, remove: true)
                pointValue += 1

            case false:
                downArrow.isSelected = true
                downArrow.setImage( UIImage(named: "dislikeButtonFill"), for: .normal)
                DatabaseManager.sharedInstance.dislikeContent(contentID: questionPresented.questionID)
                if upArrow.isSelected {
                    upArrow.isSelected = false
                    upArrow.setImage( UIImage(named: "likeButton"), for: .normal)
                    DatabaseManager.sharedInstance.likeContent(contentID: questionPresented.questionID, remove: true)
                    pointValue -= 2
                } else {
                    pointValue -= 1
                }
            }

            pointLabel.text = "\(pointValue)"
            questionPresented.questionPoints = pointValue
            DatabaseManager.sharedInstance.updateQuestion(toUpdate: questionPresented)
        }
    }

    func setData(question: Question) {

        if question.questionAnswered {
          let answeredButton = UIButton()
            answeredButton.roundCorners()
            answeredButton.backgroundColor = UIColor(named: "Accent1")
            answeredButton.setTitle("Answered Correctly", for: .normal)
            answeredButton.titleLabel?.font = UIFont(name: "AirbnbCerealApp-Light", size: 15)
            answeredButton.titleLabel?.adjustsFontSizeToFitWidth = true
            answeredButton.titleLabel?.textColor = .white
            answeredButton.titleEdgeInsets = UIEdgeInsets(top: 3, left: 8, bottom: 3, right: 8)
            self.addSubview(answeredButton)
            answeredButton.translatesAutoresizingMaskIntoConstraints = false
            answeredButton.widthAnchor.constraint(greaterThanOrEqualToConstant: 120).isActive = true
            answeredButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
            answeredButton.leadingAnchor.constraint(equalTo: usernameLabel.trailingAnchor).isActive = true
            answeredButton.centerYAnchor.constraint(equalTo: bookmarkButton.centerYAnchor).isActive = true
        }
        
        if question.isBookmarked {
            bookmarkButton.setImage(UIImage(named: "BookmarkFill"), for: .normal)
        } else if let bookmarkedQuestions = User.sharedInstance.bookmarkedQuestions, let questionID = question.questionID {
            if bookmarkedQuestions.contains(questionID) {
                bookmarkButton.setImage(UIImage(named: "BookmarkFill"), for: .normal)
            }
        }

        if let likedContent = User.sharedInstance.likedContent, let questionID = question.questionID {
            if likedContent.contains(questionID) {
                
                upArrow.setImage(UIImage(named: "likeButtonFill"), for: .normal)
                upArrow.isSelected = true
            }
        } else if let dislikedContent = User.sharedInstance.dislikedContent, let questionID = question.questionID {
            if dislikedContent.contains(questionID) {
                
                downArrow.setImage(UIImage(named: "dislikeButtonFill"), for: .normal)
                downArrow.isSelected = true
            }
        }

        pointLabel.text = "\(question.questionPoints)"
        self.questionPresented = question
        
        let category = categoryView(frame: CGRect(x: 0, y: 0, width: 50, height: 30), categoryName: question.category.toString())
        self.addSubview(category)
        
        category.translatesAutoresizingMaskIntoConstraints = false
        category.leadingAnchor.constraint(equalTo: answerCountLabel.leadingAnchor).isActive = true
        category.topAnchor.constraint(equalTo: answerCountLabel.bottomAnchor, constant: 10).isActive = true
        category.widthAnchor.constraint(greaterThanOrEqualToConstant: 50).isActive = true
        category.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        self.answerCountLabel.text = "\(question.answerCount) Answers"
        self.answerCountLabel.textColor = UIColor(named: "InverseBackgroundColor")
        self.answerCountLabel.backgroundColor = UIColor(named: "BackgroundColor")

        self.usernameLabel.text = "@" + question.username
        self.usernameLabel.textColor = UIColor(named: "InverseBackgroundColor")
        self.usernameLabel.backgroundColor = UIColor(named: "BackgroundColor")

        self.dateLabel.text = question.questionDate
        self.dateLabel.textColor = UIColor(named: "InverseBackgroundColor")
        self.dateLabel.backgroundColor = UIColor(named: "BackgroundColor")

        self.textView.text = question.questionTitle
        self.textView.textColor = UIColor(named: "InverseBackgroundColor")
        self.textView.backgroundColor = UIColor(named: "BackgroundColor")

        self.profileImage.image = question.userProfileImage
        self.usernameLabel.deactivateSimmer()
        self.answerCountLabel.deactivateSimmer()
        self.dateLabel.deactivateSimmer()
        self.profileImage.deactivateSimmer()
        self.textView.deactivateSimmer()
    }
}
