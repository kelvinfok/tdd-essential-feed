//
//  HTTPClient.swift
//  EssentialFeed
//
//  Created by Kelvin Fok on 14/7/19.
//  Copyright © 2019 Kelvin Fok. All rights reserved.
//

import Foundation

public enum HTTPClientResult {
    case success(Data, HTTPURLResponse)
    case failure(Error)
}

public protocol HTTPClient {
    func get(from url: URL, completion: @escaping (HTTPClientResult) -> Void)
}
