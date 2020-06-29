//
//  ContentView.swift
//  AnalogClock
//
//  Created by Justin Reusch on 9/26/19.
//  Copyright © 2019 Justin Reusch. All rights reserved.
//

import SwiftUI
import AppBackgroundView

/**
 Base content view for the clock app
 */
struct ContentView: View {
    
    /// Global app settings
    @ObservedObject var settings: AppSettings = getAppSettings()
    private var theme: ClockTheme.Settings { settings.theme.settings }
    
    var body: some View {
        
        NavigationView {
            ZStack {
                AppBackgroundView(theme.appBackground ?? Color.clear) {
                    MainDisplay()
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

/// For Xcode preview
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
