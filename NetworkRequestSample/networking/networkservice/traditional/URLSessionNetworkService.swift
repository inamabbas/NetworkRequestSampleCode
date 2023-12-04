//
//  TraditionalUrlSessionService.swift
//  NetworkRequestSample
//
//  Created by Inam Abbas on 03.12.23.
//

import Foundation

class URLSessionNetworkService {
    var session: URLSession
    
    init(session: URLSession = URLSession(configuration: .ephemeral)) {
        self.session = session
    }
    
    func load<Response: Decodable>(
        request: Request,
        responseType: Response.Type,
        completion: @escaping (Result<Response, Error>) -> Void
    ) {
        guard let urlRequest = request.urlRequest() else {
            completion(.failure(CustomError.invalidRequest))
            return
        }
        
        let task = session.dataTask(with: urlRequest) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(CustomError.invalidResponse))
                return
            }
            
            guard 200..<300 ~= httpResponse.statusCode else {
                completion(.failure(CustomError.invalidResponse))
                return
            }
            
            do {
                let result = try JSONDecoder().decode(responseType.self, from: data ?? Data())
                completion(.success(result))
            } catch {
                completion(.failure(CustomError.failedToDecode))
            }
        }
        
        task.resume()
    }
}
