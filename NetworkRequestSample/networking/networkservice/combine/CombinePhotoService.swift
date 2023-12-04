//
//  CombinePhotoService.swift
//  NetworkRequestSample
//
//  Created by Inam Abbas on 03.12.23.
//

import Combine

protocol CombinePhotoServiceProtocol: AnyObject {
    func getPhotos() -> AnyPublisher<[Photo], Error>
}

class CombinePhotoService: CombinePhotoServiceProtocol {
    let networkService: CombineNetworkServiceProtocol
    
    init(networkService: CombineNetworkServiceProtocol) {
        self.networkService = networkService
    }
    
    func getPhotos() -> AnyPublisher<[Photo], Error> {
        let request = PhotoRequest()
        return networkService.load(request: request, responseType: [Photo].self)
    }
}
