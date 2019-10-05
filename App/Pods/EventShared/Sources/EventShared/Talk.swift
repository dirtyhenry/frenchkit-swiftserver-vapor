import Foundation

public struct Talk: Codable {

  public var id: UUID?

  public var title: String

  public var date: Date?
  public var speakerName: String?
  public var notes: String?

  public var dateCreated: Date?
  public var dateModified: Date?

  public init(id: UUID? = nil, title: String) {
    self.id = id
    self.title = title
  }
}
