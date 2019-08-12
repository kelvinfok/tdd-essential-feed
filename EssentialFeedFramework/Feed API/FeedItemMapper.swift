//
//  FeedItemMapper.swift
//  EssentialFeedFramework
//
//  Created by Kelvin Fok on 14/7/19.
//  Copyright © 2019 Kelvin Fok. All rights reserved.
//

import Foundation

internal final class FeedItemsMapper {
    
    private enum Constants {
        static let OK_200 = 200
    }
    
    private struct Item: Decodable {
        let id: UUID
        let description: String?
        let location: String?
        let image: URL
        
        var item: FeedItem {
            return FeedItem(id: id, description: description, location: location, imageURL: image)
        }
    }
    
    private struct Root: Decodable {
        let items: [Item]
        var feed: [FeedItem] {
            return items.map { $0.item }
        }
    }
    
    internal static func map(_ data: Data, from response: HTTPURLResponse) -> RemoteFeedLoader.Result {
        
        guard response.statusCode == Constants.OK_200,
            let root = try? JSONDecoder().decode(Root.self, from: data) else {
                return .failure(RemoteFeedLoader.Error.invalidData)
        }
        
        return .success(root.feed)
    }
    
    /* Access Levels
     Open access and public access enable entities to be used within any source file from their defining module,
     and also in a source file from another module that imports the defining module.
     You typically use open or public access when specifying the public interface to a framework.
     The difference between open and public access is described below.
     
     Internal access enables entities to be used within any source file from their defining module,
     but not in any source file outside of that module.
     You typically use internal access when defining an app’s or a framework’s internal structure.
     
     File-private access restricts the use of an entity to its own defining source file.
     Use file-private access to hide the implementation details of a specific piece of functionality when those details are used within an entire file.
     
     Private access restricts the use of an entity to the enclosing declaration,
     and to extensions of that declaration that are in the same file.
     Use private access to hide the implementation details of a specific piece of
     functionality when those details are used only within a single declaration.
    */

}
