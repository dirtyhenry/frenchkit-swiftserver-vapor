//
//  Talk.swift
//  EventApp
//
//  Copyright © 2018 harpp. All rights reserved.
//

import Foundation
import RealmSwift

public final class Talk: Object {

  @objc public dynamic var identifier: String = UUID().uuidString
  @objc public dynamic var name: String?
  @objc public dynamic var notes: String?
  @objc public dynamic var dueDate: Date?

  @objc public dynamic var speakerName: String?

  @objc public dynamic var dateCreated = Date()
  @objc public dynamic var dateModified = Date()

  @objc
  override public static func primaryKey() -> String? {
    return "identifier"
  }
}
