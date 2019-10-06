//
//  TalkResponse.swift
//  EventAppCore
//
//  Copyright © 2019 Harpp. All rights reserved.
//

import Foundation

extension Network.Response {

  struct Talk: Decodable {
    var id: String?
    var title: String
    var notes: String?
    var date: Date?
    var speakerName: String?

    var dateCreated: Date?
    var dateModified: Date?
  }
}
