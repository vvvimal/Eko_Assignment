//
//  BaseRequest.swift
//  Eko_Assignment
//
//  Created by Venugopalan, Vimal on 26/01/20.
//  Copyright © 2020 Venugopalan, Vimal. All rights reserved.
//

import UIKit

// MARK: - BaseRequest protocol for the URLRequest
protocol BaseRequest {
    
    var urlString: String { get }
    var params: [String: Any]? { get }
    var httpMethod: HTTPMethod { get }
    var httpHeader: [String: String] { get }
}

// MARK: - BaseRequest protocol extension
extension BaseRequest {
    
    var urlComponents: URLComponents? {
        return URLComponents(string: urlString)
    }
    
    var request: URLRequest? {
        if let url = urlComponents?.url{
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = httpMethod.rawValue
            
            if let paramValue = params{
                do {
                    urlRequest.httpBody = try JSONSerialization.data(withJSONObject: paramValue, options: .prettyPrinted) // pass dictionary to nsdata object and set it as request body
                } catch let error {
                    debugPrint(error.localizedDescription)
                }
            }
            
            urlRequest.allHTTPHeaderFields = ["Content-Type" : "application/json"]
            for (key,value) in httpHeader{
                urlRequest.addValue(value, forHTTPHeaderField: key)
            }
            return urlRequest
        }
        return nil
    }
    
}
