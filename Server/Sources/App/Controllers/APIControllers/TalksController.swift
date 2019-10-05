import Vapor
import EventShared

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
  func index(_ req: Request) throws -> Future<[EventShared.Talk]> {
    return Talk.query(on: req).all().map {
      $0.compactMap { (talk) in
        talk.toPublic()
      }
    }
  }

  /// Saves a decoded `Talk` to the database.
  func create(_ req: Request, talk: Talk) throws -> Future<EventShared.Talk> {
    return talk.save(on: req).toPublic()
  }

  /// Deletes a parameterized `Talk`.
  func delete(_ req: Request) throws -> Future<HTTPStatus> {
    return try req.parameters.next(Talk.self)
      .flatMap { talk in
        talk.delete(on: req)
      }
      .transform(to: .noContent)
  }

  func get(_ req: Request) throws -> Future<EventShared.Talk> {
    return try req.parameters.next(Talk.self).toPublic()
  }

  func update(_ req: Request) throws -> Future<EventShared.Talk> {

    return flatMap(
      try req.parameters.next(Talk.self),
      try req.content.decode(Talk.Update.self)
    ) { talkToUpdate, updatedInfos in

      //Update our talk
      if let title = updatedInfos.title {
        talkToUpdate.title = title
      }

      if let date = updatedInfos.date {
        talkToUpdate.date = date
      }

      if let speakerName = updatedInfos.speakerName {
        talkToUpdate.speakerName = speakerName
      }

      if let notes = updatedInfos.notes {
        talkToUpdate.notes = notes
      }

      //and save
      return talkToUpdate.save(on: req).toPublic()
    }

  }
}
