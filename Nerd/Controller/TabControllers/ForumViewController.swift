//
//  ForumViewController.swift
//  Study
//
//  Created by Navjeeven Mann on 2020-12-23.
//  Copyright © 2020 Navjeeven Mann. All rights reserved.
//

import UIKit
import Firebase
class ForumViewController: UIViewController {

    @IBOutlet weak var questionTableView: UITableView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var filterButton: UIButton!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var tableviewHeight: NSLayoutConstraint!
    @IBOutlet weak var questionScrollView: UIScrollView!

    var askQuestionButton: UIButton?
    var questionArray: [Question]?
    var adLoader: GADAdLoader!
    var nativeAds: [GADUnifiedNativeAd]?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.profileImage.activateShimmer()

        let multipleAdsOptions = GADMultipleAdsAdLoaderOptions()
        multipleAdsOptions.numberOfAds = 5
        adLoader = GADAdLoader(adUnitID: inScrollAdKey, rootViewController: self, adTypes: [.unifiedNative], options: [multipleAdsOptions])
        adLoader.delegate = self
        loadAd()

        let refreshControl = UIRefreshControl()
        refreshControl.backgroundColor = .clear
        refreshControl.tintColor = .clear
        refreshControl.addTarget(self, action: #selector(refreshData(refreshControl:)), for: .valueChanged)

        if let logoView = Bundle.main.loadNibNamed("logoAnimationView", owner: self, options: nil)![0] as? UIView as? logoAnimationView {
            logoView.frame = refreshControl.bounds
            refreshControl.addSubview(logoView)
        }

        questionTableView.delegate = self
        questionTableView.dataSource = self
        questionTableView.register(UINib(nibName: "QuestionCell", bundle: nil), forCellReuseIdentifier: "questionCell")
        questionTableView.register(UINib(nibName: "NativeAdCell", bundle: nil), forCellReuseIdentifier: "nativeAdCell")
        questionTableView.separatorStyle = .singleLine
        questionTableView.refreshControl = refreshControl
        questionTableView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)

        self.hideKeyboardWhenTappedAround()

        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        questionTableView.reloadData()
    }

    func setupUI() {
        let askQuestionButton = UIButton()
        askQuestionButton.setImage(UIImage(named: "ChatIcon"), for: .normal)
        askQuestionButton.tintColor = .white
        askQuestionButton.backgroundColor = UIColor(named: "Accent1")
        self.view.addSubview(askQuestionButton)
        askQuestionButton.translatesAutoresizingMaskIntoConstraints = false
        askQuestionButton.widthAnchor.constraint(equalToConstant: 75).isActive = true
        askQuestionButton.heightAnchor.constraint(equalToConstant: 75).isActive = true
        askQuestionButton.bottomAnchor.constraint(equalTo: self.questionScrollView.bottomAnchor, constant: -50).isActive = true
        askQuestionButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10).isActive = true
        askQuestionButton.addTarget(self, action: #selector(askQuestion), for: .touchUpInside)
        self.askQuestionButton = askQuestionButton

        searchButton.imageView?.contentMode = .scaleAspectFit
        searchButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)

        filterButton.imageView?.contentMode = .scaleAspectFit
        filterButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)

        self.nameLabel.text = User.sharedInstance.username
        self.timeLabel.text = "Good Morning"
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.profileImage.makeRounded()
        self.askQuestionButton?.makeRounded()
    }

    func setProfileImage() {
        self.profileImage.deactivateSimmer()
        self.profileImage.image = User.sharedInstance.profileImage
    }

    @objc func askQuestion() {
        guard self.checkUserStatus() else {
            return
        }
        
        if let questionFormVC = storyboard?.instantiateViewController(identifier: "formVC") as? QuestionFormViewController {
            self.navigationController?.pushViewController(questionFormVC, animated: true)
        }
    }

    func loadData() {
        DatabaseManager.sharedInstance.getQuestions(completion: { (questionArray)  in

            if self.questionArray == nil {
                self.questionArray = questionArray
                self.questionTableView.reloadData()
            } else {
                if questionArray.count != 0 {
                self.questionArray?.append(contentsOf: questionArray)
                    self.questionTableView.reloadData()
                }
            }
        })
    }

    @objc func refreshData(refreshControl: UIRefreshControl) {

        if let logoView = refreshControl.subviews.last as? UIView as? logoAnimationView {
            logoView.startAnimation()

        DatabaseManager.sharedInstance.getQuestions(completion: { (questionArray)  in
            self.questionArray = questionArray
            self.questionTableView.reloadData()
            refreshControl.endRefreshing()
            logoView.endAnimation()
        })
        }
    }

    func loadAd() {
        
        adLoader.load(GADRequest())
    }
 
    @IBAction func questionButton(_ sender: Any) {
        if self.checkUserStatus() {
        guard let formVC = self.storyboard?.instantiateViewController(identifier: "formVC") as? QuestionFormViewController else {
            return
        }
        formVC.modalPresentationStyle = .fullScreen
        formVC.modalTransitionStyle = .flipHorizontal
        self.navigationController?.pushViewController(formVC, animated: true)
    }
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey: Any]?, context: UnsafeMutableRawPointer?) {
        if let obj = object as? UITableView {
            if obj == self.questionTableView && keyPath == "contentSize" {
                if let newSize = change?[NSKeyValueChangeKey.newKey] as? CGSize {
                    let height = newSize.height // <----- your height!
                    guard let questionArray = self.questionArray else {
                        return
                    }
                    if questionArray.count != 0 {
                        tableviewHeight.constant = height
                    }
                }
            }
        }
    }

    deinit {
        print("Deinit ForumVC")
    }
}

