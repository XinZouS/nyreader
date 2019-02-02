//
//  ArticleListProvider.swift
//  MartianNewsReader
//
//  Copyright © 2017 NYTimes. All rights reserved.
//

import Foundation

final class ArticleListProvider {
    
    static let shared = ArticleListProvider()
    
    fileprivate var articles: [Article] = []
    
    
    private convenience init() {
        self.init(articles: [])
    }
    
    init(articles: [Article]) {
        self.articles.append(contentsOf: articles)
    }
    
    func articleCount() -> Int {
        return articles.count
    }
    
    func articleAtIndex(_ index: Int) -> Article? {
        
        
        
        return nil
    }
}
