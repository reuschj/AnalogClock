//
//  DigitalClockView.swift
//  AnalogClock
//
//  Created by Justin Reusch on 10/16/19.
//  Copyright © 2019 Justin Reusch. All rights reserved.
//

import SwiftUI
import TimeKeeper

struct DigitalClockView: View {
    
    /// Emits the current time and date at regular intervals
    @ObservedObject var timeEmitter: ClockTimeEmitter = getTimeEmitter()
    
    /// Global app settings
    @ObservedObject var settings: AppSettings = getAppSettings()
    
    private var theme: Theme { settings.theme.settings.digital }
    private var colors: Theme.Colors { theme.colors }
    
    /// Type of clock, 12-hour, 24-hour or decimal
    var type: ClockType = .twelveHour
    
    /// The emitted time from the `timeEmitter`
    var time: TimeKeeper { timeEmitter.time }
    
    /// Gets the time text for the hours place
    private var hourTimeText: String? {
        switch type {
        case .twelveHour:
            return time.hour12String
        case .twentyFourHour:
            return time.hour24String
        case .decimal:
            return time.hourDecimalString
        }
    }
    
    /// Gets the time text for the minutes place
    private var minuteTimeText: String? {
        switch type {
        case .twelveHour, .twentyFourHour:
            return time.paddedMinute
        case .decimal:
            return time.paddedDecimalMinute
        }
    }
    
    /// Gets the time text for the seconds place
    private var secondTimeText: String? {
        switch type {
        case .twelveHour, .twentyFourHour:
            return time.paddedSecond
        case .decimal:
            return time.paddedDecimalSecond
        }
    }
    
    private let timeDigitFontRange: ClosedRange<CGFloat> = 14...50
    
    private func getTimeDigitFont(within container: CGFloat) -> Font {
        theme.timeDigits.getFont(within: container, limitedTo: timeDigitFontRange)
    }
    
    private func getSeparatorFont(within container: CGFloat) -> Font {
        theme.timeSeparators.getFont(within: container, limitedTo: timeDigitFontRange)
    }
    
    private func getPeriodFont(within container: CGFloat) -> Font? {
        theme.periodDigits?.getFont(within: container, limitedTo: timeDigitFontRange)
    }
    
    
    private func makeDigitalDisplay(within width: CGFloat) -> some View {
        let timeDigitFont: Font = getTimeDigitFont(within: width)
        let periodFont: Font = getPeriodFont(within: width) ?? timeDigitFont
        let separatorFont: Font = getTimeDigitFont(within: width)
        let _separator_ = DigitalClockSeparator(
            color: colors.timeSeparators,
            font: separatorFont,
            character: theme.separatorCharacter
        )
        func digit(_ text: String?, font: Font = timeDigitFont) -> TimeTextBlock {
            TimeTextBlock(
                text: text,
                color: colors.timeDigits,
                font: font
            )
        }
        return HStack {
            Spacer()
            digit(hourTimeText)
            _separator_
            digit(minuteTimeText)
            _separator_
            digit(secondTimeText)
            if type == .twelveHour {
                _separator_
                digit(time.periodString, font: periodFont)
            }
            Spacer()
        }
    }
    
    var body: some View {
        GeometryReader { geometry in
            self.makeDigitalDisplay(within: geometry.size.width)
        }
    }
    
    struct Theme {
        var colors: Colors = Colors()
        var timeDigits: ClockFont = FixedClockFont(.title)
        var timeSeparators: ClockFont = FixedClockFont(.title)
        var periodDigits: ClockFont? = nil
        var separatorCharacter: Character = ":"
        
        struct Colors {
            var timeDigits: Color = .primary
            var timeSeparators: Color = .gray
        }
    }
}
