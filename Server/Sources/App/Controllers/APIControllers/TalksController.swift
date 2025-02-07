import Vapor

/// Controls basic CRUD operations on `Talk`s.
final class TalksController: RouteCollection {

  func boot(router: Router) throws {

    let route = router.grouped("v1", "talks")

    route.get(use: index)
    route.get(Talk.parameter, use: get)
    route.put(Talk.parameter, use: update)
    route.post(Talk.self, use: create)
    route.delete(Talk.parameter, use: delete)
  }

  // MARK: - Routes implementation

  /// Returns a list of all `Talk`s.
  func index(_ req: Request) throws -> Future<[Talk]> {
    return Talk.query(on: req).all()
  }

  /// Saves a decoded `Talk` to the database.
  func create(_ req: Request, talk: Talk) throws -> Future<Talk> {
    return talk.save(on: req)
  }

  /// Deletes a parameterized `Talk`.
  func delete(_ req: Request) throws -> Future<HTTPStatus> {
    return try req.parameters.next(Talk.self)
      .flatMap { talk in
        talk.delete(on: req)
      }
      .transform(to: .noContent)
  }

  func get(_ req: Request) throws -> Future<Talk> {
    // Please implement this
    throw Abort(.notFound)
  }

  func update(_ req: Request) throws -> Future<Talk> {
    // Please implement this
    throw Abort(.notFound)
  }
}
