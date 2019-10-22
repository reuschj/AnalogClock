//
//  DigitalClockComponents.swift
//  AnalogClock
//
//  Created by Justin Reusch on 10/16/19.
//  Copyright © 2019 Justin Reusch. All rights reserved.
//

import SwiftUI

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
    
    var font: Font = .title
    
    var pre: String? = nil
    
    var post: String? = nil
    
    private func getText() -> String { "\(self.text ?? "")\(self.pre ?? "")\(self.post ?? "")" }
    
    var body: some View {
        Text(getText())
            .font(font)
            .foregroundColor(color)
    }
}

struct TimeNumberBlock: View {
    
    var number: Int?
    
    var color: Color = .primary
    
    var font: Font = .title
    
    var pre: String? = nil
    
    var post: String? = nil
    
    var body: some View {
        TimeTextBlock(text: "\(number ?? 0)", color: color, font: font, pre: pre, post: post)
    }
}
