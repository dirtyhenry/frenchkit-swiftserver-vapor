//
//  TalksFetcher.swift
//  EventAppCore
//
//  Copyright © 2019 Harpp. All rights reserved.
//

import Foundation
import RealmSwift

public struct TalksFetcher {

  public init() {}

  public func fetchAll() {

    Network.default.request(.allTalks, type: [Network.Response.Talk].self) { (result) in

      switch result {
      case .success(let talks):

        let talksToUpdate = talks.compactMap { Talk.from(shared: $0) }
        let realm = Realm.safeRealm

        let talksToDelete = realm.objects(Talk.self).filter {
          !talksToUpdate.contains($0)
        }

        try? realm.write {
          realm.add(talksToUpdate, update: .modified)
          realm.delete(talksToDelete)
        }

      case .failure(let error):
        print("An error occured: \(error)")
      }
    }
  }

  public func create(title: String) {

    let talk = Network.Body.Talk(title: title)

    Network.default.request(.createTalk(body: talk), type: Network.Response.Talk.self) { (result) in

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
