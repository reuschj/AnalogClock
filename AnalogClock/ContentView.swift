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
    var timeEmitter = TimeEmitter(updatedEvery: 1.0)
    
    /// Clock dipslay state
    @State var selection = 2
    
    /// Getter for analog clock display flag
    private var showAnalogClock: Bool { selection == 0 || selection == 2 }
    /// Getter for digital clock display flag
    private var showDigitalClock: Bool { selection == 1 || selection == 2 }
    
    var body: some View {
        VStack {
            
            VStack {
                Spacer()
                if showAnalogClock {
                    AnalogClock(timeEmitter: timeEmitter)
                        .padding()
                    Spacer()
                }
                if showDigitalClock {
                    DigitalClock(timeEmitter: timeEmitter, type: ClockType.twelveHour)
                        .padding()
                    Spacer()
                }
            }
            
            Picker(selection: $selection, label:
                Text("Picker Name")
                , content: {
                    Text("Analog").tag(0)
                    Text("Digital").tag(1)
                    Text("Both").tag(2)
            }).pickerStyle(SegmentedPickerStyle()).padding()
            Spacer()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
