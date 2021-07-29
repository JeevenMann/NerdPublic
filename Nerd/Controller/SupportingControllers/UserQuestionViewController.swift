//
//  UserQuestionViewController.swift
//  Studee
//
//  Created by Navjeeven Mann on 2021-05-23.
//  Copyright © 2021 Navjeeven Mann. All rights reserved.
//

import UIKit

class UserQuestionViewController: UIViewController {

    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var questionTableView: UITableView!
    var questionArray: [Question] = User.sharedInstance.userQuestions ?? []
    override func viewDidLoad() {
        super.viewDidLoad()
        questionTableView.delegate = self
        questionTableView.dataSource = self
        questionTableView.register(UINib(nibName: "QuestionCell", bundle: nil), forCellReuseIdentifier: "questionCell")
        questionTableView.separatorStyle = .none
    }

    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

    deinit {
        print("Deinit UVC")
    }
}

extension UserQuestionViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return questionArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(withIdentifier: "questionCell") as? QuestionCell  else {
            return UITableViewCell()
        }
        cell.selectionStyle = .none
        cell.profileImage.image = User.sharedInstance.profileImage
        cell.setData(question: questionArray[indexPath.row])

        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        if let questionPageVC = storyboard?.instantiateViewController(identifier: "questionPageVC") as? QuestionPageViewController {

            questionPageVC.questionPresented = questionArray[indexPath.row]
            self.navigationController?.pushViewController(questionPageVC, animated: true)
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 180
    }
}
