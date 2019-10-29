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
        calendar.dateComponents([.year,.month,.day,.weekday,.hour,.minute,.second,.nanosecond], from: date)
    }

    public var year: Int? { dateComponents.year }
    public var month: Int? { dateComponents.month }
    public var monthName: String? {
        guard let month = month else { return nil }
        let index = month - 1
        guard index >= 0 && index < calendar.monthSymbols.count else { return nil }
        return calendar.monthSymbols[index].capitalized
    }
    public var shortMonthName: String? {
        guard let month = month else { return nil }
        let index = month - 1
        guard index >= 0 && index < calendar.shortMonthSymbols.count else { return nil }
        return calendar.shortMonthSymbols[index].capitalized
    }
    public var day: Int? { dateComponents.day }
    public var weekday: Int? { dateComponents.weekday }
    public var dayOfWeek: String? {
        guard let weekday = weekday else { return nil }
        let index = weekday - 1
        guard index >= 0 && index < calendar.weekdaySymbols.count else { return nil }
        return calendar.weekdaySymbols[index].capitalized
    }
    public var shortDayOfWeek: String? {
        guard let weekday = weekday else { return nil }
        let index = weekday - 1
        guard index >= 0 && index < calendar.shortWeekdaySymbols.count else { return nil }
        return calendar.shortWeekdaySymbols[index].capitalized
    }
    public var dateString: String? {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        let day = dayOfWeek ?? ""
        return "\(day)\(day.isEmpty ? "" : ", ")\(formatter.string(from: date))"
    }
    public var hour: Int? { dateComponents.hour }
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
    public var hour24: Int? { dateComponents.hour }
    public var hour24String: String? {
        guard let hour24 = hour24 else { return nil }
        return padTimeUnit(hour24)
    }
    public var period: Period? {
        guard let hour = dateComponents.hour else { return nil }
        return hour >= 0 && hour < 12 ? .am : .pm
    }
    public var periodString: String? {
        guard let period = period else { return nil }
        return period == .am ? calendar.amSymbol : calendar.pmSymbol
    }
    public var minute: Int? { dateComponents.minute }
    public var paddedMinute: String? {
        guard let minute = minute else { return nil }
        return padTimeUnit(minute)
    }
    public var second: Int? { dateComponents.second }
    public var paddedSecond: String? {
        guard let second = second else { return nil }
        return padTimeUnit(second)
    }
    public var preciseSecond: Int? {
        (dateComponents.second ?? 0) + (dateComponents.nanosecond ?? 0) / 1_000_000_000
    }
    public var paddedPreciseSecond: String? {
        guard let preciseSecond = preciseSecond else { return nil }
        return padTimeUnit(preciseSecond)
    }
    public var milliseconds: Int? {
        guard let nanosecond = nanosecond else { return nil }
        return nanosecond / 1_000_000
    }
    public var nanosecond: Int? { dateComponents.nanosecond }
    public var tickTock: TickTock? {
        guard let second = dateComponents.second else { return nil }
        return second % 2 == 0 ? .tick : .tock
    }
    
    /// Initializer without own timer
    public init() {
        timer = nil
        date = Date()
        calendar = Calendar.current
    }
    
    /// Initializer with own timer
    public init(updatedEvery interval: TimeInterval = defaultTickInterval) {
        date = Date()
        calendar = Calendar.current
        timer = nil
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
