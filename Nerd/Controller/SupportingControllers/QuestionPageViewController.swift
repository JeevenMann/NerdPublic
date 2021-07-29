//
//  QuestionPageViewController.swift
//  Nerd
//
//  Created by Navjeeven Mann on 2021-06-04.
//  Copyright © 2021 Navjeeven Mann. All rights reserved.
//

import UIKit
import WebKit

class QuestionPageViewController: UIViewController {

    @IBOutlet weak var categoryView: categoryView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var questionScrollView: UIScrollView!
    @IBOutlet weak var questionTitle: UITextView!
    @IBOutlet weak var questionBody: UITextView!
    @IBOutlet weak var usernameLabel: UITextField!
    @IBOutlet weak var dateLabel: UITextField!
    @IBOutlet weak var answerTableView: UITableView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var attatchmentCollectionView: UICollectionView!
    @IBOutlet weak var dataStack: UIStackView!
    var answerArray: [Answer] = []
    var questionAttatchments: [Attatchment] = []
    var questionPresented: Question?
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var upperConstraint: NSLayoutConstraint!
    @IBOutlet var bottomConstraints: [NSLayoutConstraint]!
    @IBOutlet weak var answerField: UITextField!
    @IBOutlet weak var answerFieldBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var pointLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var dislikeButton: UIButton!
    @IBOutlet weak var bookmarkButton: UIButton!
    
    @IBOutlet weak var tableviewHeightConstraint: NSLayoutConstraint!

    var correctAnswerCell: AnswerCell?
    var answersLoaded = false
    var webView: WKWebView?
    override func viewDidLoad() {
        super.viewDidLoad()

        attatchmentCollectionView.activateShimmer()
        
        self.hideKeyboardWhenTappedAround()
        answerField.delegate = self
        
        setUIProperties()

        self.answerTableView.register(UINib(nibName: "AnswerCell", bundle: nil), forCellReuseIdentifier: "answerCell")
        self.answerTableView.delegate = self
        self.answerTableView.dataSource = self
        self.answerTableView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)

