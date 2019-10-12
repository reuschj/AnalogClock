//
//  TimeAware.swift
//  AnalogClock
//
//  Created by Justin Reusch on 2/26/19.
//  Copyright © 2019 Justin Reusch. All rights reserved.
//

import Foundation

protocol TimeAware {
    var time: TimeKeeper! { get }
}
