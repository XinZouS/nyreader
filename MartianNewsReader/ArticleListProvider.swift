//
//  ArticleListProvider.swift
//  MartianNewsReader
//
//  Copyright © 2016 NYTimes. All rights reserved.
//

import Foundation

final class ArticleListProvider {
    
    convenience init() {
        self.init(articles: [])
    }
    
    init(articles: [AnyObject]) {
        assertionFailure("Not yet implemented.")
    }
    
    func articleCount() -> Int {
        assertionFailure("Not yet implemented.")

        return 0
    }
    
    func articleAtIndex(index: Int) -> AnyObject? {
        assertionFailure("Not yet implemented.")

        return nil
    }
}
