//
//  SecondaryViewController.swift
//  Kogeri Tid
//
//  Created by Jannie Henriksen on 06/12/14.
//  Copyright (c) 2014 Normann Development. All rights reserved.
//

import UIKit

class SecondaryViewController : UIViewController {
    
    var mirroredScreenResolution : CGRect = CGRect(x: 0, y: 0, width: 0, height: 0)
    
    // Constants
    var kHalf : CGFloat = 1.0/2.0
    
    // UI Elements
    
    var clockBackground : UIView!
    
    // Labels
    var topLabelLeft : UILabel!
    var topLavelRight : UILabel!
    var currentTimeLabel : UILabel!
    var nextBatchLabel : UILabel!
    var nextBatchTimeLabel : UILabel!
    var timeLeftLabel : UILabel!
    
    // Images
    var backgroundImageView : UIImageView!
        //    var splitBackgroundImageViewLeft : UIImageView!
        //    var splitBackgroundImageViewRight : UIImageView!
    
    //SlideShow
    var slideArray : [UIImage] = []
    var slideNumber : Int = 0
   
    var languageTimeInterval: NSTimeInterval = 10 //sec
    var languageTimeCounter : NSTimeInterval = 0
    var slideTimeInterval : NSTimeInterval = 6 //sec
    
    // Font
    var bolcherietFontString = "Helvetica" //"AppleSDGothicNeo-Bold" //ArialMT
    
    
    // Time
    let timeFormatter = NSDateFormatter()
    
    // DATA
    let appDelegate = (UIApplication.sharedApplication().delegate as AppDelegate)
    
    //Temp
    var iArray : [Int] = []
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        println("viewFrame \(self.view.frame)")
        println(self.view.bounds)
        println(UIScreen.screens()[1].frame) //nil
        println(UIScreen.screens()[1].bounds)

        self.view.frame = UIScreen.screens()[1].bounds //mirroredScreenResolution
        
        timeFormatter.dateFormat = "HH:mm"
        
        for var i=1 ; i < 32 ; i++ {
            var numberString = ""
            if (i < 10){
                numberString = "0\(String(i))"
            }
            else {
                numberString = "\(String(i))"
            }
            let filename = "SlidePic\(numberString).JPG"
            let image = UIImage(named: filename)
            self.iArray.append(i)
            self.slideArray.append(image!)
        }

        
        // Clock and timeLeft Timer
        NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "updateClock", userInfo: nil, repeats: true)
        
        // SlideShow Timer
        NSTimer.scheduledTimerWithTimeInterval(slideTimeInterval, target: self, selector: "nextSlide", userInfo: nil, repeats: true)
        
        var mirroredView : UIView = setupViewContainer()
        self.view.addSubview(mirroredView)
        self.view.backgroundColor = UIColor.blackColor()
        
        //TEST
        appDelegate.secondaryResolution = UIScreen.screens()[1].bounds
        
        println("viewFrame \(self.view.frame)")
        print(self.view.bounds)
        println(UIScreen.screens()[1].frame) //nil
        println(UIScreen.screens()[1].bounds)
        
    }
    
    func updateClock() {
        let date = NSDate()
        self.currentTimeLabel.text = "\(timeFormatter.stringFromDate(date))"
        self.currentTimeLabel.hidden = false
        
        updateNextBatchTimeLabel()
    }
    
    
    // Updates the time of the next batch by getting it from the var in AppDelegate, which is updatet in ViewController which runs on the device
    
    func updateNextBatchTimeLabel() {
        
        if (appDelegate.isBatchTimeSet) {
            if appDelegate.isLanguageEnabled {
                if (languageTimeCounter < languageTimeInterval) {languageTimeCounter +=  1}
                else {
                    appDelegate.nextBatchDate.nextLanguage()
                    languageTimeCounter = 0
                }
            }
            //else {appDelegate.nextBatchDate.language = "da"} // irrelevant, is set in class
            
            self.nextBatchLabel.text = appDelegate.nextBatchDate.generateNextShowStringSecondary()
            self.nextBatchLabel.sizeToFit()
            self.nextBatchLabel.hidden = false
        }
        else {
            self.nextBatchLabel.hidden = true
            self.languageTimeCounter = 0
        }
    }
    
    // Rolls the slidecounter and updates the imageView
    
    func nextSlide() {
        if (self.slideNumber == (self.slideArray.count - 1)) {
            self.slideNumber = 0
        }
        else {
            self.slideNumber += 1
        }
        backgroundImageView.image = self.slideArray[self.slideNumber]
    }
    
    func setupViewContainer() -> UIView {
        var container : UIView = UIView(frame: self.view.bounds)
        container.backgroundColor = UIColor.blackColor()
        var textColor : UIColor = UIColor.whiteColor()
        var backgroundColor = UIColor.blackColor()
        var alpha : CGFloat = 1.0 //0.5

        self.backgroundImageView = UIImageView(image: self.slideArray[0])
        self.backgroundImageView.frame = CGRect(x: 0, y: 0, width: container.bounds.width, height: container.bounds.height)
        self.backgroundImageView.contentMode = UIViewContentMode.ScaleAspectFit
        container.addSubview(self.backgroundImageView)
        
        self.clockBackground = UIView()
        self.clockBackground.backgroundColor = UIColor.grayColor()
        self.clockBackground.alpha = 0.5
        self.clockBackground.frame = CGRect(x: 0, y: container.frame.height - 51 , width: container.frame.width, height: 51)
        container.addSubview(self.clockBackground)
        
        self.topLabelLeft = UILabel()
        self.topLabelLeft.text = "Instagram: @bolchemanden @bolchefruen @bolchekogeren"
        self.topLabelLeft.font = UIFont(name: bolcherietFontString, size: 22)
        self.topLabelLeft.textColor = textColor
        self.topLabelLeft.backgroundColor = backgroundColor 
        self.topLabelLeft.alpha = 0.4
        self.topLabelLeft.sizeToFit()
        self.topLabelLeft.frame = CGRect(x: 0, y: 0, width: container.frame.width, height: self.topLabelLeft.frame.height)
        self.topLabelLeft.hidden = true
        container.addSubview(self.topLabelLeft)
        
        self.currentTimeLabel = UILabel()
        self.currentTimeLabel.text = "00:00"
        self.currentTimeLabel.font = UIFont(name: bolcherietFontString, size: 44)
        self.currentTimeLabel.textColor = textColor
        self.currentTimeLabel.textAlignment = NSTextAlignment.Right
        self.currentTimeLabel.sizeToFit()
        self.currentTimeLabel.frame.origin.x = container.bounds.width - self.currentTimeLabel.frame.width
        self.currentTimeLabel.frame.origin.y = container.bounds.height - self.currentTimeLabel.frame.height
        self.currentTimeLabel.hidden = true
        container.addSubview(self.currentTimeLabel)
        
        println(self.currentTimeLabel.frame.height)
        self.nextBatchLabel = UILabel()
        self.nextBatchLabel.text = ""
        self.nextBatchLabel.font = UIFont(name: bolcherietFontString, size: 36)
        self.nextBatchLabel.textColor = textColor
        //self.nextBatchLabel.backgroundColor = backgroundColor
        self.nextBatchLabel.alpha = alpha
        self.nextBatchLabel.frame.origin = CGPoint(x: 0, y: self.currentTimeLabel.frame.origin.y)
        self.nextBatchLabel.hidden = true
        container.addSubview(self.nextBatchLabel)
        
        return container
    }
}