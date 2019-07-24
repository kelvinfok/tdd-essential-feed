//
//  URLSessionHTTPClientTests.swift
//  EssentialFeedFrameworkTests
//
//  Created by Kelvin Fok on 24/7/19.
//  Copyright © 2019 Kelvin Fok. All rights reserved.
//

import XCTest
import EssentialFeedFramework

protocol HTTPSession {
    func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> HTTPSessionTask
}

protocol HTTPSessionTask {
    func resume()
}

class URLSessionHTTPClient {
    
    private let session: HTTPSession
    
    init(session: HTTPSession) {
        self.session = session
    }
    
    func get(from url: URL, completion: @escaping (HTTPClientResult) -> Void) {
        session.dataTask(with: url) { (_, _, error) in
            if let error = error {
                completion(.failure(error))
            }
        }.resume()
    }
}

class URLSessionHTTPClientTests: XCTestCase {
    
    private class FakeURLSessionDataTask: HTTPSessionTask {
        func resume() {}
    }
    
    private class SpyURLSessionDataTask: HTTPSessionTask {
        var resumeCount = 0
        func resume() {
            resumeCount += 1
        }
    }
    
    private class HTTPSessionSpy: HTTPSession {
        
        private var stubs = [URL: Stub]()
        
        private struct Stub {
            let task: HTTPSessionTask
            let error: Error?
        }
        
        func stub(url: URL, task: HTTPSessionTask, error: Error? = nil) {
            stubs[url] = Stub(task: task, error: error)
        }
        
        func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> HTTPSessionTask {
            
            guard let stub = stubs[url] else {
                fatalError("Couldn't find stub for \(url)")
            }
            
            completionHandler(nil, nil, stub.error)
            
            return stub.task
        }
    }
    
    func test_getFromURL_resumesDataTaskWithURL() {
        let session = HTTPSessionSpy()
        let url = URL.init(string: "https://www.google.com")!
        let task = SpyURLSessionDataTask.init()
        session.stub(url: url, task: task)
        let sut = URLSessionHTTPClient(session: session)
        sut.get(from: url) { _ in }
        XCTAssertEqual(task.resumeCount, 1)
    }
    
    func test_getFromURL_failsOnRequestError() {
        let url = URL.init(string: "https://www.google.com")!
        let error = NSError(domain: "", code: 0, userInfo: nil)
        let session = HTTPSessionSpy()
        let task = FakeURLSessionDataTask()
        session.stub(url: url, task: task, error: error)
        let sut = URLSessionHTTPClient(session: session)
        
        let exp = expectation(description: "wait for completion")
        
        sut.get(from: url) { result in
            switch result {
            case let .failure(receivedError as NSError):
                XCTAssertEqual(receivedError, error)
            default:
                XCTFail("Expected failure with error \(error), got \(result) instead.")
            }
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1.0)
    }

}
