//
//  EndToEndTests.swift
//  EssentialFeedFrameworkTests
//
//  Created by Kelvin Fok on 12/8/19.
//  Copyright © 2019 Kelvin Fok. All rights reserved.
//

import XCTest
import EssentialFeedFramework


class EndToEndTests: XCTestCase {

    func test_endToEndTestServerGETFeedResult_matchesFixedTestAccountData() {
        
        let results = getFeedResult()
        
        switch results {
        case .success(let items)?:
            XCTAssertEqual(items.count, 8, "expected 8 items in the test account feed")
            
            items.enumerated().forEach { (index, item) in
                XCTAssertEqual(item.id, expectedItem(at: index).id, "Unexpected item values at index \(index)")
            }
            
            
        case .failure(let error)?:
            XCTFail("Expected successful feed result, got \(error) instead")
        default: XCTFail("Expected successful feed result, got no results instead")
        }
    }
    
    private func expectedItem(at index: Int) -> FeedItem {
        return FeedItem(id: id(at: index),
                        description: nil,
                        location: nil,
                        imageURL: URL(string: "www.google.com")!)
    }
    
    private func id(at index: Int) -> UUID {
        let store = [
            "73A7F70C-75DA-4C2E-B5A3-EED40DC53AA6",
            "BA298A85-6275-48D3-8315-9C8F7C1CD109",
            "5A0D45B3-8E26-4385-8C5D-213E160A5E3C",
            "FF0ECFE2-2879-403F-8DBE-A83B4010B340",
            "DC97EF5E-2CC9-4905-A8AD-3C351C311001",
            "557D87F1-25D3-4D77-82E9-364B2ED9CB30",
            "A83284EF-C2DF-415D-AB73-2A9B8B04950B",
            "F79BD7F8-063F-46E2-8147-A67635C3BB01"
        ]
        let value = store[index]
        return UUID.init(uuidString: value)!
    }
    
    private func getFeedResult(file: StaticString = #file, line: UInt = #line) -> LoadFeedResult? {
        
        let testServerURL = URL(string: "https://essentialdeveloper.com/feed-case-study/test-api/feed")!
        let client = URLSessionHTTPClient(session: URLSession.init(configuration: .ephemeral))
        let loader = RemoteFeedLoader(url: testServerURL, client: client)
        trackForMemoryLeaks(instance: client, file: file, line: line)
        trackForMemoryLeaks(instance: loader, file: file, line: line)

        let exp = expectation(description: "wait for load completion")
        var receivedResult: LoadFeedResult?
        
        loader.load { (result) in
            receivedResult = result
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 8.0)
        
        return receivedResult
    }

}
