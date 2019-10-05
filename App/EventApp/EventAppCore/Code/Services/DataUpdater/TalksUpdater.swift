//
//  TalksUpdater.swift
//  EventAppCore
//
//  Copyright © 2019 Harpp. All rights reserved.
//

import Foundation
import EventShared
import RealmSwift

public struct TalksUpdater {

  private let identifier: UUID

  public init(id: UUID) {
    self.identifier = id
  }

  public func update(talk: Talk) {

    let body = Network.Body.Talk(title: talk.name,
                                 notes: talk.notes,
                                 date: talk.dueDate,
                                 speakerName: talk.speakerName)

    Network.default.request(.updateTalk(id: identifier, body: body),
                            type: EventShared.Talk.self) { (result) in

      switch result {
      case .success(let talk):

        let talksToUpdate = Talk.from(shared: talk)
        let realm = Realm.safeRealm
        try? realm.write {
          realm.add(talksToUpdate, update: .modified)
        }

      case .failure(let error):
        //Here inform the user, delete local talk or retry
        print("An error occured: \(error)")
      }
    }

  }

  public func delete() {

    Network.default.request(.deleteTalk(id: identifier)) { (result) in

      switch result {
      case .success:
        print("Succesfully deleted")
      case .failure(let error):
        //Here inform the user, re-fetch data from network or retry to delete
        print("An error occured: \(error)")
      }
    }

  }

}
