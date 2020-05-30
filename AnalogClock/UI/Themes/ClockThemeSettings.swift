//
//  ClockTheme.swift
//  AnalogClock
//
//  Created by Justin Reusch on 5/12/20.
//  Copyright © 2020 Justin Reusch. All rights reserved.
//

import SwiftUI

struct UIScale {
    
    var percent: CGFloat = 1
    
    var scaleTo: ScaleBase = .screenWidth
    
    var flexFont: FlexFont { FlexFont(flexFontSize) }
    var flexFontSize: FlexFontSize { percent * 100 }
    
    init(_ percent: CGFloat, of scaleBase: ScaleBase = .screenWidth) {
        self.percent = percent
        self.scaleTo = scaleBase
    }
    
    init(oneOver denominator: CGFloat, of scaleBase: ScaleBase = .screenWidth) {
        let percent: CGFloat = 1 / denominator
        self.init(percent, of: scaleBase)
    }
    
    init(flexFont: FlexFont, of scaleBase: ScaleBase = .screenWidth) {
        self.init(flexFont.percent, of: scaleBase)
    }
    
    init(fontSize: FlexFontSize, of scaleBase: ScaleBase = .screenWidth) {
        self.init((fontSize / 100), of: scaleBase)
    }
    
    func getSize(within containerSize: CGFloat, limitedTo range: ClosedRange<CGFloat>? = nil) -> CGFloat {
        let scaled = containerSize * percent
        guard let range = range else { return scaled }
        if range.contains(scaled) { return scaled }
        if scaled > range.upperBound { return range.upperBound }
        if scaled < range.upperBound { return range.lowerBound }
        return scaled
    }
    
    enum ScaleBase {
        case screenWidth
        case screenHeight
        case clockDiameter
        case clockRadius
    }
    
    /// A font size that is scaled based on it's container. Should read as a percentage of font height the overall container.
    typealias FlexFontSize = CGFloat
    
    struct FlexFont {
        var size: FlexFontSize = 10
        var percent: CGFloat { size / 100 }
        
        init(_ size: FlexFontSize = 10) {
            self.size = size
        }
    }
}

struct ClockElementColor {
    var fill: Color? = nil
    var outline: Color? = nil
}

//struct AnalogClockColorTheme {
//    // Backgrounds
//    var appBackground: Color? = nil
//    // Clock
//    var clock: ClockElementColor = ClockElementColor(fill: nil, outline: .primary)
//    var clockNumbers: Color = .primary
//    var clockMajorTicks: Color = .primary
//    var clockMinorTicks: Color = .primary
//    // Hands
//    var hourHand: ClockElementColor = ClockElementColor(fill: .primary)
//    var minuteHand: ClockElementColor = ClockElementColor(fill: .primary)
//    var secondHand: ClockElementColor = ClockElementColor(fill: .primary)
//    // Period hand
//    var periodHand: ClockElementColor = ClockElementColor(fill: .primary)
//    var periodText: Color = .secondary
//    // Tick tock pendulum
//    var tickTockHand: ClockElementColor = ClockElementColor(fill: .secondary)
//}

protocol ClockFont {
    func getFont(within containerSize: CGFloat, limitedTo range: ClosedRange<CGFloat>?) -> Font
}

struct FixedClockFont: ClockFont {
    var font: Font
    
    init(_ font: Font) {
        self.font = font
    }
    
    func getFont(within containerSize: CGFloat = 0, limitedTo range: ClosedRange<CGFloat>? = nil) -> Font { font }
}

struct FlexClockFont: ClockFont {
    var fontName: String?
    var scale: UIScale
    
    init(name fontName: String? = nil, scale: UIScale) {
        self.fontName = fontName
        self.scale = scale
    }
    
    func getFontSize(within containerSize: CGFloat, limitedTo range: ClosedRange<CGFloat>? = nil) -> CGFloat {
        scale.getSize(within: containerSize, limitedTo: range)
    }
    
    func getFont(within containerSize: CGFloat, limitedTo range: ClosedRange<CGFloat>? = nil) -> Font {
        let size = getFontSize(within: containerSize, limitedTo: range)
        guard let fontName = fontName else {
            return .system(size: size)
        }
        return Font.custom(fontName, size: size)
    }
}

