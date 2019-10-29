//
//  SectionHeaderText.swift
//  AnalogClock
//
//  Created by Justin Reusch on 10/26/19.
//  Copyright © 2019 Justin Reusch. All rights reserved.
//

import SwiftUI

struct SectionHeaderText: View {
    
    var title: String
    
    var capitalized: Bool = true
    
    init(_ title: String, capitalized: Bool = true) {
        self.title = title
        self.capitalized = capitalized
    }
    
    var body: some View {
        Text(capitalized ? title.uppercased() : title)
    }
}
