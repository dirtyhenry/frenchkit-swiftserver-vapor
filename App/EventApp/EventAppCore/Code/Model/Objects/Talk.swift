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

extension Talk {

  static func from(shared: Network.Response.Talk) -> Talk {

    let talk = Talk()

    if let identifier = shared.id {
      talk.identifier = identifier
    }

    talk.name = shared.title
    talk.notes = shared.notes
    talk.dueDate = shared.date

    talk.speakerName = shared.speakerName

    if let dateCreated = shared.dateCreated {
      talk.dateCreated = dateCreated
    }
    if let dateModified = shared.dateCreated {
      talk.dateModified = dateModified
    }

    return talk
  }
}
