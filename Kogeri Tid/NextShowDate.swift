//
//  NextShowDate.swift
//  Kogeri Tid
//
//  Created by Frederik Normann on 14/12/14.
//  Copyright (c) 2014 Normann Development. All rights reserved.
//

import Foundation

class NextShowDate {
    
    //date and time of the next show
    var date : NSDate = NSDate(timeIntervalSince1970: 0)
    var weekday = 0
    var weekOfYear = 0
    var year = 0
    
    var currentWeekday = 0
    var currentWeekOfYear = 0
    var currentYear = 0
    
    var timeLeftSec = 0
    var actualDays = 0
    var days = 0
    var hours = 0
    var minutes = 0
    var seconds = 0
    
    //minimis interval where time left doesn't show
    var minimis = 30
    
    var timeFormatter = NSDateFormatter()
    let timeFormat = "HH:mm"
    
    var weekdayString = ""  //ex. "Onsdag"
    var nextShowTimeString = "" //ex. "14:10"
    
    
    init(showDate: NSDate) {
        self.date = showDate
        cutSeconds()
        self.weekday = NSCalendar.currentCalendar().components(NSCalendarUnit.CalendarUnitWeekday, fromDate: self.date).weekday
        self.weekOfYear = NSCalendar.currentCalendar().components(NSCalendarUnit.WeekOfYearCalendarUnit, fromDate: self.date).weekOfYear
        self.year = NSCalendar.currentCalendar().components(NSCalendarUnit.YearForWeekOfYearCalendarUnit, fromDate: self.date).yearForWeekOfYear
        self.weekdayString = weekDayString(self.weekday)
        self.timeFormatter.dateFormat = self.timeFormat
        self.nextShowTimeString = self.timeFormatter.stringFromDate(self.date)
        
        updateCurrentDayVariables()
    }
    
    
    func updateCurrentDayVariables() {
        let currentDate = NSDate()
        self.currentWeekday = NSCalendar.currentCalendar().components(NSCalendarUnit.WeekdayCalendarUnit, fromDate: currentDate).weekday
        self.currentWeekOfYear = NSCalendar.currentCalendar().components(NSCalendarUnit.WeekOfYearCalendarUnit, fromDate: currentDate).weekOfYear
        self.currentYear = NSCalendar.currentCalendar().components(NSCalendarUnit.YearForWeekOfYearCalendarUnit, fromDate: currentDate).yearForWeekOfYear
        
        timeLeftSec = Int(date.timeIntervalSinceDate(currentDate))
        println("\(timeLeftSec)tl  \(weekday)w \(currentWeekday)cw \(weekOfYear)wy \(currentWeekOfYear)cwy \(year)y \(currentYear)cy \(weekdayString)")
        
        self.actualDays = Int(timeLeftSec / (60*60*24))
        self.hours = Int(timeLeftSec / (60*60) % 24)
        self.minutes = Int(timeLeftSec / 60 % 60)
        self.seconds = Int(timeLeftSec % 60)
        
        if (weekOfYear >= currentWeekOfYear || year > currentYear) {
            if (weekOfYear == currentWeekOfYear && weekday > currentWeekday) {
                days = weekday - currentWeekday
            }
            else {
                if (self.year == currentYear) {
                    days = currentWeekday + (7 * (weekOfYear-currentWeekOfYear)) - weekday
                }
                else {
                    //following calculation is highly unprecise!! But it works for the purpose intended to show 1day for tommorrow and more if its futher along
                    days = currentWeekday + (7 * (weekOfYear + (52 * (self.year - currentYear)) - currentWeekOfYear)) - weekday
                }
            }
        }
        println("\(timeLeftSec)tl \(actualDays)ad \(days)d \(hours)t \(minutes)min \(seconds)s")
        
    }
    
    // cuts off seconds from picked date and time
    func cutSeconds(){
        date = NSDate(timeIntervalSince1970: NSTimeInterval(Int(date.timeIntervalSince1970 / 60) * 60))
    }
    
    func weekDayString(weekday : Int) -> String {
        var weekDayString = ""
        switch (weekday) {
            case 1: weekDayString = "Søndag"
            case 2: weekDayString = "Mandag"
            case 3: weekDayString = "Tirsdag"
            case 4: weekDayString = "Onsdag"
            case 5: weekDayString = "Torsdag"
            case 6: weekDayString = "Fredag"
            case 7: weekDayString = "Lørdag"
            default: weekDayString = ""
        }
        return weekDayString
    }
    
    func generateNextShowStringPrimary() -> String {
        
        self.updateCurrentDayVariables()
        var nextBatchTimeString: String = ""
            println(days)
            if (self.days > 0) {
                if (days==1) {
                    nextBatchTimeString = "Imorgen \(self.nextShowTimeString)"
                }
                else {
                    nextBatchTimeString = "\(self.weekdayString) \(self.nextShowTimeString)"
                }
            }
            else {
                var timeLeftString = ""
                if (hours > 0) {
                    //if (minutes
                    timeLeftString = "\(hours)t \(minutes + 1)min"
                }
                else {
                    timeLeftString = "\(minutes + 1)min"
                }
                nextBatchTimeString = "\(self.nextShowTimeString) (\(timeLeftString))"
            }
         
        return nextBatchTimeString
    }

    
    func generateNextShowStringSecondary() -> String {
        
        self.updateCurrentDayVariables()
        
        var nextBatchTimeString: String = ""
        
        if (timeLeftSec > self.minimis) {
            
            if (days > 0) {
                if (days==1) {
                    nextBatchTimeString = "Vi starter igen imorgen kl. \(self.nextShowTimeString)"
                }
                else {
                    nextBatchTimeString = "Næste Portion: \(weekdayString) \(self.nextShowTimeString)"
                }
            }
            else {
                var timeLeftString = ""
                if (hours > 0) {
                    //if (minutes
                    timeLeftString = "\(hours)t \(minutes + 1)min"
                }
                else {
                    timeLeftString = "\(minutes + 1)min"
                }
                nextBatchTimeString = "Næste Portion: \(self.nextShowTimeString) (om ca. \(timeLeftString))"
            }
            
        }
        else {
            nextBatchTimeString = "Vi starter lige om lidt"
        }
        return nextBatchTimeString
    }
    
    
}