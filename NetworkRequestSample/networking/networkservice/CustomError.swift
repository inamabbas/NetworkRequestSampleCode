//
//  CustomError.swift
//  NetworkRequestSample
//
//  Created by Inam Abbas on 03.12.23.
//

import Foundation

enum CustomError: Error {
    case invalidRequest
    case invalidResponse
    case failedToDecode
    
    var localizedDescription: String {
        switch self {
        case .invalidRequest:
            return NSLocalizedString("invalidRequestErrorMessage", comment: "")
        case .invalidResponse:
            return NSLocalizedString("invalidResponseErrorMessage", comment: "")
        case .failedToDecode:
            return NSLocalizedString("failedToDecodeErrorMessage", comment: "")
        }
    }
}
