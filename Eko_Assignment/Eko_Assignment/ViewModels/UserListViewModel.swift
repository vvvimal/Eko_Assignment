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
    
    /// Get user list
    /// - Parameter completionHandler: completion with result for success/ api error
    func getUserList(completionHandler:@escaping (Result<Bool, APIError>) -> Void){
        let userListGetRequest = UserListGetRequest(count: userArray.count)
        
        userListGetManager.getUserList(from: userListGetRequest, completion: {[weak self] result in
            switch(result){
            case .success(let userListObj):
                if let userList = userListObj {
                    let updatedArray = userList.map({[weak self] user -> User in
                        var userObj = user
                        userObj.isFavorite = self?.isFavorite(userId: user.id)
                        return userObj
                    })
                    self?.userArray.append(contentsOf: updatedArray)
                }
                completionHandler(.success(true))
            case .failure(let error):
                completionHandler(.failure(error))
            }
        })
    }
    
    /// User at indexpath
    /// - Parameter index: IndexPath
    func userAt(index:IndexPath) -> User{
        userArray[index.row]
    }
    
    /// Number of rows for table view
    /// - Parameter inSection: Section of tableview
    func numberOfRows(inSection: Int) -> Int{
        userArray.count
    }
    
    /// Add favorite status
    /// - Parameter user: User object
    func addFavoriteStatus(user: User) -> Bool{
        var favorite:[Int] = Utils.getValue(for: "favoriteArray") as? [Int] ?? []
        if let index = userArray.firstIndex(where: {$0.id == user.id}){
            var userObj = userArray[index]
            if user.isFavorite == true{
                userObj.isFavorite = false
                userArray[index] = userObj
                favorite.removeFirst(user.id)
                Utils.save(value: favorite, for: "favoriteArray")
                return false
            }
            else{
                userObj.isFavorite = true
                userArray[index] = userObj
                favorite.append(user.id)
                Utils.save(value: favorite, for: "favoriteArray")
                return true
            }
        }
        return false
    }
    
    /// Is Favorite for user id
    /// - Parameter userId: Used id
    func isFavorite(userId:Int) -> Bool{
        let favorite:[Int] = Utils.getValue(for: "favoriteArray") as? [Int] ?? []
        return favorite.filter({$0 == userId}) != [] ? true : false
    }
}
