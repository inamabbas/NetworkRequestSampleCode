//
//  PhotoViewModel.swift
//  NetworkRequestSample
//
//  Created by Inam Abbas on 03.12.23.
//

import Foundation
import Combine

class PhotoViewModel {
    private let photoService: CombinePhotoServiceProtocol
    
    private var cancellables: Set<AnyCancellable> = []
    
    @Published var photos: [Photo] = []
    
    @Published var error: Error?
    
    weak var coordinator: MainCoordinator?
    
    init(photoService: CombinePhotoServiceProtocol) {
        self.photoService = photoService
    }
    
    func loadPhotos() {
        photoService.getPhotos()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self?.error = error
                }
            } receiveValue: { [weak self] photos in
                self?.photos = photos
            }
            .store(in: &cancellables)

    }
    
    deinit {
        cancellables.forEach{ $0.cancel() }
    }
}