//struct HandShape<Content>: View where Content : View {
//
//    /// Stores the content function builder
//    public var content: () -> Content
//
//    /**
//     - Parameter content: The view builder content to pass
//     */
//    @inlinable public init(@ViewBuilder content: @escaping () -> Content) {
//        self.content = content
//    }
//
//    public var body: some View {
//        self.content()
//    }
//}

struct StrokedShape<ShapeContent>: View where ShapeContent: Shape {
    var foreground: Color?
    var outlineColor: Color?
    var outlineWidth: CGFloat = 1
    var shape: () -> ShapeContent
    
    @inlinable init(foreground: Color? = nil, outlineColor: Color? = nil, outlineWidth: CGFloat = 1, @ViewBuilder shape: @escaping () -> ShapeContent) {
        self.foreground = foreground
        self.outlineColor = outlineColor
        self.outlineWidth = outlineWidth
        self.shape = shape
    }
    
    var body: some View {
        let shape = self.shape()
        return VStack {
            shape
                .foregroundColor(foreground)
                .overlay(outlineColor.map { shape.stroke($0, lineWidth: outlineWidth) })
        }
    }
}

enum ClockShape {
    case circle
    case square
    case roundedRectangle(cornerRadius: CGFloat, style: RoundedCornerStyle = .circular)

    var circle: Circle? {
        switch self {
        case .circle:
            return Circle()
        default:
            return nil
        }
    }
    
    var square: Rectangle? {
        switch self {
        case .square:
            return Rectangle()
        default:
            return nil
        }
    }
    
    var roundedRectangle: RoundedRectangle? {
        switch self {
        case .roundedRectangle(cornerRadius: let radius, style: let style):
            return RoundedRectangle(cornerRadius: radius, style: style)
        default:
            return nil
        }
    }
}

class ClockTheme: Hashable, Comparable {
    
    var key: String
    
    var label: String
    
    var sortClass: Int8? = nil
    
    var settings: Settings
    
    init(
        key: String,
        label: String,
        sortClass: Int8? = nil,
        _ settings: Settings
    ) {
        self.key = key
        self.label = label
        self.sortClass = sortClass
        self.settings = settings
        Self.themes[key] = self
        print("Created a new theme with label \"\(label)\" and key \"\(key)\"")
    }
    
    struct Settings {
        var appBackground: Color? = nil
        var settingsLinkColor: Color = .accentColor
        var analog: AnalogClockView.Theme = AnalogClockView.Theme()
        var digital: DigitalClockView.Theme = DigitalClockView.Theme()
        var date: DateDisplayView.Theme = DateDisplayView.Theme()
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(key)
    }
    
    static func == (lhs: ClockTheme, rhs: ClockTheme) -> Bool {
        (lhs.key == rhs.key) && (lhs.label == rhs.label)
    }
    
    static func < (lhs: ClockTheme, rhs: ClockTheme) -> Bool {
        let left = lhs.sortClass ?? Int8.max
        let right = rhs.sortClass ?? Int8.max
        guard left == right else { return left < right }
        return lhs.key < rhs.key
    }
    
    static private(set) var themes: [String:ClockTheme] = [:]
    
    static func loadThemes() -> [String:ClockTheme] {
        let themeList: [ClockTheme] = [.standardTheme, .altTheme]
        _ = themeList.map { themes[$0.key] = $0 }
        return Self.themes
    }
    
