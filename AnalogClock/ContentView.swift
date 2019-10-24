//
//  ContentView.swift
//  AnalogClock
//
//  Created by Justin Reusch on 9/26/19.
//  Copyright © 2019 Justin Reusch. All rights reserved.
//

import SwiftUI

struct SectionHeaderText: View {
    
    var title: String
    
    var capitalized: Bool = true
    
    init(_ title: String, capitalized: Bool = true) {
        self.title = title
        self.capitalized = capitalized
    }
    
    var body: some View {
        Text(capitalized ? title.uppercased() : title)
    }
}

/**
 Base content view for the clock app
 */
struct ContentView: View {
    
    @ObservedObject var settings = getAppSettings()
    
    /// Display settings controls
    @State private var showSettings: Bool = false
    
    var body: some View {
        
        NavigationView {
            
            VStack {
                Spacer()
                if settings.visibleModules.analogClock {
                    AnalogClockView(type: settings.clockType)
                        .padding()
                    Spacer()
                }
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
            .navigationBarItems(
                trailing: SettingsLink()
            )
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
