//
//  UserListViewModel.swift
//  Eko_Assignment
//
//  Created by Venugopalan, Vimal on 25/01/20.
//  Copyright © 2020 Venugopalan, Vimal. All rights reserved.
//

import UIKit

class UserListViewModel: NSObject {

    private var userArray:[User] = []
    
    let userListGetManager = UserListGetManager()
    
    func getUserList(completionHandler:@escaping (Result<Bool, APIError>) -> Void){
        let userListGetRequest = UserListGetRequest(count: userArray.count)
        
        userListGetManager.getPhotoList(from: userListGetRequest, completion: {[weak self] result in
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
    
    func userCount() -> Int{
        userArray.count
    }
    
    func changeFavoriteStatus(userId: Int){
        var favorite:[Int] = Utils.getValue(for: "favoriteArray") as? [Int] ?? []
        if favorite.filter({$0 == userId}) != [] {
            favorite.removeFirst(userId)
        }
        else{
            favorite.append(userId)
        }
        Utils.save(value: favorite, for: "favoriteArray")
    }
    
    func isFavorite(userId:Int) -> Bool{
        let favorite:[Int] = Utils.getValue(for: "favoriteArray") as? [Int] ?? []

        if favorite.filter({$0 == userId}) != [] {
            return true
        }
        return false
    }
}
