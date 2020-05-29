//
//  Font.swift
//  AnalogClock
//
//  Created by Justin Reusch on 5/14/20.
//  Copyright © 2020 Justin Reusch. All rights reserved.
//

import SwiftUI

extension Font {
    struct majorMonoDisplay {
        static func regular(size: CGFloat) -> Font { Font.custom(CustomFonts.MajorMonoDisplay.regular, size: size) }
    }
    struct montserrat {
        static func thin(size: CGFloat) -> Font { Font.custom(CustomFonts.Montserrat.thin, size: size) }
        static func light(size: CGFloat) -> Font { Font.custom(CustomFonts.Montserrat.light, size: size) }
        static func medium(size: CGFloat) -> Font { Font.custom(CustomFonts.Montserrat.medium, size: size) }
        static func regular(size: CGFloat) -> Font { Font.custom(CustomFonts.Montserrat.regular, size: size) }
        static func italic(size: CGFloat) -> Font { Font.custom(CustomFonts.Montserrat.italic, size: size) }
        static func bold(size: CGFloat) -> Font { Font.custom(CustomFonts.Montserrat.bold, size: size) }
        static func black(size: CGFloat) -> Font { Font.custom(CustomFonts.Montserrat.black, size: size) }
    }
}
