//
//  UserListViewTests.swift
//  Eko_AssignmentTests
//
//  Created by Venugopalan, Vimal on 28/01/20.
//  Copyright © 2020 Venugopalan, Vimal. All rights reserved.
//

import XCTest
@testable import Eko_Assignment

class UserListViewTests: BaseTests {
    
    var vc: UserListViewController!

    var users: [User] {
        return [
            User(login: "mojombo", id: 1, node_id: "MDQ6VXNlcjE=", avatar_url: "https://avatars0.githubusercontent.com/u/1?v=4", gravatar_id: "", url: "https://api.github.com/users/mojombo", html_url: "https://github.com/mojombo", followers_url: "https://api.github.com/users/mojombo/followers", following_url: "https://api.github.com/users/mojombo/following{/other_user}", gists_url: "https://api.github.com/users/mojombo/gists{/gist_id}", starred_url: "https://api.github.com/users/mojombo/starred{/owner}{/repo}", subscriptions_url: "https://api.github.com/users/mojombo/subscriptions", organizations_url: "https://api.github.com/users/mojombo/orgs", repos_url: "https://api.github.com/users/mojombo/repos", events_url: "https://api.github.com/users/mojombo/events{/privacy}", received_events_url: "https://api.github.com/users/mojombo/received_events", type: "User", site_admin: false),
            User(login: "defunkt", id: 2, node_id: "MDQ6VXNlcjI=", avatar_url: "https://avatars0.githubusercontent.com/u/2?v=4", gravatar_id: "", url: "https://api.github.com/users/defunkt", html_url: "https://github.com/defunkt", followers_url: "https://api.github.com/users/defunkt/followers", following_url: "https://api.github.com/users/defunkt/following{/other_user}", gists_url: "https://api.github.com/users/defunkt/gists{/gist_id}", starred_url: "https://api.github.com/users/defunkt/starred{/owner}{/repo}", subscriptions_url: "https://api.github.com/users/defunkt/subscriptions", organizations_url: "https://api.github.com/users/defunkt/orgs", repos_url: "https://api.github.com/users/defunkt/repos", events_url: "https://api.github.com/users/defunkt/events{/privacy}", received_events_url: "https://api.github.com/users/defunkt/received_events", type: "User", site_admin: false),
            User(login: "pjhyett", id: 3, node_id: "MDQ6VXNlcjM=", avatar_url: "https://avatars0.githubusercontent.com/u/2?v=4", gravatar_id: "", url: "https://api.github.com/users/pjhyett", html_url: "https://github.com/pjhyett", followers_url: "https://api.github.com/users/pjhyett/followers", following_url: "https://api.github.com/users/pjhyett/following{/other_user}", gists_url: "https://api.github.com/users/pjhyett/gists{/gist_id}", starred_url: "https://api.github.com/users/pjhyett/starred{/owner}{/repo}", subscriptions_url: "https://api.github.com/users/pjhyett/subscriptions", organizations_url: "https://api.github.com/users/pjhyett/orgs", repos_url: "https://api.github.com/users/pjhyett/repos", events_url: "https://api.github.com/users/pjhyett/events{/privacy}", received_events_url: "https://api.github.com/users/pjhyett/received_events", type: "User", site_admin: false)
        ]
    }
    
    override func setUp() {
        vc = createUserListViewController()
        vc.loadViewIfNeeded()
        
    }
    
    override func tearDown() {
        vc = nil
    }
    
    /// Test load view of list view
    func testLoadView() {
        XCTAssertNotNil(vc)
        XCTAssertNotNil(vc.tableView)
    }
    
    /// Test number of sections
    func testNumberOfSections() {
        XCTAssertEqual(vc.numberOfSections(in: vc.tableView), vc.viewModel.numberOfSections)
    }
    
    /// Test number of rows
    func testNumberOfRows() {
        for section in 0..<vc.numberOfSections(in: vc.tableView) {
            XCTAssertEqual(vc.tableView(vc.tableView, numberOfRowsInSection: section), vc.viewModel.numberOfRows(inSection: section))
        }
    }
    
    /// Test configure note cell
    func testConfigureUserCell() {
        for user in users {
            let cell = UserListViewCell(style: .default, reuseIdentifier: AppIdentifierStrings.kUserListViewCellReuseIdentifier)
            cell.user = user
            XCTAssertEqual(cell.nameLabel.text, user.login)
            XCTAssertEqual(cell.urlLabel.text, user.html_url)
            XCTAssertEqual(cell.accountTypeLabel.text, "Type: \(user.type)")
            XCTAssertEqual(cell.siteAdminStatusLabel.text, "Admin Status: \(user.site_admin)")
        }
    }
    
    /// Test cell for row at indexpath
    func testCellForRowAtIndexPath() {
        for section in 0..<vc.numberOfSections(in: vc.tableView) {
            for row in 0..<vc.tableView(vc.tableView, numberOfRowsInSection: section) {
                let indexPath = IndexPath(row: row, section: section)
                guard let cell = vc.tableView(vc.tableView, cellForRowAt: indexPath) as? UserListViewCell else {
                    return XCTFail("Incorrect cell type returned.")
                }
                let user = users[row]
                cell.user = user
                XCTAssertEqual(cell.nameLabel.text, user.login)
                XCTAssertEqual(cell.urlLabel.text, user.html_url)
                XCTAssertEqual(cell.accountTypeLabel.text, "Type: \(user.type)")
                XCTAssertEqual(cell.siteAdminStatusLabel.text, "Admin Status: \(user.site_admin)")
                XCTAssertNotNil(cell.avatarImageView.image)
            }
        }
    }
    
