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
    
    var body: some View {
        
        NavigationView {
            MainDisplay()
        }.environment(\.horizontalSizeClass, .compact)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
