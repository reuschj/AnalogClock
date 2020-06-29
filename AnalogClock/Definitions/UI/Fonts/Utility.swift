//
//  Utility.swift
//  AnalogClock
//
//  Created by Justin Reusch on 5/12/20.
//  Copyright © 2020 Justin Reusch. All rights reserved.
//

import UIKit

/// Utility to print out all font families and names
func printAllFonts() {
    for family in UIFont.familyNames.sorted() {
        let names = UIFont.fontNames(forFamilyName: family)
        print("Family: \(family), Font names: \(names)")
    }
}
