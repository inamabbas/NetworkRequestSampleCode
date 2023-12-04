//
//  Photo.swift
//  NetworkRequestSample
//
//  Created by Inam Abbas on 03.12.23.
//

import Foundation

struct Photo: Codable, Hashable, Equatable {
    let id: Int
    let albumId: Int
    let title: String?
    let url: String
    let thumbnailUrl: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case albumId
        case title, url, thumbnailUrl
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: Photo, rhs: Photo) -> Bool {
        return lhs.id == rhs.id
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(id, forKey: .id)
        try container.encode(albumId, forKey: .albumId)
        try container.encodeIfPresent(title, forKey: .title)
        try container.encode(url, forKey: .url)
        try container.encode(thumbnailUrl, forKey: .thumbnailUrl)
        
    }
}
