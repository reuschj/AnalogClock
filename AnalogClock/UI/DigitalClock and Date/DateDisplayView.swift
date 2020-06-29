//
//  DateDisplayView.swift
//  AnalogClock
//
//  Created by Justin Reusch on 10/20/19.
//  Copyright © 2019 Justin Reusch. All rights reserved.
//

import SwiftUI
import TimeKeeper

/**
 A date display view module
 */
struct DateDisplayView: View {
    
    /// Emits the current time and date at regular intervals
    @ObservedObject var timeEmitter: ClockTimeEmitter = getTimeEmitter()
    
    /// The emitted time from the `timeEmitter`
    var time: TimeKeeper { timeEmitter.time }
    
    /// Global app settings
    @ObservedObject var settings: AppSettings = getAppSettings()
    
    private var theme: Theme { settings.theme.settings.date }
    private var colors: Theme.Colors { theme.colors }
    
    private let dateFontRange: ClosedRange<CGFloat> = 14...50
    
    private func makeDateDisplay(within width: CGFloat) -> some View {
        let font: Font = theme.dateText.getFont(within: width, limitedTo: dateFontRange)
        return HStack {
            Spacer()
            TimeTextBlock(
                text: time.dateString,
                color: colors.dateText,
                font: font
            )
            Spacer()
        }
    }
    
    var body: some View {
        GeometryReader { geometry in
            self.makeDateDisplay(within: geometry.size.width)
        }
    }
    
    struct Theme {
        var colors: Colors = Colors()
        var dateText: ClockFont = FixedClockFont(.body)
        
        struct Colors {
            var dateText: Color = .primary
        }
    }
}
