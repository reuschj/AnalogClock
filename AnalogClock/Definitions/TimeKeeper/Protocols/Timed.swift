//
//  Timed.swift
//  AnalogClock
//
//  Created by Justin Reusch on 2/27/19.
//  Copyright © 2019 Justin Reusch. All rights reserved.
//

import Foundation

/**
 A protocol for an object with a timer
 */
public protocol Timed {
    
    /// Starts the time with some default interval
    func startTimer() -> Void
    
    /// Starts the time with specified interval
    func startTimer(withTimeInterval interval: TimeInterval) -> Void
    
    /// Updates the interval
    func updateTimerInterval(to interval: TimeInterval) -> Void
    
    /// Stops the timer
    func stopTimer() -> Void
}

public extension Timed {
    
    /// Default implementation for update interval
    func updateTimerInterval(to interval: TimeInterval) -> Void {
        startTimer(withTimeInterval: interval)
    }
}
