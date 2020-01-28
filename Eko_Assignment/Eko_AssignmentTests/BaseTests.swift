//
//  BaseTests.swift
//  Eko_AssignmentTests
//
//  Created by Venugopalan, Vimal on 28/01/20.
//  Copyright © 2020 Venugopalan, Vimal. All rights reserved.
//

import XCTest
@testable import Eko_Assignment

class BaseTests: XCTestCase {
    var mainStoryboard: UIStoryboard {
        return UIStoryboard(name: "Main", bundle: nil)
    }
    
    /// Create user list view controller
    func createUserListViewController() -> UserListViewController {
        guard let vc = mainStoryboard.instantiateViewController(withIdentifier: "UserListViewController") as? UserListViewController else {
            fatalError("Unable to create UserListViewController from storyboard.")
        }
        return vc
    }
    
    /// Create github web view controller
    func createGithubWebViewController() -> GithubWebViewController {
        guard let vc = mainStoryboard.instantiateViewController(withIdentifier: "GithubWebViewController") as? GithubWebViewController else {
            fatalError("Unable to create GithubWebViewController from storyboard.")
        }
        return vc
    }
    
}
