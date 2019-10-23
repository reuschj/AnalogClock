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
    
    /// Display settings controls
    @State private var showSettings: Bool = false
    
    /// This will keep the current time, updated on a regular interval
    @ObservedObject var timeEmitter = getTimeEmitter()
    
    private var clockType = Binding<ClockType>(
        get: { getAppSettings().clockType },
        set: { getAppSettings().clockType = $0 }
    )
    
    private var clockPrecision = Binding<ClockPrecision>(
        get: { getAppSettings().actualPrecision },
        set: {
            getAppSettings().actualPrecision = $0
            getTimeEmitter().precision = $0
        }
    )
    
    /// Show the analog clock state
    private var showAnalogClock = Binding<Bool>(
        get: { getAppSettings().visibleModules.analogClock },
        set: { getAppSettings().visibleModules.analogClock = $0 }
    )
    
    /// Show the digital clock state
    private var showDigitalClock = Binding<Bool>(
        get: { getAppSettings().visibleModules.digitalClock },
        set: { getAppSettings().visibleModules.digitalClock = $0 }
    )
    
    /// Show the date display state
    private var showDateDisplay = Binding<Bool>(
        get: { getAppSettings().visibleModules.dateDisplay },
        set: { getAppSettings().visibleModules.dateDisplay = $0 }
    )
    
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
                if settings.visibleModules.analogClock {
                    AnalogClockView(timeEmitter: timeEmitter, type: settings.clockType)
                        .padding()
                    Spacer()
                }
                if settings.visibleModules.digitalClock {
                    DigitalClockView(timeEmitter: timeEmitter, type: settings.clockType)
                        .padding()
                    Spacer()
                }
                if settings.visibleModules.dateDisplay {
                    DateDisplayView(timeEmitter: timeEmitter, color: .secondary).padding()
                    Spacer()
                }
            }
            if showSettings {
                
                Divider()
                
                HStack {
                    Text("Setttings").font(.title).padding()
                    Spacer()
                }
                
                SettingsModule(title: "Show modules") {
                    Toggle(isOn: showAnalogClock) {
                        Text("Analog clock")
                    }
                    Toggle(isOn: showDigitalClock) {
                        Text("Digital clock")
                    }
                    Toggle(isOn: showDateDisplay) {
                        Text("Date display")
                    }
                }
                
                SettingsModule(title: "Clock type") {
                    Picker(
                        selection: clockType,
                        label: Text("Show modules"),
                        content: {
                            Text("12-hour").tag(ClockType.twelveHour)
                            Text("24-hour").tag(ClockType.twentyFourHour)
                    }).pickerStyle(SegmentedPickerStyle())
                }
                
                SettingsModule(title: "Precision: \(timeEmitter.interval)") {
                    Picker(
                        selection: clockPrecision,
                        label: Text("Precision"),
                        content: {
                            Text("Low").tag(ClockPrecision.low)
                            Text("Medium").tag(ClockPrecision.medium)
                            Text("High").tag(ClockPrecision.high)
                            Text("Higher").tag(ClockPrecision.veryHigh)
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
