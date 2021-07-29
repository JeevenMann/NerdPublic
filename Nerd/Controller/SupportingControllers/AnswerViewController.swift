//
//  AnswerViewController.swift
//  Nerd
//
//  Created by Navjeeven Mann on 2021-05-27.
//  Copyright © 2021 Navjeeven Mann. All rights reserved.
//

import UIKit
import WebKit

class AnswerViewController: UIViewController {
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var questionTitle: UITextView!
    @IBOutlet weak var questionBody: UITextView!
    @IBOutlet weak var answerBody: UITextView!
    @IBOutlet weak var attatchmentCollectionView: UICollectionView!
    @IBOutlet weak var addAttatchmentButton: UIButton!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var attatchmentParentView: UIView!
    @IBOutlet weak var usernameLabel: UITextField!
    @IBOutlet weak var dateLabel: UITextField!
    @IBOutlet weak var profileImage: UIImageView!

    var question: Question?
    var attatchmentArray: [Attatchment] = []
    var webView: WKWebView?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.questionTitle.text = question?.questionTitle
        self.questionBody.text = question?.questionBody

        profileImage.roundCorners()
        questionTitle.roundCorners()
        questionBody.roundCorners()
        answerBody.roundCorners()
        attatchmentParentView.roundCorners()
        submitButton.roundCorners()
        
        answerBody.delegate = self
        answerBody.backgroundColor = .white
        answerBody.textColor = .lightGray

        attatchmentCollectionView.delegate = self
        attatchmentCollectionView.dataSource = self
        attatchmentCollectionView.register(UINib(nibName: "attatchmentCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "attatchmentCell")

        usernameLabel.text = "@\(question?.username ?? "User")"
        dateLabel.text = question?.questionDate
        profileImage.image = question?.userProfileImage
        // Do any additional setup after loading the view.
    }

    @IBAction func backAction(_ sender: Any) {
        print("Here")
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func submitAction(_ sender: Any) {
        if let bodyText = self.answerBody.text, !bodyText.isEmpty, let question = question {
            let answer = Answer(answerBody: bodyText, answerDate: Date().todayDate(), questionAnswered: question, username: User.sharedInstance.username)
            DatabaseManager.sharedInstance.uploadAnswer(answer)
        } else {
            let popupView = PopupView(frame: self.view.frame, text: "Please enter your answer.", image: UIImage(systemName: "text.alignleft")!)
            self.view.addSubview(popupView)
        }
    }
    @IBAction func addAttatchmentButton(_ sender: Any) {

        let alertController = UIAlertController(title: "Add Attatchment", message: nil, preferredStyle: .actionSheet)

        if let popover = alertController.popoverPresentationController {
            popover.sourceView = self.view
            popover.sourceRect = CGRect(x: self.view.center.x, y: self.view.frame.maxY + 100, width: 0, height: 0)
            popover.permittedArrowDirections = []
        }

        let imageAction = UIAlertAction(title: "Select an image", style: .default, handler: {(_) in

            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.imageExportPreset = .compatible
            imagePicker.sourceType = .photoLibrary
            self.present(imagePicker, animated: true, completion: nil)
        })

        let fileAction = UIAlertAction(title: "Select a file", style: .default, handler: {(_) in
            let filePicker = UIDocumentPickerViewController(forOpeningContentTypes: [.pdf, .png, .heic, .image, .jpeg], asCopy: true)
            filePicker.delegate = self
            filePicker.allowsMultipleSelection = true

            self.present(filePicker, animated: true, completion: nil)
        })

        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
        alertController.addAction(imageAction)
        alertController.addAction(fileAction)
        alertController.addAction(cancelAction)

        self.present(alertController, animated: true, completion: nil)
    }
}

extension AnswerViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return attatchmentArray.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "attatchmentCell", for: indexPath) as? attatchmentCollectionViewCell {
            let attatchment = attatchmentArray[indexPath.row]
            cell.setProprties(attatchment, indexPath.row, allowDelete: true)
            cell.delegate = self
            return cell
        } else {
            return UICollectionViewCell()
        }
    }
}

extension AnswerViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let image = info[.originalImage] as? UIImage, let imageURL = info[.imageURL] as? URL {
            print(imageURL)
            let attatchment = Attatchment(image: image, url: imageURL)
            attatchmentArray.append(attatchment)
            attatchmentCollectionView.reloadData()
            picker.dismiss(animated: true, completion: nil)
        }
    }
}

extension AnswerViewController: UIDocumentPickerDelegate {
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {

        for documentURL in urls {

            let attatchment = Attatchment(url: documentURL)
            attatchmentArray.append(attatchment)
        }
        attatchmentCollectionView.reloadData()
        controller.dismiss(animated: true, completion: nil)
    }
}

extension AnswerViewController: AttatchmentProtocol {
    func removeAttatchment(_ rowLocation: Int) {
        self.attatchmentArray.remove(at: rowLocation)
        self.attatchmentCollectionView.deleteItems(at: [IndexPath(row: rowLocation, section: 0)])
        self.attatchmentCollectionView.reloadItems(at: self.attatchmentCollectionView.indexPathsForVisibleItems)
    }

    func viewAttatchment(_ attatchment: Attatchment) {

        let webView = WKWebView()
        let request = URLRequest(url: attatchment.attatchmentURL!)
        webView.load(request)
        webView.navigationDelegate = self
        webView.scrollView.isScrollEnabled = false
        self.webView = webView
    }
}

extension AnswerViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        let webVC = UIViewController()
        webVC.view = webView
        webVC.modalPresentationStyle = .popover

        self.present(webVC, animated: true, completion: nil)
    }
}
extension AnswerViewController: UITextViewDelegate {

    func textViewDidBeginEditing(_ textView: UITextView) {

        if textView.textColor == .lightGray {
            textView.text = nil
            textView.textColor = .black
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Write Your Answer..."
            textView.textColor = .lightGray
        }
    }
}
