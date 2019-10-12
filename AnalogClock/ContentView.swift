//
//  ContentView.swift
//  AnalogClock
//
//  Created by Justin Reusch on 9/26/19.
//  Copyright © 2019 Justin Reusch. All rights reserved.
//

import SwiftUI

struct AnalogClock: View {
    
    var timeEmitter: TimeEmitter
    
    var type: ClockType = ClockType.twelveHour
        
    var lineWidth: CGFloat = 1
    
    private let padding: CGFloat = UIMeasurement(2).value
    
    private func getSize(_ geometry: GeometryProxy) -> CGFloat { CGFloat.minimum(geometry.size.width, geometry.size.height) }
    
    private func renderClock(size: CGFloat) -> some View {
        ZStack {
            Circle()
                .foregroundColor(.clear)
                .overlay(Circle()
                    .stroke(Color.secondary, lineWidth: lineWidth))
            ClockNumbers(type: type, color: .primary)
            HourHand(timeEmitter: timeEmitter, twentyFourHour: type == .twentyFourHour, color: .accentColor)
            MinuteHand(timeEmitter: timeEmitter, color: .primary)
            SecondHand(timeEmitter: timeEmitter, color: .secondary)
        }
        .frame(width: size, height: size, alignment: .center)
    }
    
    var body: some View {
        GeometryReader { geometry in
            self.renderClock(size: self.getSize(geometry))
        }
    }
}

/**
 Renders clock numbers around the inner edge of the clock
 */
struct ClockNumbers: View {
    
    /// Type of clock, 12-hour or 24-hour (value of `ClockType` enum)
    var type: ClockType = .twelveHour
    
    /// Color of clock numbers
    var color: Color = .primary
    
    /// Flag for 24-hour clock vs. 12-hour clock
    private var twentyFourHour: Bool { type == .twentyFourHour }
    
    /// Amount of clock numbers to display
    private var steps: Int { twentyFourHour ? 24 : 12 }
    /// Angle between each clock number
    private var increment: Double { 360 / Double(steps) }
    
    /// Allowable bounds for font scaling
    private let fontRange: ClosedRange<CGFloat> = 14...40
    
    /// Calculates a scaled font size that fits with the clock's diameter
    private func calculateFontSize(clockDiameter: CGFloat) -> CGFloat {
        limitToRange((clockDiameter / 22), range: fontRange)
    }
    
    /// Calculates an offset that based on the clock's diameter and scaled font size
    private func calculateOffset(clockDiameter: CGFloat, fontSize: CGFloat) -> CGFloat {
        (clockDiameter / 2 - fontSize) * -1
    }
    
    /// Positions the clock numbers around the inner edge of the clock
    private func positionClockNumbers(clockDiameter: CGFloat) -> some View {
        let fontSize = calculateFontSize(clockDiameter: clockDiameter)
        let offsetAmount = calculateOffset(clockDiameter: clockDiameter, fontSize: fontSize)
        return ZStack {
            ForEach((1...self.steps), id: \.self) {
                ClockNumber(number: $0, fontSize: fontSize, color: self.color)
                    .rotationEffect(Angle(degrees: self.increment * -Double($0)))
                    .offset(x: 0, y: offsetAmount)
                    .rotationEffect(Angle(degrees: self.increment * Double($0)))
            }
        }
    }
    
    var body: some View {
        GeometryReader { geometry in
            self.positionClockNumbers(clockDiameter: geometry.size.width)
        }
    }
}

/**
 Renders an individual clock number
 */
struct ClockNumber: View {
    
    /// The number to render
    var number: Int
    
    /// The font size to render the number
    var fontSize: CGFloat = 16
    
    /// The color to render the number
    var color: Color = .primary
    
    var body: some View {
        return Text("\(number)")
            .font(.system(size: fontSize))
            .foregroundColor(color)
    }
}


struct HourHand: View {
    
    var timeEmitter: TimeEmitter
    
    var twentyFourHour: Bool = false
    
    var color: Color = .primary
    
    var type: ClockHandType { twentyFourHour ? .twentyFourHour : .hour }
    
    var body: some View {
        ClockHand(timeEmitter: timeEmitter, lengthRatio: 0.6, width: 6, type: type, color: color)
    }
}

struct MinuteHand: View {
    
    var timeEmitter: TimeEmitter
        
    var color: Color = .primary
        
    var body: some View {
        ClockHand(timeEmitter: timeEmitter, lengthRatio: 0.85, width: 4, type: .minute, color: color)
    }
}

struct SecondHand: View {
    
