//
//  RemoteFeedLoader.swift
//  EssentialFeed
//
//  Created by Kelvin Fok on 26/6/19.
//  Copyright © 2019 Kelvin Fok. All rights reserved.
//

import Foundation

public final class RemoteFeedLoader: FeedLoader {
    
    private let url: URL
    private let client: HTTPClient
    
    public enum Error: Swift.Error {
        case connectivity
        case invalidData
    }
    
    public typealias Result = LoadFeedResult
    
    public init(url: URL, client: HTTPClient) {
        self.client = client
        self.url = url
    }
    
    public func load(completion: @escaping (Result) -> Void) {
        client.get(from: url) { [weak self] result in
            guard self != nil else { return }
            switch result {
            case .success(let data, let response):
                let result = FeedItemsMapper.map(data, from: response)
                completion(result)
            case .failure:
                completion(.failure(Error.connectivity))
            }
        }
    }
}
