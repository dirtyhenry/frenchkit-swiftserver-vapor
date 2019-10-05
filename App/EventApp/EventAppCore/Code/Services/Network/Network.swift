//
//  Network.swift
//  EventAppCore
//
//  Copyright © 2019 Harpp. All rights reserved.
//

import Foundation

class Network {

  static let `default` = Network()

  // MARK: - Structure

  enum Body {}
  enum Response {}

  enum EventsError: Error {
    case route(underlying: Error)
    case request(underlying: Error)
    case noData
    case decoding(underlying: Error)
  }

  // MARK: - Properties

  private let session = URLSession(configuration: .default)

  // MARK: - Methods

  func request<T: Decodable>(_ route: Router,
                             type: T.Type,
                             completion: @escaping (Result<T, EventsError>) -> Void) {

    do {

      let task = session.dataTask(with: try route.asURLRequest()) { (data, _, error) in

        if let error = error {
          completion(.failure(.request(underlying: error)))
        }

        guard let data = data else {
          completion(.failure(.noData))
          return
        }

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601

        do {
          let object = try decoder.decode(type, from: data)
          completion(.success(object))
        } catch {
          completion(.failure(.decoding(underlying: error)))
        }

      }

      task.resume()

    } catch {
      completion(.failure(.route(underlying: error)))
    }
  }

}
