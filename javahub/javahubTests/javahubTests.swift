//
//  javahubTests.swift
//  javahubTests
//
//  Created by Luiz Alberto on 12/11/17.
//  Copyright © 2017 Luiz Alberto. All rights reserved.
//

import XCTest
import Foundation
@testable import javahub

class javahubTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testDecodeRepositoriesJSON() {
        let decoder = JSONDecoder()
        let jsonPath = Bundle.main.path(forResource: "repositories", ofType: "json")
        let jsonData = try! Data(contentsOf: URL(fileURLWithPath: jsonPath!))
        let decoded = try! decoder.decode(JVHRepositoriesResponse.self, from: jsonData)
        
        assert(decoded.items?.count == 30)
    }
    
    func testDecodeUserJSON() {
        let decoder = JSONDecoder()
        let jsonPath = Bundle.main.path(forResource: "user", ofType: "json")
        let jsonData = try! Data(contentsOf: URL(fileURLWithPath: jsonPath!))
        let decoded = try! decoder.decode(JVHUser.self, from: jsonData)
        
        XCTAssertNotNil(decoded)
    }
    
    func testDecodePullRequestsJSON() {
        let decoder = JSONDecoder()
        let jsonPath = Bundle.main.path(forResource: "pullRequests", ofType: "json")
        let jsonData = try! Data(contentsOf: URL(fileURLWithPath: jsonPath!))
        let decoded = try! decoder.decode([JVHPullRequest].self, from: jsonData)
        
        XCTAssertNotNil(decoded)
    }
    
    func testFixUrlWithUnnecessaryParameters() {
        let pathWithUnnecessaryParameters = "https://api.github.com/repos/ltsopensource/light-task-scheduler/pulls{/number}"
        let fixedPath = JVHGithubUrl.removeUnnecessaryParameters(from: pathWithUnnecessaryParameters)
        
        XCTAssertEqual("https://api.github.com/repos/ltsopensource/light-task-scheduler/pulls", fixedPath)
    }
    
    func testParsingGitHubLinkHeaderEntry() {
        let linkHeaderEntry = "<https://api.github.com/search/repositories?q=language%3AJava&sort=stars&page=1>; rel=\"first\", <https://api.github.com/search/repositories?q=language%3AJava&sort=stars&page=33>; rel=\"prev\""
        let parsedLink = JVHGithubLinkHeaderParser.parseGithubLinkHeader(input: linkHeaderEntry)
        
        XCTAssertNotNil(parsedLink["first"])
        XCTAssertNotNil(parsedLink["prev"])
    }
    
    func testShouldReturnEmptyDictionaryIfLinkHeaderEntryIsEmpty() {
        let linkHeaderEntry = ""
        let parsedLink = JVHGithubLinkHeaderParser.parseGithubLinkHeader(input: linkHeaderEntry)
        
        XCTAssertEqual(0, parsedLink.keys.count)
    }
    
    func testShouldReturnDictionarWithOneValidItemIfLinkHeaderEntryContainsTowItemsWithOneInvalid() {
        let linkHeaderEntry = "<https://api.github.com/search/repositories?q=language%3AJava&sort=stars&page=1>, <https://api.github.com/search/repositories?q=language%3AJava&sort=stars&page=33>; rel=\"prev\""
        let parsedLink = JVHGithubLinkHeaderParser.parseGithubLinkHeader(input: linkHeaderEntry)
        
        XCTAssertEqual(1, parsedLink.keys.count)
    }
    
    func testFixUrlWithoutUnnecessaryParameters() {
        let pathWithUnnecessaryParameters = "https://api.github.com/repos/ltsopensource/light-task-scheduler/pulls"
        let fixedPath = JVHGithubUrl.removeUnnecessaryParameters(from: pathWithUnnecessaryParameters)
        
        XCTAssertEqual("https://api.github.com/repos/ltsopensource/light-task-scheduler/pulls", fixedPath)
    }
    
    func testShouldReturnSearchCorrectUrlOfRepository() {
        let requiredGithubSearchQuery = "https://api.github.com/search/repositories?q=language:java&sort=stars&page=1"
        let githubSearchUrl = JVHGithubUrl.repositories("java", 1).path
        
        XCTAssertEqual(requiredGithubSearchQuery, githubSearchUrl.absoluteString)
    }
    
    func testShouldReturnPullsCorrectUrl() {
        let requiredGithubPullsPath = "https://api.github.com/repos/ltsopensource/light-task-scheduler/pulls"
        let githubPullsPath = JVHGithubUrl.pulls("https://api.github.com/repos/ltsopensource/light-task-scheduler").path
        
        XCTAssertEqual(requiredGithubPullsPath, githubPullsPath.absoluteString)
    }
}
