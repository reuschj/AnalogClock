//
//  SettingsPanel.swift
//  AnalogClock
//
//  Created by Justin Reusch on 10/23/19.
//  Copyright © 2019 Justin Reusch. All rights reserved.
//

import SwiftUI

fileprivate var settings: AppSettings = getAppSettings()

struct SettingsPanel: View {
    
    /// This will keep the current time, updated on a regular interval
    @ObservedObject var timeEmitter = getTimeEmitter()
    
    private var clockType = Binding<ClockType>(
        get: { settings.clockType },
        set: { settings.clockType = $0 }
    )
    
    private var isTwentyFourHour = Binding<Bool>(
        get: { settings.clockType == .twentyFourHour },
        set: { settings.clockType = $0 ? .twentyFourHour : .twelveHour }
    )
    
    private var clockPrecision = Binding<ClockPrecision>(
        get: { settings.actualPrecision },
        set: {
            settings.actualPrecision = $0
            getTimeEmitter().precision = $0
        }
    )
    
    /// Show the analog clock state
    private var showAnalogClock = Binding<Bool>(
        get: { settings.visibleModules.analogClock },
        set: { settings.visibleModules.analogClock = $0 }
    )
    
    /// Show the digital clock state
    private var showDigitalClock = Binding<Bool>(
        get: { settings.visibleModules.digitalClock },
        set: { settings.visibleModules.digitalClock = $0 }
    )
    
    /// Show the date display state
    private var showDateDisplay = Binding<Bool>(
        get: { settings.visibleModules.dateDisplay },
        set: { settings.visibleModules.dateDisplay = $0 }
    )
    
    private func PrecisionText() -> some View {
        let updatesPerSecond = Int(1 / timeEmitter.interval)
        return HStack {
            Text("\(updatesPerSecond) update\(updatesPerSecond > 1 ? "s" : "") per second")
        }
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: SectionHeaderText("Show modules")) {
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
                
                Section(header: SectionHeaderText("Clock type")) {
                    Toggle(isOn: isTwentyFourHour) {
                        Text("24-hour")
                    }
                }
                
                Section(header: SectionHeaderText("Precision")) {
                    PrecisionText()
                    Picker(
                        selection: clockPrecision,
                        label: Text("Precision"),
                        content: {
                            Text("Low").tag(ClockPrecision.low)
                            Text("Medium").tag(ClockPrecision.medium)
                            Text("High").tag(ClockPrecision.high)
                    }).pickerStyle(SegmentedPickerStyle())
                }
            }.navigationBarTitle("Settings")
        }
    }
}

struct SettingsPanel_Previews: PreviewProvider {
    static var previews: some View {
        SettingsPanel()
    }
}
