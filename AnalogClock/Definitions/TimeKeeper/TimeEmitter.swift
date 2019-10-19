//
//  TimeEmitter.swift
//  AnalogClock
//
//  Created by Justin Reusch on 9/30/19.
//  Copyright © 2019 Justin Reusch. All rights reserved.
//

import SwiftUI
import Combine

class TimeEmitter: ObservableObject, Timed, Updatable, Hashable {
    
    @Published var time: TimeKeeper
    @Published var handController: ClockHandController!
        
    var interval: TimeInterval {
        didSet {
            updateTimerInterval(to: interval)
        }
    }
    private var timer: Timer!
        
    init(updatedEvery interval: TimeInterval = defaultTickInterval, rotationOutput: RotationUnit = .degrees) {
        self.interval = interval
        time = TimeKeeper()
        handController = nil
        handController = ClockHandController(using: time, output: rotationOutput)
        startTimer()
    }
    
    func startTimer(withTimeInterval interval: TimeInterval) {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { [weak self] timer in
            self?.update()
        }
    }
    
    func startTimer() {
        startTimer(withTimeInterval: interval)
    }
    
    func updateTimerInterval(to interval: TimeInterval) {
        startTimer(withTimeInterval: interval)
    }
    
    func stopTimer() {
        timer?.invalidate()
    }
    
    func update() {
        time.update()
        objectWillChange.send()
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(interval)
    }
    
    static func == (lhs: TimeEmitter, rhs: TimeEmitter) -> Bool {
        lhs.interval == rhs.interval
    }
}
