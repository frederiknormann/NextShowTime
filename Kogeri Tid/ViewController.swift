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
    
    @IBOutlet weak var nextBatchTimeLabel: UILabel!
    @IBOutlet weak var secondaryResolutionLabel: UILabel!
    @IBOutlet weak var airPlayStatusLabel: UILabel!
    
    let timeFormatter = NSDateFormatter()
    let pickerData = [0,2,4,6,8,10,12,15,20,25,30,35,40,45]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Timer that updates the datepicker to the currentDate
        NSTimer.scheduledTimerWithTimeInterval(30, target: self, selector: "updateDatePicker", userInfo: nil, repeats: true)
        updateDatePicker()
        
        //Handeling connecting and disconnecting secondary screen
        var screenConnectionStatusChangedNotification = NSNotificationCenter.defaultCenter()
        screenConnectionStatusChangedNotification.addObserver(self, selector: "secondaryScreenConnectionStatusChanged", name: UIScreenDidConnectNotification, object: nil)
        screenConnectionStatusChangedNotification.addObserver(self, selector: "secondaryScreenConnectionStatusChanged", name: UIScreenDidDisconnectNotification, object: nil)
        
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

    func secondaryScreenDidConnect() {
        secondaryScreenConnectionStatusChanged()
        println("connected")
    }
    
    func secondaryScreenDidDisconnect() {
        secondaryScreenConnectionStatusChanged()
        println("disconnected")
    }
    
    func secondaryScreenConnectionStatusChanged() {
        if (UIScreen.screens().count == 1){
            airPlayStatusLabel.text = "Slå AirPlay Skærmdublering til!"
            airPlayStatusLabel.hidden = false
        }
        else {
            airPlayStatusLabel.text = ""
            airPlayStatusLabel.hidden = true
        }
    }
    
    @IBAction func setTimeButtonPressed(sender: AnyObject) {
        let appDelegate = (UIApplication.sharedApplication().delegate as AppDelegate)
        appDelegate.nextBatchDate = NextShowDate(showDate: nextBatchTimeDatePicker.date)
        appDelegate.isBatchTimeSet = true
        //reset minutepicker to 0
        nextBatchTimeLabel.text = appDelegate.nextBatchDate.generateNextShowStringPrimary()
    }
    
    @IBAction func ResetButtonPressed(sender: AnyObject) {
        let appDelegate = (UIApplication.sharedApplication().delegate as AppDelegate)
        appDelegate.isBatchTimeSet = false
        nextBatchTimeLabel.text = ""
        nextBatchTimeDatePicker.date = NSDate()
        //reset minutepicker to 0
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

