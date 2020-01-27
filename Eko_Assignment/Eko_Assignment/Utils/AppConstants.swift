//
//  AppConstants.swift
//  Eko_Assignment
//
//  Created by Venugopalan, Vimal on 26/01/20.
//  Copyright © 2020 Venugopalan, Vimal. All rights reserved.
//

import UIKit

struct NetworkData{
    static let kBaseURL = "https://api.github.com/"
    static let kUserEndPoint = "users?since="
}

/// API related errors
enum APIError:Error{
    
    case requestFailed
    case jsonConversionFailure
    case invalidData
    case responseUnsuccessful
    case jsonParsingFailure
    case noInternetError
    
    var message: String {
        switch self {
        case .requestFailed: return "Request failed."
        case .invalidData: return "Invalid data."
        case .responseUnsuccessful: return "Response unsuccessful."
        case .jsonParsingFailure: return "JSON parsing failure."
        case .jsonConversionFailure: return "JSON conversion failure."
        case .noInternetError: return "No internet connection."
        }
    }
}

enum HTTPMethod:String{
    case get = "GET"
    case post = "POST"
}
