//
//  CacheManager.swift
//  Eko_Assignment
//
//  Created by Venugopalan, Vimal on 26/01/20.
//  Copyright © 2020 Venugopalan, Vimal. All rights reserved.
//

import UIKit

fileprivate let dataCache = NSCache<AnyObject, AnyObject>()

class CacheManager {
    
    private static var sharedInstance:CacheManager!
    
    /// singleton instance of cachemanager
    ///
    /// - Parameters:
    ///   - costLimit: cost limit of the data cached
    ///   - countLimit: count limit of the data cached
    ///   - isDiscardableContent: is content discardable
    /// - Returns: CacheManager object
    static func shared(costLimit:Int? = nil, countLimit:Int? = nil, isDiscardableContent:Bool? = false) -> CacheManager{
        if sharedInstance != nil{
            return sharedInstance
        }
        else{
            sharedInstance = CacheManager()
            if let costValue = costLimit {
                dataCache.totalCostLimit = costValue
            }
            if let countValue = countLimit{
                dataCache.countLimit = countValue
            }
            if let discardFlag = isDiscardableContent{
                dataCache.evictsObjectsWithDiscardedContent = discardFlag
            }
            return sharedInstance
        }
    }
    
    private init() {
        
    }
    
    /// Set object for key
    ///
    /// - Parameters:
    ///   - data: data set in cache
    ///   - key: string representing url
    private func setObject(data:Any, forKey key:String){
        dataCache.setObject(data as AnyObject, forKey: key as AnyObject)
    }
    
    /// Get object for key
    ///
    /// - Parameter key: string representing the url
    /// - Returns: Data from cache
    private func object(forKey key:String) -> Any?{
        return dataCache.object(forKey: key as AnyObject)
    }
    
    /// Get Data for request object
    ///
    /// - Parameters:
    ///   - session: URLSession object for data task
    ///   - request: URLRequest object
    ///   - completion: completion handler
    /// - Returns: URLSessionDataTask if no data in cache
    func getData(session:URLSession, request: URLRequest, completion: @escaping (_ data: Data?, _ response: URLResponse?, _ error: Error? ) -> Void) -> URLSessionDataTask? {
        if let urlString = request.url?.absoluteString{
            if let urlCacheObj = CacheManager.shared().object(forKey: urlString) as? [String:Any], let httpResponse = urlCacheObj["response"] as? HTTPURLResponse, let data = urlCacheObj["data"] as? Data {
                completion(data, httpResponse, nil)
            } else {
                let task = session.dataTask(with: request, completionHandler: { data, response, error in
                    if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                        if let dataObj = data, error == nil {
                            let urlCacheObj = ["response": httpResponse, "data": dataObj] as [String : Any]
                            CacheManager.shared().setObject(data: urlCacheObj, forKey: urlString)
                            
                        }
                    }
                    completion(data, response, error)
                })
                return task
            }
        }
        return nil
    }
}
