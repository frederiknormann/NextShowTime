//
//  ViewController.swift
//  Kogeri Tid
//
//  Created by Jannie Henriksen on 06/12/14.
//  Copyright (c) 2014 Normann Development. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var nextBatchTimeDatePicker: UIDatePicker!
    
    @IBOutlet weak var nextBatchTimeLabel: UILabel!
    
    @IBOutlet weak var secondaryResolutionLabel: UILabel!
    
    let timeFormatter = NSDateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        NSTimer.scheduledTimerWithTimeInterval(30, target: self, selector: "updateDatePicker", userInfo: nil, repeats: true)
        updateDatePicker()
        
        timeFormatter.dateFormat = "HH:mm"
        
        secondaryResolutionLabel.text = "\((UIApplication.sharedApplication().delegate as AppDelegate).secondaryResolution)"
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

    @IBAction func setTimeButtonPressed(sender: AnyObject) {
        let appDelegate = (UIApplication.sharedApplication().delegate as AppDelegate)
        var nextBatchDate = nextBatchTimeDatePicker.date
        // cuts off seconds from picked date and time
        appDelegate.nextBatchDate = NextShowDate(showDate: nextBatchTimeDatePicker.date)
        appDelegate.nextBatchDate.cutSeconds()
        appDelegate.isBatchTimeSet = true
        nextBatchTimeLabel.text = appDelegate.nextBatchDate.generateNextShowStringPrimary()
    }
    
    @IBAction func ResetButtonPressed(sender: AnyObject) {
        let appDelegate = (UIApplication.sharedApplication().delegate as AppDelegate)
        appDelegate.isBatchTimeSet = false
        nextBatchTimeLabel.text = ""
    }

}

