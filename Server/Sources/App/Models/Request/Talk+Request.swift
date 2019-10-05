import Vapor
import EventShared

extension Talk {

  struct Update: Content {

    var title: String?
    var date: Date?
    var speakerName: String?
    var notes: String?
  }

  func toPublic() -> EventShared.Talk {

    var publicTalk = EventShared.Talk(id: self.id,
                                      title: self.title)

    publicTalk.date = date
    publicTalk.speakerName = speakerName
    publicTalk.notes = notes
    publicTalk.dateCreated = dateCreated
    publicTalk.dateModified = dateModified

    return publicTalk
  }
}

extension Future where T: Talk {

  func toPublic() -> Future<EventShared.Talk> {
    return map { $0.toPublic() }
  }
}

extension EventShared.Talk: Content {}
