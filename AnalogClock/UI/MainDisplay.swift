//
//  MainDisplay.swift
//  AnalogClock
//
//  Created by Justin Reusch on 10/26/19.
//  Copyright © 2019 Justin Reusch. All rights reserved.
//

import SwiftUI
import RotatableStack

/**
 Main display content for clocks and date
 */
struct MainDisplay: View {
    
    /// Global app settings
    @ObservedObject var settings = getAppSettings()
    private var theme: ClockTheme.Settings { settings.theme.settings }
    
    var body: some View {
        RotatableStack {
            Spacer()
            if self.settings.visibleModules.analogClock {
                AnalogClockView(type: self.settings.clockType)
                    .padding()
            }
            if self.settings.visibleModules.digitalClock || self.settings.visibleModules.dateDisplay {
                VStack {
                    Spacer()
                    if self.settings.visibleModules.digitalClock {
                        DigitalClockView(type: self.settings.clockType)
                            .padding()
                        Spacer()
                    }
                    if self.settings.visibleModules.dateDisplay {
                        DateDisplayView()
                            .padding()
                        Spacer()
                    }
                }
            }
        }
        .navigationBarItems(
            trailing: SettingsLink(color: theme.settingsLinkColor)
        )
    }
}

struct MainDisplay_Previews: PreviewProvider {
    static var previews: some View {
        MainDisplay()
    }
}
