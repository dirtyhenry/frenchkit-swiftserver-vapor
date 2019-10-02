//
//  Realm+Access.swift
//  EventAppCore
//
//  Copyright © 2019 harpp. All rights reserved.
//

import Foundation
import RealmSwift

public extension Realm {

  static var safeRealm: Realm {
    guard let realm = try? Realm() else {
      fatalError("Cannot create a realm: review your implementation")
    }

    return realm
  }
}
