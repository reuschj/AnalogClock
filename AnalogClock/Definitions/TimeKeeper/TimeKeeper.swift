//
//  TimeKeeper.swift
//  AnalogClock
//
//  Created by Justin Reusch on 2/5/19.
//  Copyright © 2019 Justin Reusch. All rights reserved.
//

import Foundation

/**
 A class to hold a time and date that updates itself on a regular interval
 */
public class TimeKeeper: Timed, Updatable {
    
    private var date: Date
    private let calendar: Calendar
    private var timer: Timer?
    private var dateComponents: DateComponents {
        return calendar.dateComponents([.year,.month,.day,.weekday,.hour,.minute,.second,.nanosecond], from: date)
    }
    
    public var year: Int? {
        return dateComponents.year
    }
    public var month: Int? {
        return dateComponents.month
    }
    public var monthName: String? {
        guard let month = month else { return nil }
        let index = month - 1
        guard index >= 0 && index < monthNames.count else { return nil }
        return monthNames[index]
    }
    public var shortMonthName: String? {
        guard let month = month else { return nil }
        let index = month - 1
        guard index >= 0 && index < shortMonthNames.count else { return nil }
        return shortMonthNames[index]
    }
    public var day: Int? {
        return dateComponents.day
    }
    public var weekday: Int? {
        return dateComponents.weekday
    }
    public var dayOfWeek: String? {
        guard let weekday = weekday else { return nil }
        let index = weekday - 1
        guard index >= 0 && index < weekNames.count else { return nil }
        return weekNames[index]
    }
    public var shortDayOfWeek: String? {
        guard let weekday = weekday else { return nil }
        let index = weekday - 1
        guard index >= 0 && index < shortWeekNames.count else { return nil }
        return shortWeekNames[index]
    }
    public var hour: Int? {
        return dateComponents.hour
    }
    public var hour12: Int? {
        guard let hour = dateComponents.hour else { return nil }
        if hour == 0 {
            return 12
        } else if hour <= 12 {
            return hour
        } else {
            return hour % 12
        }
    }
    public var hour12String: String? {
        guard let hour12 = hour12 else { return nil }
        return String(hour12)
    }
    public var hour24: Int? {
        return dateComponents.hour
    }
    public var hour24String: String? {
        guard let hour24 = hour24 else { return nil }
        return padTimeUnit(hour24)
    }
    public var period: Period? {
        guard let hour = dateComponents.hour else { return nil }
        return hour >= 0 && hour < 12 ? .am : .pm
    }
    public var minute: Int? {
        return dateComponents.minute
    }
    public var paddedMinute: String? {
        guard let minute = minute else { return nil }
        return padTimeUnit(minute)
    }
    public var second: Int? {
        return dateComponents.second
    }
    public var paddedSecond: String? {
        guard let second = second else { return nil }
        return padTimeUnit(second)
    }
    public var preciseSecond: Int? {
        return (dateComponents.second ?? 0) + (dateComponents.nanosecond ?? 0) / 1_000_000_000
    }
    public var paddedPreciseSecond: String? {
        guard let preciseSecond = preciseSecond else { return nil }
        return padTimeUnit(preciseSecond)
    }
    public var milliseconds: Int? {
        guard let nanosecond = nanosecond else { return nil }
        return nanosecond / 1_000_000
    }
    public var nanosecond: Int? {
        return dateComponents.nanosecond
    }
    public var tickTock: TickTock? {
        guard let second = dateComponents.second else { return nil }
        return second % 2 == 0 ? .tick : .tock
    }
    
    /// Initializer without own timer
    public init() {
        self.timer = nil
        self.date = Date()
        self.calendar = Calendar.current
    }
    
    /// Initializer with own timer
    public init(updatedEvery interval: TimeInterval = defaultTickInterval) {
        self.date = Date()
        self.calendar = Calendar.current
        self.timer = nil
        startTimer(withTimeInterval: interval)
    }
    
    /// Creates a timer
    public func startTimer(withTimeInterval interval: TimeInterval) {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true, block: { [weak self] timer in
            self?.update()
        })
    }
    
    /// Creates a timer
    public func startTimer() {
        startTimer(withTimeInterval: defaultTickInterval)
    }
    
    /// Stops the timer
    public func stopTimer() {
        timer?.invalidate()
    }
    
    /**
     Called everytime the timer fires, this refreshes the date property with the current date
     Or, can be called from an external Timer
     */
    public func update() {
        date = Date()
    }
    
}
