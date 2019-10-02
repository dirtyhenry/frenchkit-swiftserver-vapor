//
//  AppDelegate.swift
//  EventApp
//
//  Copyright © 2018 harpp. All rights reserved.
//

import UIKit
import SwiftyBeaver
import EventAppCore

let log = SwiftyBeaver.self

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?

  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

    Config.setup()

    return true
  }

  func applicationWillResignActive(_ application: UIApplication) {
  }

  func applicationDidEnterBackground(_ application: UIApplication) {
  }

  func applicationWillEnterForeground(_ application: UIApplication) {
  }

  func applicationDidBecomeActive(_ application: UIApplication) {
  }

  func applicationWillTerminate(_ application: UIApplication) {
  }

  func application(_ application: UIApplication,
                   continue userActivity: NSUserActivity,
                   restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {

    log.info("continue userActivity: \(userActivity.activityType)\n")
    return true
  }

  func application(_ application: UIApplication,
                   didFailToContinueUserActivityWithType userActivityType: String,
                   error: Error) {

    log.error("didFailToContinueUserActivityWithType: \(userActivityType)\n\(error)\n")
  }
}
