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
        let targetUrl = "http://mobile.public.ec2.nytimes.com.s3-website-us-east-1.amazonaws.com/candidates/content/v1/articles.plist"
        loadArticlesBy(route: targetUrl) { _ in
        }
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
            NotificationCenter.default.post(name: Notification.Name.ArticleListProvider.ListUpdated, object: nil)
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
