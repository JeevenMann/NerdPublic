//
//  TimerViewController.swift
//  Study Timer
//
//  Created by Navjeeven Mann on 2020-05-22.
//  Copyright © 2020 Navjeeven Mann. All rights reserved.
//

import UIKit
import GaugeKit
import GoogleMobileAds
import ESTabBarController_swift
class TimerViewController: UIViewController, GADInterstitialDelegate, GADBannerViewDelegate {

    // MARK: IBOutlet Variables/Functions

    @IBOutlet private weak var adBanner: GADBannerView!
    @IBOutlet private weak var startButton: UIButton!
    @IBOutlet private weak var adBannerBottom: NSLayoutConstraint!
    @IBOutlet weak private var sprintLabel: UILabel!
    @IBOutlet weak private var sessionLabel: UILabel!
    @IBOutlet weak private var timeGauge: Gauge!
    @IBOutlet weak private var infoView: UIView!
    @IBOutlet weak private var timeLabel: UILabel!

    @IBAction private func startButtonPressed(_ sender: Any) {
        if !countDown.isStarted {
            self.startCountDown()
            countDown.isStarted = true
            self.startButton.setTitle("Pause", for: .normal)
            self.startButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
        } else {
            self.timer?.invalidate()
            countDown.isStarted = false
            self.startButton.setTitle("Play", for: .normal)
            self.startButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
        }
    }

    // MARK: View Variables/Functions
    let countDown: Pomodoro = Pomodoro.sharedInstance
    var fullScreenAd: GADInterstitial!
    var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Set initial values for labels and max value based on the users preference
        setInitialLabelConditions()

        timeGauge.rate = CGFloat(0)
        // Set inital value for both gauges
        self.updateRate()

        // Initialize ad views and delegates
         adBanner = AdManager.sharedInstance.createAndLoadBanner(adBanner)
         adBanner.rootViewController = self
         adBanner.delegate = self
         fullScreenAd = AdManager.sharedInstance.createAndLoadInterstitial()
         fullScreenAd.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.timeLabel.text = "\(String(format: "%02d", self.countDown.currentTime)):\(String(format: "%02d", self.countDown.seconds))"
        self.updateRate()
        self.view.backgroundColor = Pomodoro.sharedInstance.getBackgroundColor()
    }

    func setInitialLabelConditions() {
        // Set the initial values for the labels
        self.startButton.roundCorners()
        self.infoView.layer.cornerRadius = 20
        self.infoView.clipsToBounds = true
        // Move the adBanner up based on how tall the tabBar is

        adBannerBottom.constant = 90
    }

    func startCountDown() {
        // Initialzie the timer
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { [unowned self] timer in

            // Change values and update the labels
            self.countDown.countdown()
            self.timeLabel.text = "\(String(format: "%02d", self.countDown.currentTime)):\(String(format: "%02d", self.countDown.seconds))"

            self.timeGauge.rate = CGFloat( 1 - (Double(self.countDown.currentTime * 60 + self.countDown.seconds) / Double(self.countDown.timerMax() * 60)))
            // If we have reached the end of timer invalidate and update the status of the timer
            if self.countDown.currentTime == 0 && self.countDown.seconds == 0 {
                timer.invalidate()
                self.gaugeControl()
            }
        })
    }

    func gaugeControl() {
        self.timeGauge.rate = CGFloat(0)
        // if the bool value returns true present a fullScreenad
        if Bool.random() {
            fullScreenAd.present(fromRootViewController: self)
        }

        // Change the status of the timer and the values for the gauges
        // And start the countdown again
        self.countDown.timerControl()
        UIView.animate(withDuration: 1.0, animations: {
            self.view.backgroundColor = Pomodoro.sharedInstance.getBackgroundColor()
        })
        self.updateRate()
        self.startCountDown()
    }
    
    func updateRate() {
        // Update the values for the guages
        sprintLabel.text = "\(Pomodoro.sharedInstance.sprintRate) / \(Pomodoro.sharedInstance.sprintTarget)"
        sessionLabel.text = "\(Pomodoro.sharedInstance.sessionRate) / \(Pomodoro.sharedInstance.sessionTarget)"
    }
    
    // MARK: Ad Delegate Methods
    func interstitialDidDismissScreen(_ ad: GADInterstitial) {
        // Load the next fullScreen ad once the current one has been dismissed
        fullScreenAd = AdManager.sharedInstance.createAndLoadInterstitial()
    }

    deinit {
        print("Deinit TimerVC")
    }
}
