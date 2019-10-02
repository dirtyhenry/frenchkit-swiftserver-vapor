//
//  Config.swift
//  EventApp
//
//  Copyright © 2018 harpp. All rights reserved.
//

import Foundation

public struct Config {

  public static func setup() {
    LogsConfig.setupConsole()
    RealmConfig.setup()
  }
}
