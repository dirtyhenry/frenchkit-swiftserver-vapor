import FluentSQLite
import Vapor

/// A single entry of a Todo list.
final class Talk: SQLiteModel {
    /// The unique identifier for this `Talk`.
    var id: Int?

    /// A title describing what this `Talk` entails.
    var title: String

    /// Creates a new `Talk`.
    init(id: Int? = nil, title: String) {
        self.id = id
        self.title = title
    }
}

/// Allows `Talk` to be used as a dynamic migration.
extension Talk: Migration { }

/// Allows `Talk` to be encoded to and decoded from HTTP messages.
extension Talk: Content { }

/// Allows `Talk` to be used as a dynamic parameter in route definitions.
extension Talk: Parameter { }
