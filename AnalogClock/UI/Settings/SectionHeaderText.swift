//
//  SectionHeaderText.swift
//  AnalogClock
//
//  Created by Justin Reusch on 10/26/19.
//  Copyright © 2019 Justin Reusch. All rights reserved.
//

import SwiftUI

/**
 Formats the header text for each section of the settings panel
 */
struct SectionHeaderText: View {
    
    /// The title string to display in the header
    var title: String
    
    /// If the title string should be changed to all caps
    var capitalized: Bool = true
    
    /**
     - Parameters:
         - title: The title string to display in the header
         - capitalized: If the title string should be changed to all caps
     */
    init(_ title: String, capitalized: Bool = true) {
        self.title = title
        self.capitalized = capitalized
    }
    
    var body: some View {
        Text(capitalized ? title.uppercased() : title)
    }
}
