//
//  FeedLoader.swift
//  EssentialFeedFramework
//
//  Created by Kelvin Fok on 14/5/19.
//  Copyright © 2019 Kelvin Fok. All rights reserved.
//

import Foundation

public enum LoadFeedResult {
    case success([FeedItem])
    case failure(Error)
}

public protocol FeedLoader {
    func load(completion: @escaping (LoadFeedResult) -> Void)
}
