//
//  TimeEmitter.swift
//  AnalogClock
//
//  Created by Justin Reusch on 9/30/19.
//  Copyright © 2019 Justin Reusch. All rights reserved.
//

import SwiftUI
import Combine

class TimeEmitter: ObservableObject, Updatable {
    
    @Published var time: TimeKeeper
    @Published var handController: ClockHandController!
    
    var interval: TimeInterval
    private var timer: Timer!
        
    init(updatedEvery interval: TimeInterval = defaultTickInterval, rotationOutput: RotationUnit = .degrees) {
        self.interval = interval
        time = TimeKeeper(updatedEvery: interval, withOwnTimer: false)
        handController = nil
        handController = ClockHandController(using: time, output: rotationOutput)
        start()
    }
    
    func start() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { [weak self] timer in
            self?.update()
        }
    }
    
    func stop() {
        timer?.invalidate()
    }
    
    func update() {
        time.update()
        objectWillChange.send()
    }
}
