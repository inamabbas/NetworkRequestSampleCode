//
//  PhotoService.swift
//  NetworkRequestSample
//
//  Created by Inam Abbas on 03.12.23.
//

import Foundation

protocol PhotosServiceProtocol: AnyObject {
    associatedtype Response: Decodable
    func getPhotos(completion: @escaping CompletionHandler<Response>)
}

typealias CompletionHandler<Response: Decodable> = (Result<Response, Error>) -> Void

class PhotoAPIService: PhotosServiceProtocol {
    typealias Response = [Photo]
    
    var networkService: URLSessionNetworkService
    
    init(networkService: URLSessionNetworkService) {
        self.networkService = networkService
    }
    
    func getPhotos(completion: @escaping CompletionHandler<Response>) {
        let request = PhotoRequest()
        networkService.load(request: request, responseType: Response.self, completion: completion)
    }
}
