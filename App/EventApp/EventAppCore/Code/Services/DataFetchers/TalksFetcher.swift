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

}
