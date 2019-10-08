import Foundation

/// A single entry of a Talk
final class Talk: Codable {
  /// The unique identifier for this `Talk`.
  var id: UUID?

  var title: String

  var date: Date?
  var speakerName: String?
  var notes: String?

  var dateCreated: Date?
  var dateModified: Date?

  /// Creates a new `Talk`.
  init(id: UUID? = nil, title: String) {
    self.id = id
    self.title = title
  }
}
