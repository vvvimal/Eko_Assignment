//
//  NetworkManager.swift
//  Eko_Assignment
//
//  Created by Venugopalan, Vimal on 26/01/20.
//  Copyright © 2020 Venugopalan, Vimal. All rights reserved.
//

import UIKit

protocol NetworkManager {
    
    var session: URLSession { get }
    func fetch<T: Decodable>(with request: URLRequest, decode: @escaping (Decodable) -> T?, completion: @escaping (Result<T, APIError>) -> Void)
    
}

extension NetworkManager {
    
    typealias JSONTaskCompletionHandler = (Decodable?, APIError?) -> Void
    
    /// Decoding task which actually fetches the data from the URL Request
    ///
    /// - Parameters:
    ///   - request: URLRequest object
    ///   - decodingType: the generic type for the model to be converted
    ///   - completion: completion handler for JSON conversion success or failure
    /// - Returns: return the session data task
    private func decodingTask<T: Decodable>(with request: URLRequest, decodingType: T.Type, completionHandler completion: @escaping JSONTaskCompletionHandler) -> URLSessionDataTask {
        
        let task = session.dataTask(with: request) { data, response, error in
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(nil, .requestFailed)
                return
            }
            
            debugPrint("---------------------------")
            debugPrint("URL:\(String(describing: response?.url?.absoluteString))")
            debugPrint("data: \(String(describing: String(data: data!, encoding: String.Encoding.utf8)))")
            debugPrint("---------------------------")

            if httpResponse.statusCode == 200 {
                if let dataObj = data{
                    do {
                        let genericModel = try JSONDecoder().decode(decodingType, from: dataObj)
                        completion(genericModel, nil)
                    } catch {
                        print(error)
                        completion(nil, .jsonConversionFailure)
                    }
                }
                else{
                    completion(nil, .invalidData)
                }
                
            } else {
                completion(nil, .responseUnsuccessful)
            }
        }
        return task
    }
    
    /// Fetch Data from API
    ///
    /// - Parameters:
    ///   - request: URLRequest object
    ///   - decode: closure to convert result to Model required
    ///   - completion: closure to return the result
    func fetch<T: Decodable>(with request: URLRequest, decode: @escaping (Decodable) -> T?, completion: @escaping (Result<T, APIError>) -> Void) {
        if Reachability.isConnectedToNetwork(){
            
            let task = decodingTask(with: request, decodingType: T.self) { (json , error) in
                
                //MARK: change to main queue
                DispatchQueue.main.async {
                    guard let json = json else {
                        if let error = error {
                            completion(Result.failure(error))
                        } else {
                            completion(Result.failure(.invalidData))
                        }
                        return
                    }
                    if let value = decode(json) {
                        completion(.success(value))
                    } else {
                        completion(.failure(.jsonParsingFailure))
                    }
                }
            }
            task.resume()
        }
        else{
            completion(Result.failure(.noInternetError))
        }
    }
    
    /// Download image with url request
    ///
    /// - Parameters:
    ///   - request: URL request object
    ///   - completion: closure to return the result
    func downloadImage(with request: URLRequest, completion: @escaping (Result<UIImage?, APIError>) -> Void) {
        let task = CacheManager.shared().getData(session: session, request: request, completion: { data, response, error in
            
            if error == nil, let usableData = data {
                if let image = UIImage.init(data: usableData as Data){
                    completion(.success(image))
                }
            }
            else if error != nil {
                completion(.failure(.invalidData))
            }
        })
        task?.resume()
        
    }
}
