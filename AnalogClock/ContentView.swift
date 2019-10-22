//
//  ContentView.swift
//  AnalogClock
//
//  Created by Justin Reusch on 9/26/19.
//  Copyright © 2019 Justin Reusch. All rights reserved.
//

import SwiftUI

struct SettingsModule<Content>: View where Content: View {

    var title: String

    private var content: Content
    
    @inlinable public init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }

    var body: some View {
        VStack {
            HStack {
                Text(title).font(.subheadline)
                Spacer()
            }
            content
        }.padding()
    }
}

/**
 Base content view for the clock app
 */
struct ContentView: View {
    
    @ObservedObject var settings = getAppSettings()
    
    /// This will keep the current time, updated on a regular interval
    @State var timeEmitter = TimeEmitter(precision: getAppSettings().actualPrecision)
    
    @State private var clockType: ClockType = getAppSettings().clockType

    /// Clock dipslay state
//    @State private var selection = 2
    
    /// Display settings controls
    @State private var showSettings: Bool = false
    
    /// Show the analog clock state
    @State private var showAnalogClock: Bool = getAppSettings().visibleModules.analogClock
    
    /// Show the digital clock state
    @State private var showDigitalClock: Bool = getAppSettings().visibleModules.digitalClock
    
    /// Show the date display state
    @State private var showDateDisplay: Bool = getAppSettings().visibleModules.dateDisplay
    
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
                    AnalogClockView(timeEmitter: timeEmitter, type: clockType)
                        .padding()
                    Spacer()
                }
                if showDigitalClock {
                    DigitalClockView(timeEmitter: timeEmitter, type: clockType)
                        .padding()
                    Spacer()
                }
                if showDateDisplay {
                    DateDisplayView(timeEmitter: timeEmitter, color: .secondary).padding()
                    Spacer()
                }
            }
            if showSettings {
                
                Divider()
                
                SettingsModule(title: "Show modules") {
                    Toggle(isOn: $showAnalogClock) {
                        Text("Analog clock")
                    }
                    Toggle(isOn: $showDigitalClock) {
                        Text("Digital clock")
                    }
                    Toggle(isOn: $showDateDisplay) {
                        Text("Date display")
                    }
                }
                
                SettingsModule(title: "Clock type") {
                    Picker(
                        selection: $clockType,
                        label: Text("Show modules"),
                        content: {
                            Text("12-hour").tag(ClockType.twelveHour)
                            Text("24-hour").tag(ClockType.twentyFourHour)
                    }).pickerStyle(SegmentedPickerStyle())
                }
                
                SettingsModule(title: "Precision: \(timeEmitter.interval)") {
                    Picker(
                        selection: $timeEmitter,
                        label: Text("Precision"),
                        content: {
                            Text("Low").tag(TimeEmitter(precision: ClockPrecision.low))
                            Text("Medium").tag(TimeEmitter(precision: ClockPrecision.medium))
                            Text("High").tag(TimeEmitter(precision: ClockPrecision.high))
                            Text("Higher").tag(TimeEmitter(precision: ClockPrecision.veryHigh))
                    }).pickerStyle(SegmentedPickerStyle())
                }
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
