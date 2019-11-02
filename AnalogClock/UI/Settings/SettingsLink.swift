//
//  SettingsLink.swift
//  AnalogClock
//
//  Created by Justin Reusch on 10/24/19.
//  Copyright © 2019 Justin Reusch. All rights reserved.
//

import SwiftUI

/**
 The navigation button the user clicks on the navigate to the settings page
 */
struct SettingsLink: View {
    
    var body: some View {
        NavigationLink(destination: SettingsPanel()) {
            Text(strings.settings).padding(.trailing)
        }
    }
}

struct SettingsLink_Previews: PreviewProvider {
    static var previews: some View {
        SettingsLink()
    }
}