        let refreshControl = UIRefreshControl()
        refreshControl.backgroundColor = .clear
        refreshControl.tintColor = .clear
        refreshControl.addTarget(self, action: #selector(refreshData(refreshControl:)), for: .valueChanged)
        self.questionScrollView.refreshControl = refreshControl

        if let logoView = Bundle.main.loadNibNamed("logoAnimationView", owner: self, options: nil)![0] as? UIView as? logoAnimationView {
            logoView.frame = refreshControl.bounds
            refreshControl.addSubview(logoView)
        }

        guard let question = self.questionPresented else {
            return
        }
        DatabaseManager.sharedInstance.getAnswers(question, completion: {(answers) in
            self.answersLoaded = true
            if answers.count != 0 {
                self.answerArray = answers
            }
            self.answerTableView.reloadData()
        })

        DatabaseManager.sharedInstance.loadAttatchments(question: question, completion: {(attatchments) in

            if attatchments.count != 0 {
                print(attatchments.count)
                self.questionAttatchments = attatchments
                self.attatchmentCollectionView.reloadData()
                self.attatchmentCollectionView.deactivateSimmer()
            }
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(sender:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(sender:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc func refreshData(refreshControl: UIRefreshControl) {
        if let logoView = refreshControl.subviews.last as? UIView as? logoAnimationView {
            logoView.startAnimation()
        }
        Timer.scheduledTimer(withTimeInterval: 5.0, repeats: false, block: {_ in
            refreshControl.endRefreshing()
        })
    }
    
    @objc func keyboardWillShow(sender: NSNotification) {
        guard let userInfo = sender.userInfo else { return }
        guard let keyboardSize = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        self.answerFieldBottomConstraint.constant = keyboardSize.height

        UIView.animate(withDuration: 0.5, animations: {
            self.view.layoutIfNeeded()
        })
    }

    @objc func keyboardWillHide(sender: NSNotification) {
        guard let userInfo = sender.userInfo else { return }
        guard let keyboardSize = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        self.answerFieldBottomConstraint.constant = 0 // Move view to original position

        UIView.animate(withDuration: 0.5, animations: {
            self.view.layoutIfNeeded()
        })
    }

    func setUIProperties() {
        guard let question = questionPresented else {
            return
        }
        if question.firebaseAttatchments.count == 0 {
            
            bottomConstraints.forEach({
                $0.isActive = false
            })
            upperConstraint.isActive = false
            questionBody.bottomAnchor.constraint(equalTo: categoryView.topAnchor, constant: -15).isActive = true
            
            attatchmentCollectionView.isHidden = true
        } else {
            attatchmentCollectionView.register(UINib(nibName: "attatchmentCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "attatchmentCell")
            attatchmentCollectionView.delegate = self
            attatchmentCollectionView.dataSource = self
        }
        
        if question.questionAnswered {
            let answeredButton = UIButton()
              answeredButton.roundCorners()
              answeredButton.backgroundColor = UIColor(named: "Accent1")
              answeredButton.setTitle("Answered Correctly", for: .normal)
              answeredButton.titleLabel?.font = UIFont(name: "AirbnbCerealApp-Light", size: 15)
              answeredButton.titleLabel?.adjustsFontSizeToFitWidth = true
              answeredButton.titleLabel?.textColor = .white
              answeredButton.titleEdgeInsets = UIEdgeInsets(top: 3, left: 8, bottom: 3, right: 8)
            self.contentView.addSubview(answeredButton)
              answeredButton.translatesAutoresizingMaskIntoConstraints = false
              answeredButton.widthAnchor.constraint(greaterThanOrEqualToConstant: 120).isActive = true
              answeredButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
              answeredButton.leadingAnchor.constraint(equalTo: dataStack.trailingAnchor).isActive = true
              answeredButton.centerYAnchor.constraint(equalTo: dataStack.centerYAnchor).isActive = true
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
                
                likeButton.setImage(UIImage(named: "likeButtonFill"), for: .normal)
                likeButton.isSelected = true
            }
        } else if let dislikedContent = User.sharedInstance.dislikedContent, let questionID = question.questionID {
            if dislikedContent.contains(questionID) {
                
                dislikeButton.setImage(UIImage(named: "dislikeButtonFill"), for: .normal)
                dislikeButton.isSelected = true
            }
        }
        self.categoryView.setInfo(name: question.category.toString())
        self.questionTitle.text = question.questionTitle
        self.questionBody.text = question.questionBody
        self.usernameLabel.text = "@\(question.username)"
        self.dateLabel.text = question.questionDate
        self.profileImage.image = question.userProfileImage
        self.pointLabel.text = "\(question.questionPoints)"
        self.profileImage.makeRounded()
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
    @IBAction func likeClick(_ sender: Any) {

        guard User.sharedInstance.getUserType() != .anonymousUser else {
            self.presentGuestAlert()
            return
        }

        if let questionPresented = questionPresented {
            var pointValue = questionPresented.questionPoints
        switch likeButton.isSelected {
        case true:
            likeButton.isSelected = false
            likeButton.setImage( UIImage(named: "likeButton"), for: .normal)
                pointValue -= 1
            DatabaseManager.sharedInstance.likeContent(contentID: questionPresented.questionID, remove: true)
        case false:
            likeButton.isSelected = true
            likeButton.setImage( UIImage(named: "likeButtonFill"), for: .normal)
            DatabaseManager.sharedInstance.likeContent(contentID: questionPresented.questionID)

            if dislikeButton.isSelected {
                pointValue += 2
                dislikeButton.isSelected = false
                dislikeButton.setImage( UIImage(named: "dislikeButton"), for: .normal)
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
    @IBAction func dislikeClick(_ sender: Any) {
        guard User.sharedInstance.getUserType() != .anonymousUser else {
            self.presentGuestAlert()
            return
        }

        if let questionPresented = questionPresented {
            var pointValue = questionPresented.questionPoints
            switch dislikeButton.isSelected {
            case true:
                dislikeButton.isSelected = false
                dislikeButton.setImage( UIImage(named: "dislikeButton"), for: .normal)
                DatabaseManager.sharedInstance.dislikeContent(contentID: questionPresented.questionID, remove: true)
                pointValue += 1

            case false:
                dislikeButton.isSelected = true
                dislikeButton.setImage( UIImage(named: "dislikeButtonFill"), for: .normal)
                DatabaseManager.sharedInstance.dislikeContent(contentID: questionPresented.questionID)
                if likeButton.isSelected {
                    likeButton.isSelected = false
                    likeButton.setImage( UIImage(named: "likeButton"), for: .normal)
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

    @IBAction func answerButtonClick(_ sender: Any) {
        if self.checkUserStatus() {
        if let answerVC = storyboard?.instantiateViewController(identifier: "answerVC") as? AnswerViewController {

            answerVC.question = self.questionPresented
            answerVC.modalPresentationStyle = .fullScreen
            answerVC.modalTransitionStyle = .crossDissolve
            self.navigationController?.pushViewController(answerVC, animated: true)
        }
        }
    }
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey: Any]?, context: UnsafeMutableRawPointer?) {
        if let obj = object as? UITableView {
            if obj == self.answerTableView && keyPath == "contentSize" {
                if let newSize = change?[NSKeyValueChangeKey.newKey] as? CGSize {
                    let height = newSize.height // <----- your height!

                    if answerArray.count != 0 {
                    tableviewHeightConstraint.constant = height
                    self.answerTableView.backgroundView = nil
                    } else {
                        let emptyView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.answerTableView.frame.height * 0.3))

                        let textLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 80))
                        textLabel.text = "It's quiet"
                        textLabel.textColor = .lightGray
                        textLabel.font = UIFont(name: "PublicSans-Bold", size: 15)
                        emptyView.addSubview(textLabel)
                        textLabel.translatesAutoresizingMaskIntoConstraints = false
                        textLabel.centerYAnchor.constraint(equalTo: emptyView.centerYAnchor).isActive = true
                        textLabel.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor).isActive = true

                        let smallTextLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 80))
                        smallTextLabel.text = "A little too quiet..."
                        smallTextLabel.textColor = .lightGray
                        smallTextLabel.font = UIFont(name: "PublicSans-Bold", size: 12)
                        emptyView.addSubview(smallTextLabel)
                        smallTextLabel.translatesAutoresizingMaskIntoConstraints = false
                        smallTextLabel.topAnchor.constraint(equalTo: textLabel.bottomAnchor).isActive = true
                        smallTextLabel.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor).isActive = true

                        self.answerTableView.backgroundView = emptyView
                    }
                }
            }
        }
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
        self.answerTableView.removeObserver(self, forKeyPath: "contentSize")
    }
}

    // MARK: - Table view
extension QuestionPageViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return questionPresented?.questionAnswered ?? false ? 2 : 1
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 40))
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: headerView.frame.width * 0.5, height: headerView.frame.height))
        headerView.backgroundColor = UIColor(named: "BackgroundColor")
        if tableView.numberOfSections == 2 {
            if section == 0 {
                titleLabel.text = "Correct Answer"
            } else {
                titleLabel.text = "Answers"
            }
        } else {
            titleLabel.text = "Answers"
        }

