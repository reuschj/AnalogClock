//
//  DateDisplayView.swift
//  AnalogClock
//
//  Created by Justin Reusch on 10/20/19.
//  Copyright © 2019 Justin Reusch. All rights reserved.
//

import SwiftUI

struct DateDisplayView: View {
    
    @ObservedObject var timeEmitter: TimeEmitter = getTimeEmitter()
    
    var time: TimeKeeper { timeEmitter.time }
    
    var color: Color = .primary
    
    var font: Font = .body
    
    var body: some View {
        HStack {
            Spacer()
            TimeTextBlock(text: time.dateString, color: color, font: font)
            Spacer()
        }
    }
}
