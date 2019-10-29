//
//  Utilities.swift
//  AnalogClock
//
//  Created by Justin Reusch on 10/17/19.
//  Copyright © 2019 Justin Reusch. All rights reserved.
//

import SwiftUI

/**
 Gets the app delegate instance
 */
func getApp() -> AppDelegate { UIApplication.shared.delegate as! AppDelegate }

/**
 Gets the app settings instance
 */
func getAppSettings() -> AppSettings { getApp().settings }

/**
 Gets the time emitter
 */
func getTimeEmitter() -> TimeEmitter { getApp().timeEmitter }
