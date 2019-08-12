//
//  URLSessionHTTPClient.swift
//  EssentialFeedFramework
//
//  Created by Kelvin Fok on 12/8/19.
//  Copyright © 2019 Kelvin Fok. All rights reserved.
//

import Foundation

public class URLSessionHTTPClient: HTTPClient {
    
    private let session: URLSession
    
    public init(session: URLSession = .shared) {
        self.session = session
    }
    
    private struct UnexpectedValuesRepresentation: Error {}
    
    public func get(from url: URL, completion: @escaping (HTTPClientResult) -> Void) {
        session.dataTask(with: url) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
            } else if let data = data,
                let response = response as? HTTPURLResponse {
                completion(.success(data, response))
            } else {
                let unexpectedError = UnexpectedValuesRepresentation()
                completion(.failure(unexpectedError))
            }
            }.resume()
    }
}
