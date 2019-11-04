//
//  ClockTimeEmitter.swift
//  AnalogClock
//
//  Created by Justin Reusch on 11/2/19.
//  Copyright © 2019 Justin Reusch. All rights reserved.
//

import Foundation
import TimeKeeper

/**
 Emits the current time and clock hand rotation at the specified time interval
 */
class ClockTimeEmitter: IntervalEmitter {
    
    /// The current time to emit with accessors to all time components
    @Published public var time: TimeKeeper
    
    /// Outputs hand rotation to emit in degrees or radians
    @Published var clockHand: ClockHandController!
    
    /// The time interval on which to emit the current time and hand rotations
    public var interval: TimeInterval {
        didSet { updateTimerInterval(to: interval) }
    }
    
    /// Computed getter/setter for clock precision
    var precision: ClockPrecision? {
        get { ClockPrecision.getPrecision(from: interval) }
        set {
            if let newValue = newValue {
                interval = newValue.rawValue
            }
        }
    }
    
    /// A timer that will drive the updates
    public var timer: Timer!

    /**
     Initializer specifying the interval directly
     - Parameters:
         - interval: The interval which the emitter will update the current time and date
         - rotationOutput: The desired rotation output unit, degrees or radians
     */
    init(updatedEvery interval: TimeInterval = defaultTickInterval, rotationOutput: RotationUnit = .degrees) {
        self.timer = nil
        self.interval = interval
        self.time = TimeKeeper()
        self.clockHand = ClockHandController(using: time, output: rotationOutput)
        self.startTimer()
    }
    
    /**
     An initializer specifying a clock precision enum value instead of interval
     - Parameters:
         - precision: The precision at which the emitter will update the current time and date
         - rotationOutput: The desired rotation output unit, degrees or radians
     */
    convenience init(precision: ClockPrecision = .low, rotationOutput: RotationUnit = .degrees) {
        self.init(updatedEvery: precision.rawValue, rotationOutput: rotationOutput)
    }
    
    /// Updates the time and emits
    public func update() {
        time.update()
        objectWillChange.send()
    }
    
    /// Equatable method
    public static func == (lhs: ClockTimeEmitter, rhs: ClockTimeEmitter) -> Bool {
        lhs.interval == rhs.interval
    }
}
