//
//  Talk+RW.swift
//  EventApp
//
//  Copyright © 2018 harpp. All rights reserved.
//

import Foundation
import RealmSwift

public extension Talk {

  static func all() -> Results<Talk> {
    let realm = Realm.safeRealm
    return realm.objects(Talk.self)
  }

  static func add(name: String) throws {

    let talk = Talk()
    talk.name = name

    let realm = Realm.safeRealm
    try realm.write {
      realm.add(talk)
    }

  }

  static func add(_ talk: Talk) throws {

    let realm = Realm.safeRealm
    try realm.write {
      realm.add(talk, update: .modified)
    }

  }

  func delete() throws {

    let realm = Realm.safeRealm
    try realm.write {
      realm.delete(self)
    }
  }

}