        titleLabel.font = UIFont(name: "PublicSans-Bold", size: 20)
        headerView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 10).isActive = true
        titleLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor).isActive = true
        return headerView
    }

     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        return UITableView.automaticDimension
    }

     func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 145
    }

     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
         if answersLoaded && answerArray.count == 0 {
            tableView.separatorStyle = .none
             return 0
         } else if answerArray.count == 0 {
             return 5
         } else {
             if tableView.numberOfSections == 2 {
                 if section == 0 {
                     return 1
                 } else {
                     return answerArray.count - 1
                 }
             } else {
                 return answerArray.count
             }
         }
    }

     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard self.questionPresented != nil else {
            return UITableViewCell()
        }

            if let answerCell = tableView.dequeueReusableCell(withIdentifier: "answerCell") as? AnswerCell {

                if answerArray.count == 0 {
                    return answerCell
                } else {
                if tableView.numberOfSections == 2 {
                    if indexPath.section == 0 {
                        answerCell.markDelegate = self
                        answerCell.setData(answerArray[0])
                        self.correctAnswerCell = answerCell
                        return answerCell
                    } else {
                        answerCell.markDelegate = self
                        answerCell.setData(answerArray[indexPath.row + 1])
                        return answerCell
                    }
                } else {
                    answerCell.markDelegate = self
                    answerCell.setData(answerArray[indexPath.row])
                    return answerCell
                }
                }
            } else {
                return UITableViewCell()
            }
    }
}
extension QuestionPageViewController: AttatchmentProtocol {
    func removeAttatchment(_ rowLocation: Int) {
        print("")
    }

    func viewAttatchment(_ attatchment: Attatchment) {
        let webView = WKWebView()
        webView.navigationDelegate = self
        webView.scrollView.isScrollEnabled = false

        let request = URLRequest(url: attatchment.attatchmentURL!)
        webView.load(request)
        self.webView = webView
    }
    }

extension QuestionPageViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        let webVC = UIViewController()
        webVC.view = webView
        webVC.modalPresentationStyle = .popover

        self.present(webVC, animated: true, completion: nil)
    }
}
extension QuestionPageViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return questionAttatchments.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let question = questionPresented else {
            return UICollectionViewCell()
        }

        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "attatchmentCell", for: indexPath) as? attatchmentCollectionViewCell {
            if self.questionAttatchments.count > 0 {
            cell.setProprties(questionAttatchments[indexPath.row], indexPath.row, allowDelete: false)
            cell.delegate = self
            }
            return cell
        } else {
      
            return UICollectionViewCell()
        }
    }
}
extension QuestionPageViewController: MarkProtocol {
    func cellMarked(markedCell: AnswerCell, markedCorrect: Bool) {
        guard let updateAnswer = markedCell.answer else { return }
        if let correctCell = self.correctAnswerCell, let oldAnswer = correctCell.answer {
             correctCell.markIncorrect()

            if markedCorrect {
                DatabaseManager.sharedInstance.updateAnswer(oldAnswer: oldAnswer, newAnswer: updateAnswer)
                self.correctAnswerCell = markedCell
            } else {
                DatabaseManager.sharedInstance.updateAnswer(oldAnswer: updateAnswer)
                self.correctAnswerCell = nil
            }
        } else {
            DatabaseManager.sharedInstance.updateAnswer(oldAnswer: updateAnswer)
            self.correctAnswerCell = markedCell
        }
    }
}
extension QuestionPageViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        guard let answerText = textField.text, let questionAnswered = self.questionPresented else {
            return true
        }
        print(answerText.isEmpty)
        if !answerText.isEmpty {
            let answerResponse = Answer(answerBody: answerText, answerDate: Date().todayDate(), questionAnswered: questionAnswered, username: User.sharedInstance.getUsername())
            DatabaseManager.sharedInstance.uploadAnswer(answerResponse)
            answerResponse.profileImage = User.sharedInstance.profileImage
            self.answerArray.append(answerResponse)
            answerTableView.reloadData()
        }
        return true
    }
}
