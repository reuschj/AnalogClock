//
//  ContentView.swift
//  AnalogClock
//
//  Created by Justin Reusch on 9/26/19.
//  Copyright © 2019 Justin Reusch. All rights reserved.
//

import SwiftUI

/**
 Base content view for the clock app
 */
struct ContentView: View {
    
    @ObservedObject var settings = getAppSettings()
    
    /// This will keep the current time, updated on a regular interval
    @State var timeEmitter = TimeEmitter(precision: getAppSettings().actualPrecision)
    
    @State private var clockType: ClockType = getAppSettings().clockType {
        didSet { getAppSettings().clockType = self.clockType }
    }

    /// Clock dipslay state
    @State private var selection = 2
    
    /// Display settings controls
    @State private var showSettings: Bool = false
    
    /// Getter for analog clock display flag
    private var showAnalogClock: Bool { selection == 0 || selection == 2 }
    /// Getter for digital clock display flag
    private var showDigitalClock: Bool { selection == 1 || selection == 2 }
    
    var body: some View {
        VStack {
            
            HStack {
                Spacer()
                Button(action: { self.showSettings = !self.showSettings }) {
                    Text(self.showSettings ? "Hide Settings" : "Show Settings")
                }.padding()
            }
            
            VStack {
                Spacer()
                if showAnalogClock {
                    AnalogClock(timeEmitter: timeEmitter, type: clockType)
                        .padding()
                    Spacer()
                }
                if showDigitalClock {
                    DigitalClock(timeEmitter: timeEmitter, type: clockType)
                        .padding()
                    Spacer()
                }
                DateDisplay(timeEmitter: timeEmitter).padding()
                Spacer()
            }
            if showSettings {
                
                Divider()
                
                HStack {
                    Text("Settings").font(.title)
                    Spacer()
                }.padding()
                Spacer()
                VStack {
                    HStack {
                        Text("Show clocks").font(.subheadline)
                        Spacer()
                    }
                    Picker(
                        selection: $selection,
                        label: Text("Show modules"),
                        content: {
                            Text("Analog").tag(0)
                            Text("Digital").tag(1)
                            Text("Both").tag(2)
                    }).pickerStyle(SegmentedPickerStyle())
                }.padding()
                Spacer()
                VStack {
                    HStack {
                        Text("Clock type").font(.subheadline)
                        Spacer()
                    }
                    Picker(
                        selection: $clockType,
                        label: Text("Show modules"),
                        content: {
                            Text("12-hour").tag(ClockType.twelveHour)
                            Text("24-hour").tag(ClockType.twentyFourHour)
                    }).pickerStyle(SegmentedPickerStyle())
                }.padding()
                Spacer()
                VStack {
                    HStack {
                        Text("Precision").font(.subheadline)
                        Spacer()
                        Text("\(round(timeEmitter.interval * 1_000) / 1_000)").font(.subheadline)
                    }
                    Picker(
                        selection: $timeEmitter,
                        label: Text("Precision"),
                        content: {
                            Text("Low").tag(TimeEmitter(precision: ClockPrecision.low))
                            Text("Medium").tag(TimeEmitter(precision: ClockPrecision.medium))
                            Text("High").tag(TimeEmitter(precision: ClockPrecision.high))
                            Text("Higher").tag(TimeEmitter(precision: ClockPrecision.veryHigh))
                    }).pickerStyle(SegmentedPickerStyle())
                }.padding()
                Spacer()
            }
            Spacer()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
