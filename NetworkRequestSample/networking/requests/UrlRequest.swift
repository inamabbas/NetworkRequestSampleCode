//
//  UrlRequest.swift
//  NetworkRequestSample
//
//  Created by Inam Abbas on 03.12.23.
//

import Foundation

protocol Request: AnyObject {
    func urlRequest() -> URLRequest?
}

enum HttpMethodType: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

enum ParameterEncoding {
    case JsonSerialized
}

class UrlRequest: Request {
    
    var method: HttpMethodType?
    
    func restUrlChunk() -> String? {
        return nil
    }
    
    func baseUrlString() -> String? {
        return ApiConfiguration.baseUrl
    }
    
    func parameters() -> [String: String]? {
        return nil
    }
    
    func headers() -> [String: String]? {
        return nil
    }
    
    func encoding() -> ParameterEncoding? {
        return nil
    }
    
    func urlRequest() -> URLRequest? {
        guard var baseUrl = baseUrlString() else { return nil }
        if let restUrlChunk = restUrlChunk() {
            baseUrl = baseUrl + restUrlChunk
        }
        
        guard let requestUrl = URL(string: baseUrl) else { return nil}
        
        guard var urlComponents = URLComponents(url: requestUrl, resolvingAgainstBaseURL: false) else {
            return nil
        }
        
        var httpBody: Data?
        
        if let parameters = parameters() {
            if encoding() == .JsonSerialized {
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: parameters)
                    httpBody = jsonData
                } catch {
                    return nil
                }
            } else {
                urlComponents.queryItems = parameters.keys.map({ key in
                    URLQueryItem(name: key, value: parameters[key]?.description)
                })
            }
        }
        
        guard let url = urlComponents.url else {
            return nil
        }
        
        var request = URLRequest(url: url)
        
        request.httpMethod = method?.rawValue
        
        if let httpBody = httpBody {
            request.httpBody = httpBody
        }
        
        if let headers = headers() {
            request.allHTTPHeaderFields = headers
        }
        
        return request
    }
}
