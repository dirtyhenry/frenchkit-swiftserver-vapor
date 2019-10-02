@testable import App
import Vapor
import XCTest
import FluentSQLite

//swiftlint:disable force_try
final class TalksTests: XCTestCase {

  // MARK: - Properties

  let URI = "/v1/talks/"

  var _app: Application? = nil
  var app: Application { return self._app! }
  var conn: SQLiteConnection!

  let expectedTitle = "FrenchKit talk"

  // MARK: - Init

  override func setUp() {
    try! Application.reset()
    _app = try! Application.testable()
    conn = try! app.newConnection(to: .sqlite).wait()
  }

  override func tearDown() {
    conn.close()
    _app = nil
  }

  // MARK: - Tests

  func test_talksListingFromAPI() throws {

    let talk = try Talk.create(title: expectedTitle, on: conn)
    _ = try Talk.create(on: conn)

    XCTAssertEqual(talk.title, expectedTitle)

    let talkId = try talk.requireID()
    let response = try app.getResponse(to: URI, decodeTo: [Talk].self)

    XCTAssertNotNil(response)
    XCTAssertTrue(response.count == 2)
    XCTAssertEqual(response[0].id, talkId)
    XCTAssertEqual(response[0].title, talk.title)
  }

  func test_talkCreationFromAPI() throws {

    let talk = Talk(title: expectedTitle)
    let received = try app.getResponse(to: URI,
                                       method: .POST,
                                       headers: ["Content-Type": "application/json"],
                                       data: talk,
                                       decodeTo: Talk.self)

    XCTAssertEqual(received.title, talk.title)
    XCTAssertNotNil(received.id)
  }

  func test_talkDeleteFromAPI() throws {

    let talk = try Talk.create(on: conn)

    let talkId = try talk.requireID()
    let response = try app.sendRequest(to: URI+"\(talkId)", method: .DELETE)

    XCTAssertNotNil(response)
    XCTAssertTrue(response.http.status == .noContent)
  }

  // MARK: - All

  static let allTests = [
    ("test_talksListingFromAPI", test_talksListingFromAPI),
    ("test_talkCreationFromAPI", test_talkCreationFromAPI),
    ("test_talkDeleteFromAPI", test_talkDeleteFromAPI)
  ]
}
