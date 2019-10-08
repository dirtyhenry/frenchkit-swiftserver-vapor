import FluentSQLite
import Vapor
import FancyPackage

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
