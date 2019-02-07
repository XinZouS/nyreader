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
    
    func addArticles(_ newArticles: [Article]) {
        self.articles.append(contentsOf: newArticles)
    }
    
    func loadArticlesBy(route: String, completion: @escaping([Article]) -> Void) {
        ApiServers.shared.getArticleListData(route: route) { [unowned self] (pList) in
            if let list = pList {
                for (idx, item) in list.enumerated() {
                    self.articles.append(Article(item, index: idx))
                }
            }
            completion(self.articles)
        }
    }
    
    func allArticles() -> [Article] {
        return articles
    }
    
    func articleCount() -> Int {
        return articles.count
    }
    
    func articleAtIndex(_ index: Int) -> Article? {
        if index < articles.count {
            return articles[index]
        }
        return nil
    }
}
