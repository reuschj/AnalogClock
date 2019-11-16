//
//  PeriodDisplayView.swift
//  AnalogClock
//
//  Created by Justin Reusch on 11/15/19.
//  Copyright © 2019 Justin Reusch. All rights reserved.
//

import SwiftUI

struct PeriodDisplayView: View {
    
    var color: Color = .primary
    
    var fontSize: CGFloat = 10
    
    /// Emits the current time and date at regular intervals
    @ObservedObject var timeEmitter: ClockTimeEmitter = getTimeEmitter()
    
    var body: some View {
        Text(timeEmitter.time.periodString ?? "")
    }
}

struct PeriodDisplayView_Previews: PreviewProvider {
    static var previews: some View {
        PeriodDisplayView()
    }
}