extension ForumViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let questionArray = self.questionArray else {
            return 5
        }
        let numOfAds = Int(questionArray.count / 10)
        return questionArray.count + numOfAds
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row % 10 == 0 && indexPath.row > 0 {

        guard let adArray = self.nativeAds else {
            return UITableViewCell()
        }
            if let nativeAdCell = tableView.dequeueReusableCell(withIdentifier: "nativeAdCell", for: indexPath) as? NativeAdCell {
                let adIndex = Int(indexPath.row / 10) - 1

                nativeAdCell.setAdInfo(nativeAd: adArray[adIndex])

                if (adArray.count - adIndex) < 2 {
                    self.loadAd()
                }

                return nativeAdCell
            }
        return UITableViewCell()
        } else {

        guard let cell = tableView.dequeueReusableCell(withIdentifier: "questionCell") as? QuestionCell  else {
            return UITableViewCell()
        }
        cell.selectionStyle = .none

        if let questionArray = questionArray {
            let adsShown = Int(indexPath.row / 10)

            cell.setData(question: questionArray[indexPath.row - adsShown])
            cell.alertDelegate = self
        }

        return cell
}
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let questionArray = self.questionArray else {
            return
        }

        if indexPath.row == questionArray.count - 3 {
            self.loadData()
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row % 10 == 0 && indexPath.row > 0 {
            return 120
        } else {

            return 185
    }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        if let questionPageVC = storyboard?.instantiateViewController(identifier: "questionPageVC") as? QuestionPageViewController {
            let adsShown = Int(indexPath.row / 10)
            questionPageVC.questionPresented = questionArray?[indexPath.row - adsShown]

            self.navigationController?.pushViewController(questionPageVC, animated: true)
        }
    }
}
extension ForumViewController: GADAdLoaderDelegate, GADUnifiedNativeAdLoaderDelegate {
    func adLoader(_ adLoader: GADAdLoader, didFailToReceiveAdWithError error: GADRequestError) {
    }

    func adLoader(_ adLoader: GADAdLoader, didReceive nativeAd: GADUnifiedNativeAd) {
        nativeAd.rootViewController = self
        if self.nativeAds?.append(nativeAd) == nil {
            self.nativeAds = [nativeAd]
        }
    }

    func adLoaderDidFinishLoading(_ adLoader: GADAdLoader) {
    }
}
extension ForumViewController: PresentAlertProtocol {
    func presentAlert() {
        self.presentGuestAlert()
    }
}
