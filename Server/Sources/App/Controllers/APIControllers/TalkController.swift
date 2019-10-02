import Vapor

/// Controls basic CRUD operations on `Talk`s.
final class TalkController {
    /// Returns a list of all `Talk`s.
    func index(_ req: Request) throws -> Future<[Talk]> {
        return Talk.query(on: req).all()
    }

    /// Saves a decoded `Talk` to the database.
    func create(_ req: Request) throws -> Future<Talk> {
        return try req.content.decode(Talk.self).flatMap { talk in
            return talk.save(on: req)
        }
    }

    /// Deletes a parameterized `Talk`.
    func delete(_ req: Request) throws -> Future<HTTPStatus> {
        return try req.parameters.next(Todo.self).flatMap { talk in
            return talk.delete(on: req)
        }.transform(to: .ok)
    }
}
