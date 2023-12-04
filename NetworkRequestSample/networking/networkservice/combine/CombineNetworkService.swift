//
//  CombineNetworkService.swift
//  NetworkRequestSample
//
//  Created by Inam Abbas on 30.11.23.
//

import Foundation
import Combine

protocol CombineNetworkServiceProtocol: AnyObject {
    func load<Response: Decodable>(request: Request, responseType: Response.Type) -> AnyPublisher<Response, Error>
}

class CombineNetworkService: CombineNetworkServiceProtocol {
    
    var session: URLSession
    
    init(session: URLSession = URLSession(configuration: .ephemeral)) {
        self.session = session
    }

    func load<Response: Decodable>(request: Request, responseType: Response.Type) -> AnyPublisher<Response, Error> {
        guard let urlRequest = request.urlRequest() else {
            return Fail(error: CustomError.invalidRequest).eraseToAnyPublisher()
        }

        return session.dataTaskPublisher(for: urlRequest)
            .receive(on: DispatchQueue.global())
            .mapError { _ in CustomError.invalidRequest }
            .flatMap(validateResponse)
            .decode(type: responseType, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
    
    private func validateResponse(_ data: Data, _ response: URLResponse) -> AnyPublisher<Data, Error> {
        guard let httpResponse = response as? HTTPURLResponse else {
            return Fail(error: CustomError.invalidResponse).eraseToAnyPublisher()
        }

        guard 200..<300 ~= httpResponse.statusCode else {
            return Fail(error: CustomError.invalidResponse).eraseToAnyPublisher()
        }

        return Just(data).setFailureType(to: Error.self).eraseToAnyPublisher()
    }
}

