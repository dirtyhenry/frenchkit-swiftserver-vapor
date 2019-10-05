//
//  TalksFetcher.swift
//  EventAppCore
//
//  Copyright © 2019 Harpp. All rights reserved.
//

import Foundation
import EventShared
import RealmSwift

public struct TalksFetcher {

  public init() {}

  public func fetchAll() {

    Network.default.request(.allTalks, type: [EventShared.Talk].self) { (result) in

      switch result {
      case .success(let talks):

        let talksToUpdate = talks.compactMap { Talk.from(shared: $0) }
        let realm = Realm.safeRealm
        try? realm.write {
          realm.add(talksToUpdate, update: .modified)
        }

      case .failure(let error):
        print("An error occured: \(error)")
      }
    }
  }

  public func create(title: String) {

    let talk = EventShared.Talk(title: title)

    Network.default.request(.createTalk(body: talk), type: EventShared.Talk.self) { (result) in

      switch result {
      case .success(let talk):

        let talksToUpdate = Talk.from(shared: talk)
        let realm = Realm.safeRealm
        try? realm.write {
          realm.add(talksToUpdate, update: .modified)
        }

      case .failure(let error):
        //Here inform the user, delete local talk or retry
        try? Talk.add(name: title)
        print("An error occured: \(error)")
      }
    }

  }

}
