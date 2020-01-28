//
//  UserListViewModel.swift
//  Eko_Assignment
//
//  Created by Venugopalan, Vimal on 25/01/20.
//  Copyright © 2020 Venugopalan, Vimal. All rights reserved.
//

import UIKit

class UserListViewModel: NSObject {

    var userArray:[User] = []
    
    private let userListGetManager = UserListGetManager()
    
    var numberOfSections = 1
    
    func getUserList(completionHandler:@escaping (Result<Bool, APIError>) -> Void){
        let userListGetRequest = UserListGetRequest(count: userArray.count)
        
        userListGetManager.getUserList(from: userListGetRequest, completion: {[weak self] result in
            switch(result){
            case .success(let userListObj):
                if let userList = userListObj {
                    self?.userArray.append(contentsOf: userList)
                }
                completionHandler(.success(true))
            case .failure(let error):
                completionHandler(.failure(error))
            }
            
        })
    }
    
    func userAt(index:IndexPath) -> User{
        userArray[index.row]
    }
    
    func numberOfRows(inSection: Int) -> Int{
        userArray.count
    }
    
    func addFavoriteStatus(userId: Int) -> Bool{
        var favorite:[Int] = Utils.getValue(for: "favoriteArray") as? [Int] ?? []
        if favorite.filter({$0 == userId}) != [] {
            favorite.removeFirst(userId)
            Utils.save(value: favorite, for: "favoriteArray")
            return false
        }
        else{
            favorite.append(userId)
            Utils.save(value: favorite, for: "favoriteArray")
            return true
        }
    }
    
    func isFavorite(userId:Int) -> Bool{
        let favorite:[Int] = Utils.getValue(for: "favoriteArray") as? [Int] ?? []

        return favorite.filter({$0 == userId}) != [] ? true : false /*{
            return true
        }
        return false*/
    }
}
