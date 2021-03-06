//
//  AppDelegate.swift
//  AnalogClock
//
//  Created by Justin Reusch on 9/26/19.
//  Copyright © 2019 Justin Reusch. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    /// Loads themes to app
    var themes = ClockTheme.loadThemes()
    
    /// Clock settings with defaults
    var settings = AppSettings.getFromDefaults()
    
    /// Emits current time and date on a regular interval
    var timeEmitter = ClockTimeEmitter(
        precision: .low,
        rotationOutput: .degrees,
        clockType: .twelveHour
    )
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        timeEmitter.clockType = settings.clockType
        timeEmitter.precision = settings.actualPrecision
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

