import Foundation

enum Router {

  //talks
  case allTalks
  case getTalk(id: UUID)
  case createTalk(body: Network.Body.Talk)
  case updateTalk(id: UUID, body: Network.Body.Talk)
  case deleteTalk(id: UUID)
}

// MARK: - Routing informations
extension Router {

  var baseURL: String {
    return "http://localhost:8080"
  }

  var path: String {
    switch self {
    case .allTalks,
         .createTalk:
      return "/v1/talks"
    case .getTalk(let id),
         .updateTalk(let id, _),
         .deleteTalk(let id):
      return "/v1/talks/\(id.uuidString)"
    }
  }

  var method: String {
    switch self {
    case .allTalks: return "GET"
    case .getTalk: return "GET"
    case .createTalk: return "POST"
    case .updateTalk: return "PUT"
    case .deleteTalk: return "DELETE"
    }
  }

  var body: Data? {
    let encoder = JSONEncoder()
    encoder.dateEncodingStrategy = .iso8601

    switch self {
    case .allTalks: return nil
    case .getTalk: return nil
    case .createTalk(let body): return try? encoder.encode(body)
    case .updateTalk(_, let body): return try? encoder.encode(body)
    case .deleteTalk: return nil
    }
  }
}

// MARK: - URLRequest
extension Router {

  func asURLRequest() throws -> URLRequest {
    guard let url = URL(string: baseURL + path) else {
      fatalError("Invalid generated URL -> please review your implementation")
    }

    var request = URLRequest(url: url)
    request.httpMethod = method

    if let body = body {
      request.addValue("application/json", forHTTPHeaderField: "Content-Type")
      request.httpBody = body
    }

    return request
  }
}
