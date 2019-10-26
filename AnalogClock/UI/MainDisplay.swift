//
//  MainDisplay.swift
//  AnalogClock
//
//  Created by Justin Reusch on 10/26/19.
//  Copyright © 2019 Justin Reusch. All rights reserved.
//

import SwiftUI

/**
 Main display content for clocks and date
 */
struct MainDisplay: View {
    
    @ObservedObject var settings = getAppSettings()
    
    /// Display settings controls
    @State private var showSettings: Bool = false
    
    var body: some View {
        RotatableStack {
            Spacer()
            if settings.visibleModules.analogClock {
                AnalogClockView(type: settings.clockType)
                    .padding()
            }
            if settings.visibleModules.digitalClock || settings.visibleModules.dateDisplay {
                VStack {
                    Spacer()
                    if settings.visibleModules.digitalClock {
                        DigitalClockView(type: settings.clockType)
                            .padding()
                        Spacer()
                    }
                    if settings.visibleModules.dateDisplay {
                        DateDisplayView(color: .secondary).padding()
                        Spacer()
                    }
                }
            }
        }
        .navigationBarItems(
            trailing: SettingsLink()
        )
    }
}

struct MainDisplay_Previews: PreviewProvider {
    static var previews: some View {
        MainDisplay()
    }
}
