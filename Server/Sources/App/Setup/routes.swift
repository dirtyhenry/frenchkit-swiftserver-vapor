import Vapor

/// Register your application's routes here.
public func routes(_ router: Router) throws {

  router.get { req in
    return "It works!"
  }

  router.get("frenchkit") { req in
    return "So coool!"
  }

  let talksController = TalksController()
  try router.register(collection: talksController)
}
