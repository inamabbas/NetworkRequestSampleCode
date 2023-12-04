//
//  PhotoRequest.swift
//  NetworkRequestSample
//
//  Created by Inam Abbas on 03.12.23.
//

import Foundation

class PhotoRequest: UrlRequest {
    override init() {
        super.init()
        method = .get
    }
    
    override func baseUrlString() -> String? {
        return ApiConfiguration.baseUrl
    }
    
    override func restUrlChunk() -> String? {
        return "photos"
    }
    
}
