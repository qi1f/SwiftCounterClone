//
//  ViewController.swift
//  SwiftCounterClone
//
//  Created by Fan Qi on 8/19/15.
//  Copyright (c) 2015 f_qi. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let timeButtonInfos = [("1分", 60), ("3分", 180), ("5分", 300), ("秒", 1)]
    var timer: NSTimer?
    
    var isCounting: Bool = false {
        willSet(newValue) {
            if newValue {
                timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "updateTimer", userInfo: nil, repeats: true)
            } else {
                timer?.invalidate()
                timer = nil
            }
            setSettingButtonsEnabled(!newValue)
        }
    }
    var remainingSeconds: Int = 0 {
        willSet(newSeconds) {
            let mins = newSeconds / 60
            let seconds = newSeconds % 60
            timeLabel.text = NSString(format: "%02d:%02d", mins, seconds) as String
        }
    }
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet var disableButtonCollection: [UIButton] = []
    
    
    @IBAction func timeButtons(sender: UIButton) {
        
        let (_, seconds) = timeButtonInfos[sender.tag]
        remainingSeconds += seconds
    }
    @IBAction func startStopButton(sender: UIButton) {
        
        isCounting = !isCounting
        if isCounting {
            createAndFireLocalNotificationAfterSeconds(remainingSeconds)
        } else {
            UIApplication.sharedApplication().cancelAllLocalNotifications()
        }
    }
    @IBAction func clearButton(sender: UIButton) {
        
        remainingSeconds = 0
    }
    
    func updateTimer() {
        remainingSeconds -= 1
        
        if remainingSeconds <= 0 {
            isCounting = false
            timeLabel.text = "00:00"
            remainingSeconds = 0
            
            let alert = UIAlertView()
            alert.title = "Pomodoro ended"
            alert.message = ""
            alert.addButtonWithTitle("OK")
            alert.show()
        }
    }
    
    func createAndFireLocalNotificationAfterSeconds(seconds: Int) {
        UIApplication.sharedApplication().cancelAllLocalNotifications()
        let notification = UILocalNotification()
        let timeIntervalSinceNow = Double(seconds)
        
        notification.fireDate = NSDate(timeIntervalSinceNow: timeIntervalSinceNow)
        notification.timeZone = NSTimeZone.systemTimeZone()
        notification.alertBody = "Podomoro ended"
        
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
    }
    
    func setSettingButtonsEnabled(enabled: Bool) {
        for button in disableButtonCollection {
            button.enabled = enabled
            button.alpha = enabled ? 1.0 : 0.3
        }
    }
}

