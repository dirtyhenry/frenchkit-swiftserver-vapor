import Vapor

extension Talk {

  struct Update: Content {

    var title: String?
    var date: Date?
    var speakerName: String?
    var notes: String?
  }

}
