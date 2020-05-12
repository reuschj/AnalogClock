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
    
    /// Clock type (12-hour, 24-hour or decimal)
    public var clockType: ClockType = .twelveHour {
        didSet { updateTimerInterval(to: interval) }
    }
    
    /// The time interval on which to emit the current time and hand rotations
    public var interval: TimeInterval {
        get { precision.getUpdateInterval(for: clockType) }
        set { precision = ClockPrecision.getPrecision(from: newValue) }
    }
    
    /// Clock precision setting from low to very high (or custom)
    var precision: ClockPrecision = .low {
        didSet { updateTimerInterval(to: interval) }
    }
    
    /// A timer that will drive the updates
    public var timer: Timer!
    
    /**
     An initializer specifying a clock precision enum value instead of interval
     - Parameter precision: The precision at which the emitter will update the current time and date
     - Parameter rotationOutput: The desired rotation output unit, degrees or radians
     - Parameter clockType: Clock type (12-hour, 24-hour or decimal)
     */
    init(precision: ClockPrecision = .low, rotationOutput: RotationUnit = .degrees, clockType: ClockType = .twelveHour) {
        self.timer = nil
        self.clockType = clockType
        self.precision = precision
        self.time = TimeKeeper()
        self.clockHand = ClockHandController(using: time, output: rotationOutput)
        self.startTimer()
    }

    /**
     Initializer specifying the interval directly
     - Parameter interval: The interval which the emitter will update the current time and date
     - Parameter rotationOutput: The desired rotation output unit, degrees or radians
     - Parameter clockType: Clock type (12-hour, 24-hour or decimal)
     */
    convenience init(updatedEvery interval: TimeInterval = defaultTickInterval, rotationOutput: RotationUnit = .degrees, clockType: ClockType = .twelveHour) {
        self.init(precision: ClockPrecision.getPrecision(from: interval), rotationOutput: rotationOutput, clockType: clockType)
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
