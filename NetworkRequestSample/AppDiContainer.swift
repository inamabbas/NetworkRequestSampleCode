//
//  AppDiContainer.swift
//  NetworkRequestSample
//
//  Created by Inam Abbas on 04.12.23.
//

import Foundation

protocol AppDiContainer: AnyObject {
    var networkService : CombineNetworkServiceProtocol { get }
    var photoService : CombinePhotoServiceProtocol { get }
}

class DependencyContainer: AppDiContainer {
    lazy var networkService: CombineNetworkServiceProtocol = {
        return CombineNetworkService()
    }()
    
    lazy var photoService: CombinePhotoServiceProtocol  = {
        return CombinePhotoService(networkService: networkService)
    }()
}
