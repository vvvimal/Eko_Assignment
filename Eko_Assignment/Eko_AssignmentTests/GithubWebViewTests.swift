//
//  GithubWebViewTests.swift
//  Eko_AssignmentTests
//
//  Created by Venugopalan, Vimal on 28/01/20.
//  Copyright © 2020 Venugopalan, Vimal. All rights reserved.
//

import XCTest
@testable import Eko_Assignment

class GithubWebViewTests: BaseTests {
    var vc: GithubWebViewController!

    var user: User {
        return
            User(login: "defunkt", id: 2, node_id: "MDQ6VXNlcjI=", avatar_url: "https://avatars0.githubusercontent.com/u/2?v=4", gravatar_id: "", url: "https://api.github.com/users/defunkt", html_url: "https://github.com/defunkt", followers_url: "https://api.github.com/users/defunkt/followers", following_url: "https://api.github.com/users/defunkt/following{/other_user}", gists_url: "https://api.github.com/users/defunkt/gists{/gist_id}", starred_url: "https://api.github.com/users/defunkt/starred{/owner}{/repo}", subscriptions_url: "https://api.github.com/users/defunkt/subscriptions", organizations_url: "https://api.github.com/users/defunkt/orgs", repos_url: "https://api.github.com/users/defunkt/repos", events_url: "https://api.github.com/users/defunkt/events{/privacy}", received_events_url: "https://api.github.com/users/defunkt/received_events", type: "User", site_admin: false)
    }
    
    override func setUp() {
        vc = createGithubWebViewController()
        vc.setUpWith(user: user)
        vc.loadViewIfNeeded()
    }
    
    override func tearDown() {
        vc = nil
    }
    
    /// Test load view of list view
    func testLoadView() {
        XCTAssertNotNil(vc)
        XCTAssertNotNil(vc.webView)
    }
    
    func testTitleView(){
        XCTAssertEqual(user.login, vc.title, "Title and username don't match")
    }
    
    func testWebViewLoad(){
        XCTAssertEqual(user.html_url, vc.webView.url?.absoluteString, "Webview url and user page dont match")
    }

}
