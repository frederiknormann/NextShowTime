//
//  NextShowDate.swift
//  Kogeri Tid
//
//  Created by Frederik Normann on 14/12/14.
//  Copyright (c) 2014 Normann Development. All rights reserved.
//

import Foundation

class NextShowDate {
    
    
    //CURRENT DATE
    var currentDate : NSDate {
        get{ return NSDate() }
    }
    
    var currentWeekday : Int {
        get{ return NSCalendar.currentCalendar().components(NSCalendarUnit.WeekdayCalendarUnit, fromDate: currentDate).weekday }
    }
    var currentWeekOfYear : Int {
        get{ return NSCalendar.currentCalendar().components(NSCalendarUnit.WeekOfYearCalendarUnit, fromDate: currentDate).weekOfYear }
    }
    var currentYear : Int {
        get{ return NSCalendar.currentCalendar().components(NSCalendarUnit.YearForWeekOfYearCalendarUnit, fromDate: currentDate).yearForWeekOfYear }
    }
    
    //SHOWDATE
    var showDate : NSDate = NSDate(timeIntervalSince1970: 0) {
        didSet{
            //Cuts off seconds from new date
            self.showDate = NSDate(timeIntervalSince1970: NSTimeInterval(Int(showDate.timeIntervalSince1970 / 60) * 60))
        }
    }
    
    var weekday : Int {
        get{ return NSCalendar.currentCalendar().components(NSCalendarUnit.CalendarUnitWeekday, fromDate: self.showDate).weekday}
    }
    var weekOfYear : Int {
        get{ return NSCalendar.currentCalendar().components(NSCalendarUnit.WeekOfYearCalendarUnit, fromDate: self.showDate).weekOfYear }
    }
    var year : Int {
        get { return NSCalendar.currentCalendar().components(NSCalendarUnit.YearForWeekOfYearCalendarUnit, fromDate: self.showDate).yearForWeekOfYear }
    }
    
    var timeLeftSec : Int {
        get { return Int(showDate.timeIntervalSinceDate(currentDate)) }
    }
    
    // SPLIT TIME LEFT
    var actualDays : Int  { get{ return Int(timeLeftSec / (60*60*24)) } }
    var days : Int { //number of midnights until next show
        get{
            if (weekOfYear >= currentWeekOfYear || year > currentYear) { //checks for negative timeleft
                if (weekOfYear == currentWeekOfYear && weekday > currentWeekday) { //same week
                    return weekday - currentWeekday
                }
                else {
                    if (self.year == currentYear) { //same year
                        return currentWeekday + (7 * (weekOfYear-currentWeekOfYear)) - weekday
                    }
                    else { //show happens in one of the comming years
                    //following calculation is highly unprecise!! But it works for the purpose intended to show 1day for tommorrow and more if its futher along // viser ikke 1 dag ved års skifte (overgangen fra uge 52 til 1)
                    return currentWeekday + (7 * (weekOfYear + (52 * (self.year - currentYear)) - currentWeekOfYear)) - weekday
                    }
                }
            }
            else {return actualDays} //Show allready happened
        }
    }
    var hours : Int       { get{ return Int(timeLeftSec / (60*60) % 24) } }
    var minutes : Int     { get{ return Int(timeLeftSec / 60 % 60) } }
        var seconds : Int { get{ return Int(timeLeftSec % 60) } }
    
    
    //minimis interval where time left doesn't show
    var minimis = 30 //sec
    var timeBeforeDismissingShowtime = 5  //min
    
    var timeFormatter = NSDateFormatter()
    let timeFormat = "HH:mm"
    
   // let weekdayNames : [String] = [da:"Søndag" en:"Sunday" de:"Sontag", da:"" en:"" de:""]
    var weekdayString : String {  //ex. "Onsdag"
        get{
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
    }
        
    var nextShowTimeString = "" //ex. "14:10"
    
    var language = "da"
    
    init(showDate: NSDate) {
        self.showDate = showDate
        //self.weekdayString = weekDayString(self.weekday)
        self.timeFormatter.dateFormat = self.timeFormat
        self.nextShowTimeString = self.timeFormatter.stringFromDate(self.showDate)
    }
    
    func nextLanguage() {
        if (language == "da") {language = "de"}
        else {language = "da"}
    }
    
    func generateNextShowStringPrimary() -> String {
        
        //self.updateCurrentDayVariables()
        var nextBatchTimeString: String = ""
            //println(days)
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

//    skal laves så tekster trækkes fra array med oversættelser, meget kortere... eller implementeres med en form for sprog implementering
    func generateNextShowStringSecondary() -> String {
        var nextBatchTimeString: String = ""
        
        if (timeLeftSec > self.minimis) {
            
            if (days > 0) { //Der er en bug ligeomkring skiftet fra uge 51/52 til uge 1 hvor ugedag vises istedet for imorgen
                if (days==1) {
                    if (language == "da"){
                        nextBatchTimeString = "Vi starter igen imorgen kl. \(self.nextShowTimeString)"
                    }
                    else if (language == "de") {
                        nextBatchTimeString = "Wir fangen an morgens am \(self.nextShowTimeString)"
                    }
                    else if (language == "en") {
                        nextBatchTimeString = "We start again tomorrow at \(self.nextShowTimeString)"
                    }
                }
                else {
                    if (language == "da"){
                        nextBatchTimeString = "Næste Portion: \(weekdayString) \(self.nextShowTimeString)"
                    }
                    else if (language == "de") {
                        nextBatchTimeString = "Nächste Mal: \(weekdayString) \(self.nextShowTimeString)"
                    }
                    else if (language == "en") {
                        nextBatchTimeString = "Next Batch: \(weekdayString) \(self.nextShowTimeString)"
                    }
//                    else {
//                        nextBatchTimeString = "Næste Portion: \(weekdayString) \(self.nextShowTimeString)"
//                    }
                    
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
                
                if (language == "da"){
                    nextBatchTimeString = "Næste Portion: \(self.nextShowTimeString) (om ca. \(timeLeftString))"
                }
                else if (language == "de") {
                    nextBatchTimeString = "Nächste Mal: \(self.nextShowTimeString) (von ca. \(timeLeftString))"
                }
                else if (language == "en") {
                    nextBatchTimeString = "Next Batch: \(self.nextShowTimeString) (in about \(timeLeftString))"
                }
                
                //nextBatchTimeString = "Næste Portion: \(self.nextShowTimeString) (om ca. \(timeLeftString))"
            }
            
        }
        else if (minutes >= -timeBeforeDismissingShowtime && minutes <= minimis) {
        
            if (language == "da"){
                nextBatchTimeString = "Vi starter lige om lidt"
            }
            else if (language == "de") {
                nextBatchTimeString = "Wir fangen an bald"
            }
            else if (language == "en") {
                nextBatchTimeString = "We will be starting shortly"
            }
            
            //nextBatchTimeString = "Vi starter lige om lidt"
        }
        else {
            nextBatchTimeString = ""
        }
        return nextBatchTimeString
    }
    
    
}