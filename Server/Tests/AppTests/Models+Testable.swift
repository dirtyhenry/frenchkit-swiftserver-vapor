@testable import App
import FluentSQLite

// MARK: - Talk
extension Talk {

  static func create(title: String = "My \(UUID().uuidString) talk",
                     on connection: SQLiteConnection) throws -> Talk {

    let talk = Talk(title: title)
    return try talk.save(on: connection).wait()
  }
}
