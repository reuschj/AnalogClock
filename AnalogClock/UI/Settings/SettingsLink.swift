//
//  SettingsLink.swift
//  AnalogClock
//
//  Created by Justin Reusch on 10/24/19.
//  Copyright © 2019 Justin Reusch. All rights reserved.
//

import SwiftUI

struct SettingsLink: View {
    var body: some View {
        NavigationLink(destination: SettingsPanel()) {
            Text("Settings").padding(.trailing)
        }
    }
}

struct SettingsLink_Previews: PreviewProvider {
    static var previews: some View {
        SettingsLink()
    }
}
