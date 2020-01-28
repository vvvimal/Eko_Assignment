//
//  UserListGetRequest.swift
//  Eko_Assignment
//
//  Created by Venugopalan, Vimal on 26/01/20.
//  Copyright © 2020 Venugopalan, Vimal. All rights reserved.
//

import UIKit

struct UserListGetRequest: BaseRequest {
    var httpMethod: HTTPMethod = .get
    var params : [String : Any]? = nil
    var urlString: String = ""
    var httpHeader = [String : String]()
    
    init(count: Int){
        self.urlString = NetworkData.kBaseURL + NetworkData.kUserEndPoint + "\(count)"
        self.httpMethod = .get
    }
}

class UserListGetManager: NetworkManager {
    var session: URLSession
    
    
    /// Init function with URLSession configuration
    ///
    /// - Parameter configuration: URLSessionConfiguration
    init(configuration: URLSessionConfiguration) {
        self.session = URLSession(configuration: configuration)
    }
    
    convenience init() {
        self.init(configuration: .default)
    }
    
    /// Get User List Request
    ///
    /// - Parameters:
    ///   - request: In UserListGetRequest object
    ///   - completion: Result consisting of the User Array or APIError
    func getUserList(from request: BaseRequest, completion: @escaping (Result<[User]?, APIError>) -> Void) {
        if let requestObj = request.request{
            fetch(with: requestObj, decode: { json -> [User]? in
                guard let userResult = json as? [User] else { return  nil }
                return userResult
            }, completion: completion)
        }
        else{
            completion(Result.failure(.requestFailed))
        }
    }
}
