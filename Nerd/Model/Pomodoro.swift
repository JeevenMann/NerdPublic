//
//  Pomodoro.swift
//  Study Timer
//
//  Created by Navjeeven Mann on 2020-05-23.
//  Copyright © 2020 Navjeeven Mann. All rights reserved.
//

import Foundation
import UIKit

// Declare enum for timerStatus
enum status {
    case normal, shortBreak, longBreak
}

class Pomodoro {
    // Declare countdown constants and class singleton
    static var sharedInstance = Pomodoro()
    var timerStatus: status = .normal
    var seconds: Int = 59
    var currentTime = 1
    var normalTime = 25
    var shortBreakTime = 2
    var longBreakTime = 1
    var sprintTarget = 4
    var sessionTarget = 12
    var sprintRate = 0
    var sessionRate = 0
    var backgroundDate: Date?
    var isStarted: Bool = false
    var normalColor: UIColor = .blue
    var shortBreakColor: UIColor = .gray
    var longBreakColor: UIColor = .purple

    init() {
        // Decrease the sprint time by 1 to account for the timer starting
        self.currentTime = normalTime - 1
    }

    func restartTimer() {
        self.currentTime = normalTime - 1
        self.sprintRate = 0
        self.sessionRate = 0
    }
    
    func returnFromBackground() {
        // Purpose of this function is to get the difference between when the user leaves and returns to the app
        // Get the date the user went to the background

        if let backgroundDate = self.backgroundDate {

            // Get the difference in seconds and the current total time
            let difference = Int(Date().timeIntervalSince(backgroundDate).rounded())
            let timerSeconds = (self.currentTime * 60) + seconds

            // if the user has left longer than the remaining time in the timer
            if (timerSeconds - difference) < 0 {
                // get the remaining time
                var remainderTime = abs(timerSeconds - difference)

                // continue the timerStatus to the appropriate value
                while remainderTime > 0 {
                    
                    timerControl()

                    switch timerStatus {
                    case .longBreak:
                        remainderTime -= self.longBreakTime * 60
                    case .normal:
                        remainderTime -= self.normalTime * 60
                    case .shortBreak:
                        remainderTime -= self.shortBreakTime * 60
                    }
                }
                print("Diff:\(remainderTime)")
                remainderTime = abs(remainderTime)
                // Appropriately update values
                self.currentTime = (remainderTime % 3600) / 60
                self.seconds = (seconds % 3600) % 60
            } else {
                print("Diff:\(difference) Timer: \(timerSeconds)")
                // Appropriately update values
                self.currentTime -= (difference % 3600) / 60
                self.seconds -= (difference % 3600) % 60
            }
        }
    }

    func getBackgroundColor() -> UIColor {
        switch self.timerStatus {

        case .longBreak: return self.longBreakColor
        case .normal: return self.normalColor
        case .shortBreak: return self.shortBreakColor
        }
    }
    
    func timerControl () {
        var rate = 0
        // The timer has ended and so we are updating to the next status
        switch self.timerStatus {
        case .normal:
            rate = 1
            // The user has a longBreak now since the sprint and session target's have been met or short break otherwise
            if ((self.sprintRate == self.sprintTarget) && (self.sessionRate == self.sessionTarget)) || (self.sprintRate == self.sprintTarget) {
                self.timerStatus = .longBreak
                self.currentTime = self.longBreakTime
            } else {
                self.timerStatus = .shortBreak
                self.currentTime = self.shortBreakTime
            }
            // Continue the normal status
        case .longBreak, .shortBreak:
            self.currentTime = self.normalTime
            self.timerStatus = .normal
        }
        // Update the timer rate
        self.sessionRate += rate
        self.sprintRate += rate
    }

    @objc func countdown() {
        if seconds != 0 {
            seconds -= 1
        } else {
            currentTime -= 1
            seconds = 59
        }
    }

    func timerMax() -> Int {
        switch timerStatus {
        case .longBreak:
            return longBreakTime
        case .shortBreak:
            return shortBreakTime
        case .normal:
            return normalTime
        default:
            return 0
        }
    }
}
