//
//  SettingsPanel.swift
//  AnalogClock
//
//  Created by Justin Reusch on 10/23/19.
//  Copyright © 2019 Justin Reusch. All rights reserved.
//

import SwiftUI

/// A shortcut to use on this page to get the app settings instance
fileprivate var settings: AppSettings = getAppSettings()

/**
  A view that allows the user to set all configurable settings of the app
 */
struct SettingsPanel: View {
    
    /// This will keep the current time, updated on a regular interval
    @ObservedObject var timeEmitter = getTimeEmitter()
    
    /// Type of clock, 12 or 24-hour
    private var clockType = Binding<ClockType>(
        get: { settings.clockType },
        set: { settings.clockType = $0 }
    )
    
    /// If the clock is 24-hour, as opposed to 12-hour
    private var isTwentyFourHour = Binding<Bool>(
        get: { settings.clockType == .twentyFourHour },
        set: { settings.clockType = $0 ? .twentyFourHour : .twelveHour }
    )
    
    /// How often the emitter updates the current time to the clock
    private var clockPrecision = Binding<ClockPrecision>(
        get: { settings.actualPrecision },
        set: {
            settings.precision = $0
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
    
    /// Show the tick marks
    private var showTickMarks = Binding<Bool>(
        get: { settings.analogClockOptions.tickMarks },
        set: { settings.analogClockOptions.tickMarks = $0 }
    )
    
    /// Makes a string of text describing the current clock precision
    private func getPrecisionText() -> String {
        let updatesPerSecond = Int(1 / timeEmitter.interval)
        return "\(updatesPerSecond) \(updatesPerSecond > 1 ? strings.updatesPlu : strings.updatesSing)"
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: SectionHeaderText(strings.showModules)) {
                    Toggle(isOn: showAnalogClock) {
                        Text(strings.analogClock)
                    }
                    Toggle(isOn: showDigitalClock) {
                        Text(strings.digitalClock)
                    }
                    Toggle(isOn: showDateDisplay) {
                        Text(strings.dateDisplay)
                    }
                }
                
                Section(header: SectionHeaderText(strings.clockType)) {
                    Toggle(isOn: isTwentyFourHour) {
                        Text(strings.twentyFourHour)
                    }
                }
                
                Section(header: SectionHeaderText(strings.precision)) {
                    Text(getPrecisionText())
                    Picker(
                        selection: clockPrecision,
                        label: Text(strings.precision),
                        content: {
                            Text(strings.low).tag(ClockPrecision.low)
                            Text(strings.medium).tag(ClockPrecision.medium)
                            Text(strings.high).tag(ClockPrecision.high)
                    }).pickerStyle(SegmentedPickerStyle())
                }
                
                Section(header: SectionHeaderText(strings.otherOptions)) {
                    Toggle(isOn: showTickMarks) {
                        Text(strings.showTickMarks)
                    }
                }
            }.navigationBarTitle(strings.settings)
        }
    }
}

struct SettingsPanel_Previews: PreviewProvider {
    static var previews: some View {
        SettingsPanel()
    }
}