    static let standardTheme = ClockTheme(
        key: "standard_theme",
        label: strings.standard,
        sortClass: 0,
        Settings(
            appBackground: nil,
            settingsLinkColor: .accentColor,
            analog: AnalogClockView.Theme(
                shape: .circle,
                colors: AnalogClockView.Theme.Colors(
                    clock: ClockElementColor(outline: .secondary),
                    clockNumbers: .primary,
                    clockMajorTicks: .secondary,
                    clockMinorTicks: .gray,
                    hourHand: ClockElementColor(fill: .accentColor),
                    minuteHand: ClockElementColor(fill: .primary),
                    secondHand: ClockElementColor(fill: .secondary),
                    periodHand: ClockElementColor(fill: .gray),
                    periodText: .primary,
                    tickTockHand: ClockElementColor(fill: .gray),
                    pivot: ClockElementColor(fill: .accentColor)
                ),
                outlineWidth: 2,
                numbers: FlexClockFont(scale: UIScale(oneOver: 16, of: .clockDiameter)),
                hourHand: ClockHand.Hour.defaultDimensions,
                minuteHand: ClockHand.Minute.defaultDimensions,
                secondHand: ClockHand.Second.defaultDimensions,
                periodHand: ClockHand.Period.defaultDimensions,
                periodText: FlexClockFont(scale: UIScale(oneOver: 30, of: .clockDiameter)),
                pivotScale: UIScale(oneOver: 25, of: .clockDiameter),
                pivotShape: .circle,
                pivotOutlineWidth: 1
            ),
            digital: DigitalClockView.Theme(
                colors: DigitalClockView.Theme.Colors(
                    timeDigits: .primary,
                    timeSeparators: .secondary
                ),
                timeDigits: FixedClockFont(.title),
                timeSeparators: FixedClockFont(.body),
                periodDigits: nil,
                separatorCharacter: ":"
            ),
            date: DateDisplayView.Theme(
                colors: DateDisplayView.Theme.Colors(
                    dateText: .secondary
                ),
                dateText: FixedClockFont(.body)
            )
        )
    )
    
    static let altTheme = ClockTheme(
        key: "impact_theme",
        label: strings.impact,
        Settings(
            appBackground: .impactBackground,
            settingsLinkColor: .impact,
            analog: AnalogClockView.Theme(
                shape: .circle,
                colors: AnalogClockView.Theme.Colors(
                    clock: ClockElementColor(fill: .impact10, outline: .impact75),
                    clockNumbers: .impact,
                    clockMajorTicks: .impact,
                    clockMinorTicks: .impact50,
                    hourHand: ClockElementColor(fill: .impact10, outline: .impact),
                    minuteHand: ClockElementColor(fill: .impact10, outline: .impact75),
                    secondHand: ClockElementColor(fill: .impact10, outline: .impact75),
                    periodHand: ClockElementColor(fill: .impact50),
                    periodText: .impact75,
                    tickTockHand: ClockElementColor(fill: .gray),
                    pivot: ClockElementColor(fill: .impact)
                ),
                outlineWidth: 2,
                numbers: FlexClockFont(
                    name: CustomFonts.MajorMonoDisplay.regular,
                    scale: UIScale(oneOver: 10, of: .clockDiameter)
                ),
                hourHand: ClockHand.Hour.getDefaultDimensions(outlineWidth: 2),
                minuteHand: ClockHand.Minute.defaultDimensions,
                secondHand: ClockHand.Second.defaultDimensions,
                periodHand: ClockHand.Period.defaultDimensions,
                periodText: FlexClockFont(
                    name: CustomFonts.Montserrat.regular,
                    scale: UIScale(oneOver: 30, of: .screenWidth)
                ),
                pivotScale: UIScale(oneOver: 25, of: .clockDiameter),
                pivotShape: .circle,
                pivotOutlineWidth: 1
            ),
            digital: DigitalClockView.Theme(
                colors: DigitalClockView.Theme.Colors(
                    timeDigits: .impact,
                    timeSeparators: .impact25
                ),
                timeDigits: FlexClockFont(
                    name: CustomFonts.MajorMonoDisplay.regular,
                    scale: UIScale(oneOver: 11, of: .screenWidth)
                ),
                timeSeparators: FlexClockFont(
                    name: CustomFonts.MajorMonoDisplay.regular,
                    scale: UIScale(oneOver: 24, of: .screenWidth)
                ),
                periodDigits: FlexClockFont(
                    name: CustomFonts.Montserrat.light,
                    scale: UIScale(oneOver: 11, of: .screenWidth)
                ),
                separatorCharacter: ":"
            ),
            date: DateDisplayView.Theme(
                colors: DateDisplayView.Theme.Colors(
                    dateText: .impact50
                ),
                dateText: FlexClockFont(
                    name: CustomFonts.Montserrat.regular,
                    scale: UIScale(oneOver: 14, of: .screenWidth)
                )
            )
        )
    )
}