    /// Test cell for row at indexpath
    func testAddRemoveFavorite() {
        
        let waitForTableViewLoadExpectation = XCTestExpectation(description: "Wait for load table.")
        DispatchQueue.main.asyncAfter(deadline: .now() + 10.0) {
            waitForTableViewLoadExpectation.fulfill()
        }
        wait(for: [waitForTableViewLoadExpectation], timeout: 10.0)
        
        if vc.tableView.numberOfRows(inSection: 0) > 0 {
            let indexPath = IndexPath(row: 0, section: 0)
            guard let cell = vc.tableView(vc.tableView, cellForRowAt: indexPath) as? UserListViewCell else {
                return XCTFail("Incorrect cell type returned.")
            }
            let user = users[0]
            cell.user = user
            cell.delegate = vc
            XCTAssertEqual(cell.nameLabel.text, user.login)
            XCTAssertEqual(cell.urlLabel.text, user.html_url)
            XCTAssertEqual(cell.accountTypeLabel.text, "Type: \(user.type)")
            XCTAssertEqual(cell.siteAdminStatusLabel.text, "Admin Status: \(user.site_admin)")
            
            XCTAssertNotNil(cell.favoriteButton)
            // Add favorite .
            let addFavoriteExpectation = XCTestExpectation(description: "Waiting for add favorite button click action.")
            cell.favoriteButton.sendActions(for: .touchUpInside)
            DispatchQueue.main.asyncAfter(deadline: .now() + 10.0) {
                addFavoriteExpectation.fulfill()
            }
            wait(for: [addFavoriteExpectation], timeout: 10.0)
            XCTAssertNotNil(self.vc.alert)
            XCTAssertEqual(self.vc.alert?.title, "Success")
            XCTAssertEqual(self.vc.alert?.message, "Added to favorites")
            
            // Remove favorite .
            let removeFavoriteExpectation = XCTestExpectation(description: "Waiting for remove favorite button click action.")
            cell.favoriteButton.sendActions(for: .touchUpInside)
            DispatchQueue.main.asyncAfter(deadline: .now() + 10.0) {
                removeFavoriteExpectation.fulfill()
            }
            wait(for: [removeFavoriteExpectation], timeout: 10.0)
            XCTAssertNotNil(self.vc.alert)
            XCTAssertEqual(self.vc.alert?.title, "Success")
            XCTAssertEqual(self.vc.alert?.message, "Removed to favorites")
        }
    }
    
    func testSelectCell(){
        
        let waitForTableViewLoadExpectation = XCTestExpectation(description: "Wait for load table.")
        DispatchQueue.main.asyncAfter(deadline: .now() + 10.0) {
            waitForTableViewLoadExpectation.fulfill()
        }
        wait(for: [waitForTableViewLoadExpectation], timeout: 10.0)
        
        if vc.tableView.numberOfRows(inSection: 0) > 0 {
            let indexPath = IndexPath(row: 0, section: 0)
            vc.tableView.selectRow(at: indexPath, animated: true, scrollPosition: .bottom)
            vc.tableView.delegate?.tableView!(vc.tableView, didSelectRowAt: indexPath)
            
            let waitForTableViewLoadExpectation = XCTestExpectation(description: "Wait for detail.")
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                waitForTableViewLoadExpectation.fulfill()
            }
            wait(for: [waitForTableViewLoadExpectation], timeout: 2)
        }
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}

class UserListViewModelTests: BaseTests {
    var users: [User]!
    var vm: UserListViewModel!
    
    override func setUp() {
        var users = [User]()
        var userName = ""
        for idx in 1...10 {
            userName = "testUser_\(idx)"
            let user = User(login: userName, id: idx, node_id: "testId\(idx)=", avatar_url: "https://avatars0.githubusercontent.com/u/idx?v=4", gravatar_id: "", url: "https://api.github.com/users/\(userName)", html_url: "https://github.com/\(userName)", followers_url: "https://api.github.com/users/\(userName)/followers", following_url: "https://api.github.com/users/\(userName)/following{/other_user}", gists_url: "https://api.github.com/users/\(userName)/gists{/gist_id}", starred_url: "https://api.github.com/users/\(userName)/starred{/owner}{/repo}", subscriptions_url: "https://api.github.com/users/\(userName)/subscriptions", organizations_url: "https://api.github.com/users/\(userName)/orgs", repos_url: "https://api.github.com/users/\(userName)/repos", events_url: "https://api.github.com/users/\(userName)/events{/privacy}", received_events_url: "https://api.github.com/users/\(userName)/received_events", type: "User", site_admin: false)
            users.append(user)
        }
        self.users = users
        vm = UserListViewModel()
        vm.userArray = users
    }
    
    override func tearDown() {
        vm = nil
        users = nil
    }
    
    /// test instance of list view model
    func testInstantiation() {
        XCTAssertNotNil(vm.userArray)
        XCTAssertEqual(vm.userArray.count, 10)
    }
    
    /// test number of section method
    func testNumberOfSection() {
        XCTAssertEqual(vm.numberOfSections, 1)
    }
    
    /// test number of row
    func testNumberOfRows() {
        XCTAssertEqual(vm.numberOfRows(inSection: 0), users.count)
    }

}
