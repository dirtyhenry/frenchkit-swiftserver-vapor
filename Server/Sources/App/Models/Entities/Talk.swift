import FluentSQLite
import Vapor

/// A single entry of a Talk
final class Talk {
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

/// Allows `Talk` to be stored in a SQLite database.
extension Talk: SQLiteUUIDModel {

  static let createdAtKey: TimestampKey? = \.dateCreated
  static let updatedAtKey: TimestampKey? = \.dateModified

}

/// Allows `Talk` to be used as a dynamic migration.
extension Talk: Migration { }

/// Allows `Talk` to be encoded to and decoded from HTTP messages.
extension Talk: Content { }

/// Allows `Talk` to be used as a dynamic parameter in route definitions.
extension Talk: Parameter { }
