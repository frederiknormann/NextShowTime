//
//  ViewController.swift
//  Kogeri Tid
//
//  Created by Jannie Henriksen on 06/12/14.
//  Copyright (c) 2014 Normann Development. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    @IBOutlet weak var nextBatchTimeDatePicker: UIDatePicker!
    @IBOutlet weak var minutePicker: UIPickerView!
    
    @IBOutlet weak var nextBatchLabel: UILabel!
    @IBOutlet weak var nextBatchTimeLabel: UILabel!
    @IBOutlet weak var secondaryResolutionLabel: UILabel!
    @IBOutlet weak var airPlayStatusLabel: UILabel!
    
    @IBOutlet weak var languageSwitch: UISwitch!
    let timeFormatter = NSDateFormatter()
    let pickerData = [0,2,4,6,8,10,12,15,20,25,30,35,40,45]
    
    let appDelegate = (UIApplication.sharedApplication().delegate as AppDelegate)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Timer that updates the datepicker to the currentDate
        NSTimer.scheduledTimerWithTimeInterval(10, target: self, selector: "updateDatePicker", userInfo: nil, repeats: true)
        NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "updateNextBatchTimeLabel", userInfo: nil, repeats: true)
        
        updateDatePicker()
        
        languageSwitch.on = appDelegate.isLanguageEnabled
        
        //Handeling connecting and disconnecting secondary screen
        var screenConnectionStatusChangedNotification = NSNotificationCenter.defaultCenter()
        screenConnectionStatusChangedNotification.addObserver(self, selector: "secondaryScreenDidConnect", name: UIScreenDidConnectNotification, object: nil)
        screenConnectionStatusChangedNotification.addObserver(self, selector: "secondaryScreenDidDisconnect", name: UIScreenDidDisconnectNotification, object: nil)
        
        //Setup of Picker
        minutePicker.dataSource = self
        minutePicker.delegate = self
        
        timeFormatter.dateFormat = "HH:mm"
        
        secondaryResolutionLabel.text = "\((UIApplication.sharedApplication().delegate as AppDelegate).secondaryResolution)"
        secondaryScreenConnectionStatusChanged()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateDatePicker() {
        var time = NSDate()
        nextBatchTimeDatePicker.minimumDate = time
        //nextBatchTimeDatePicker.maximumDate = time.dateByAddingTimeInterval(60*60*24*7)
    }

    func updateNextBatchTimeLabel() {
        if (appDelegate.isBatchTimeSet) {
            nextBatchTimeLabel.text = appDelegate.nextBatchDate.generateNextShowStringPrimary()
        }
    }

    func secondaryScreenDidConnect() {
        secondaryScreenConnectionStatusChanged()
        println("connected")
    }
    
    func secondaryScreenDidDisconnect() {
        secondaryScreenConnectionStatusChanged()
        println("disconnected")
    }
    
    func secondaryScreenConnectionStatusChanged() {
        // Tjek om disse dan skrives ind i de to ovenstående funktioner eller om der er rod hvis en 3. skærm er tilsluttet
        if (UIScreen.screens().count == 1){
            airPlayStatusLabel.text = "Slå AirPlay Skærmdublering til!"
            airPlayStatusLabel.hidden = false
            nextBatchLabel.hidden = true
            nextBatchTimeLabel.hidden = true
        }
        else {
            airPlayStatusLabel.text = ""
            airPlayStatusLabel.hidden = true
            nextBatchLabel.hidden = false
            nextBatchTimeLabel.hidden = false
        }
    }
    
    
    // IBActions
    
    @IBAction func setTimeButtonPressed(sender: AnyObject) {
        appDelegate.nextBatchDate = NextShowDate(showDate: nextBatchTimeDatePicker.date)
        appDelegate.isBatchTimeSet = true
        //reset minutepicker to 0
        nextBatchTimeLabel.text = appDelegate.nextBatchDate.generateNextShowStringPrimary()
        
        
    }
    
    @IBAction func ResetButtonPressed(sender: AnyObject) {
        appDelegate.isBatchTimeSet = false
        nextBatchTimeLabel.text = ""
        nextBatchTimeDatePicker.date = NSDate()
        //reset minutepicker to 0
    }
    
    @IBAction func languageSwitchChanged(sender: UISwitch) {
        appDelegate.isLanguageEnabled = languageSwitch.on
    }
    
    //DELEGATES AND DATASOURCES
    
        //DATASOURCES
    
        func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
            return 1
        }
    
        func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            return pickerData.count
        }
    
        //DELEGATES
    
        func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
            return String(pickerData[row])
        }

        func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
            let minutes = pickerData[row]
            nextBatchTimeDatePicker.date = NSDate().dateByAddingTimeInterval(NSTimeInterval(minutes) * 60)
        }
}