    var timeEmitter: TimeEmitter
    
    var color: Color = .primary
        
    private var type: ClockHandType { timeEmitter.interval < 1 ? .preciseSecond : .second }
        
    var body: some View {
        ClockHand(timeEmitter: timeEmitter, lengthRatio: 0.92, width: 2, type: type, color: color)
    }
}

struct ClockHand: View {
    
    @ObservedObject var timeEmitter: TimeEmitter
    
    var lengthRatio: CGFloat = 1
    var width: CGFloat = 4
    var type: ClockHandType = .hour
    var color: Color = .primary
    
    private var rotationInDegrees: Double {
        switch type {
        case.twentyFourHour:
            return timeEmitter.handController.hour24 ?? 0
        case .hour:
            return timeEmitter.handController.hour ?? 0
        case .minute:
            return timeEmitter.handController.minute ?? 0
        case .second:
            return timeEmitter.handController.second ?? 0
        case .preciseSecond:
            return timeEmitter.handController.preciseSecond ?? 0
        case .period:
            return timeEmitter.handController.period ?? 0
        default:
            return 0
        }
    }
    
    var body: some View {
        ClockHandShape(lengthRatio: lengthRatio, width: width)
            .foregroundColor(color)
            .scaledToFit()
            .rotationEffect(Angle(degrees: rotationInDegrees))
    }
}

struct ClockHandShape: View {
    
    private var lengthRatio: CGFloat
    private var width: CGFloat
    private var overhangRatio: CGFloat
    
    private let ratioRange: ClosedRange<CGFloat> = 0...1.0
    
    init(lengthRatio: CGFloat = 1.0, width: CGFloat = 4, overhangRatio: CGFloat = 0.1) {
        self.lengthRatio = limitToRange(lengthRatio, range: ratioRange)
        self.width = width
        self.overhangRatio = limitToRange(overhangRatio, range: ratioRange)
    }
    
    private func getLength(clockDiameter: CGFloat) -> CGFloat {
        let radius = clockDiameter / 2
        return (radius * lengthRatio) + (radius * overhangRatio)
    }
    
    private func getOffset(clockDiameter: CGFloat) -> CGFloat {
        let halfRadius = clockDiameter / 4
        return (halfRadius * lengthRatio) - (halfRadius * overhangRatio)
    }
    
    func renderClockHand(clockDiameter: CGFloat) -> some View {
        let length = getLength(clockDiameter: clockDiameter)
        let offset = getOffset(clockDiameter: clockDiameter)
        return RoundedRectangle(cornerRadius: self.width / 2)
            .frame(width: width, height: length, alignment: .bottom)
            .offset(x: 0, y: offset)
            .rotationEffect(Angle(degrees: 180))
    }
    
    var body: some View {
        GeometryReader { geometry in
            self.renderClockHand(clockDiameter: geometry.size.width)
        }
        
    }
}

struct DigitalClock: View {
    
    @ObservedObject var timeEmitter: TimeEmitter
    var type: ClockType = ClockType.twelveHour
    
    var time: TimeKeeper { timeEmitter.time }
    
    var body: some View {
        HStack {
            Spacer()
            TimeTextBlock(text: time.hour12String)
            DigitalClockSeperator()
            TimeTextBlock(text: time.paddedMinute)
            DigitalClockSeperator()
            TimeTextBlock(text: time.paddedSecond)
            DigitalClockSeperator()
            TimeTextBlock(text: time.period?.rawValue)
            Spacer()
        }
    }
}

struct DigitalClockSeperator: View {
    
    var width: CGFloat = UIMeasurement(0.5).value
    
    var color: Color = .secondary
    
    var body: some View {
        HStack {
            Spacer().fixedSize().frame(width: width / 2)
            Text(":").foregroundColor(color)
            Spacer().fixedSize().frame(width: width / 2)
        }
    }
}

struct TimeTextBlock: View {
    
    var text: String?
    
    var color: Color = .primary
        
    var body: some View {
        Text(text ?? "")
            .font(.title)
            .foregroundColor(color)
    }
}

struct TimeNumberBlock: View {
    
    var number: Int?
    
    var color: Color = .primary
    
    var body: some View {
        TimeTextBlock(text: "\(number ?? 0)", color: color)
    }
}

struct ContentView: View {
    
    // This will keep the current time, updated every second
    var timeEmitter = TimeEmitter(updatedEvery: 1.0)
   
    @State var selection = 2
    
    private var showAnalogClock: Bool { selection == 0 || selection == 2 }
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
