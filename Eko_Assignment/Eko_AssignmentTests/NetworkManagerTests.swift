//
//  NetworkManagerTests.swift
//  Eko_AssignmentTests
//
//  Created by Venugopalan, Vimal on 28/01/20.
//  Copyright © 2020 Venugopalan, Vimal. All rights reserved.
//

import XCTest
@testable import Eko_Assignment

struct RequestFailedRequest: BaseRequest {
    var params: [String : Any]? = [:]
    
    var httpMethod: HTTPMethod = .get
    
    var httpHeader: [String : String] = [:]
    
    
    var urlString: String {
        return "https://www.github.com/users?since=0"
    }
}

class NetworkManagerTests: XCTestCase {

    let userListGetManager = UserListGetManager()
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    /// Testing taglist API with an invalid url for failed response
    func testTagListResponseRequestFailed() {
        let expected = expectation(description: "Check request failed response")
        userListGetManager.getUserList(from: RequestFailedRequest(), completion: {
            result in
            switch result {
            case .success( _):
                XCTFail()
            case .failure(let error):
                expected.fulfill()
                XCTAssertEqual(error, APIError.requestFailed)
                XCTAssertEqual(error.message, "Request failed.")
            }
        })
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    /// Testing taglist API with an valid url for successful response
    func testTagListSuccessfulResponse() {
        let expected = expectation(description: "Check response is successful")
        userListGetManager.getUserList(from: UserListGetRequest(count: 0), completion: {
            result in
            switch result {
            case .success(let tagsArray):
                if tagsArray != nil{
                    expected.fulfill()
                }
            case .failure( _):
                XCTFail()
            }
        })
        waitForExpectations(timeout: 5, handler: nil)
    }
    
}
