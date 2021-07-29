//
//  QuestionFormViewController.swift
//  Studee
//
//  Created by Navjeeven Mann on 2021-02-15.
//  Copyright © 2021 Navjeeven Mann. All rights reserved.
//

import UIKit
import WebKit
class QuestionFormViewController: UIViewController {

    @IBOutlet weak var attatchmentParentView: UIView!
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var bodyText: UITextView!
    @IBOutlet weak var attatchmentButton: UIButton!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var attatchmentView: UICollectionView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var categoryCollectionView: UICollectionView!
    
    var attatchmentArray: [Attatchment] = []
    var webView: WKWebView?
    
    var categoryDict: [String] = ["Biology", "Chemistry", "Physics", "Business", "Law", "History", "Math", "Health", "Geography", "Computer Science"]
    var categorySelected: categoryCell?
    override func viewDidLoad() {
        super.viewDidLoad()

        self.hideKeyboardWhenTappedAround()
        attatchmentView.register(UINib(nibName: "attatchmentCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "attatchmentCell")
        attatchmentView.delegate = self
        attatchmentView.dataSource = self
        attatchmentView.tag = 0
        
        categoryCollectionView.register(UINib(nibName: "categoryCell", bundle: nil), forCellWithReuseIdentifier: "categoryCell")
        categoryCollectionView.delegate = self
        categoryCollectionView.dataSource = self
        categoryCollectionView.tag = 1
        
        bodyText.delegate = self
        bodyText.textColor = .lightGray
        bodyText.backgroundColor = .white

        // Do any additional setup after loading the view.

        self.attatchmentButton.roundCorners()
        self.submitButton.roundCorners()
        self.titleField.roundCorners()
        self.bodyText.roundCorners()
        self.attatchmentButton.roundCorners()
        self.attatchmentParentView.roundCorners()
    }

    @IBAction func addAttatchment(_ sender: Any) {

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

    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func submitAction(_ sender: Any) {
        if let titleText = self.titleField.text, let bodyText = self.bodyText.text, !titleText.isEmpty, !bodyText.isEmpty, let categoryCell = self.categorySelected {
            let question = Question(titleText, bodyText, attatchmentArray, User.sharedInstance.username, Date().todayDate(), questionCategory: questionCategory(rawValue: categoryCell.categoryName.lowercased()) ?? .computerscience)
            DatabaseManager.sharedInstance.uploadQuestion(question)
        } else {
            let popupView = PopupView(frame: self.view.frame, text: "Please fill all fields.", image: UIImage(systemName: "text.alignleft")!)
            self.view.addSubview(popupView)
        }
    }
}
extension QuestionFormViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView.tag {
        case 0:
            return attatchmentArray.count
        case 1:
            return categoryDict.count
        default:
            return 0
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch collectionView.tag {
        case 0:
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "attatchmentCell", for: indexPath) as? attatchmentCollectionViewCell {
                let attatchment = attatchmentArray[indexPath.row]
                cell.setProprties(attatchment, indexPath.row, allowDelete: true)
                cell.delegate = self
                return cell
            } else {
                return UICollectionViewCell()
            }
            
        case 1:
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "categoryCell", for: indexPath) as? categoryCell {
                cell.setInfo(name: categoryDict[indexPath.row])
                return cell
            } else {
                return UICollectionViewCell()
            }
            
        default:
            return UICollectionViewCell()
        }
}
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard collectionView.tag == 1 else {
            return
        }
        if let cell = collectionView.cellForItem(at: indexPath) as? categoryCell {
        
        if categorySelected == nil {
            self.categorySelected = cell
            cell.setSelected()
        } else {
            categorySelected?.setUnselected()
            self.categorySelected = cell
            cell.setSelected()
        }
        }
    }
}

extension QuestionFormViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let image = info[.originalImage] as? UIImage, let imageURL = info[.imageURL] as? URL {
            print(imageURL)
            let attatchment = Attatchment(image: image, url: imageURL)
            attatchmentArray.append(attatchment)
            attatchmentView.reloadData()
        picker.dismiss(animated: true, completion: nil)
        }
        }
}

extension QuestionFormViewController: UIDocumentPickerDelegate {
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {

        for documentURL in urls {
        
            let attatchment = Attatchment(url: documentURL)
            attatchmentArray.append(attatchment)
        }
        attatchmentView.reloadData()
        controller.dismiss(animated: true, completion: nil)
    }
}

extension QuestionFormViewController: AttatchmentProtocol {
    func removeAttatchment(_ rowLocation: Int) {
        self.attatchmentArray.remove(at: rowLocation)
        self.attatchmentView.deleteItems(at: [IndexPath(row: rowLocation, section: 0)])
        self.attatchmentView.reloadItems(at: self.attatchmentView.indexPathsForVisibleItems)
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

extension QuestionFormViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        let webVC = UIViewController()
        webVC.view = webView
        webVC.modalPresentationStyle = .popover

        self.present(webVC, animated: true, completion: nil)
    }
}
extension QuestionFormViewController: UITextViewDelegate {

    func textViewDidBeginEditing(_ textView: UITextView) {
        print(textView.textColor)
        if textView.textColor == .lightGray {
            textView.text = nil
            textView.textColor = .black
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Question Body..."
            textView.textColor = .lightGray
        }
    }
}
