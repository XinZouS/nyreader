//
//  ArticleListProviderTests.swift
//  MartianNewsReader
//
//  Copyright © 2016 NYTimes. All rights reserved.
//

import XCTest

class ArticleListProviderTests: XCTestCase {
    
    func testArticleDataIsTranslated() {
        let articles = [["title": "Welcome to the Test!", "body": "Or if you'd rather, check out The New York Times online.", "images": []]]
        
        let articleListProvider = ArticleListProvider(articles: articles as [AnyObject])
        
        guard let article = articleListProvider.articleAtIndex(0) else { XCTFail("Article provider should return an article."); return }
        
        assertArticleHasMartianTitleText(article, expectedText: "Boinga to the Boinga!")
        assertArticleHasMartianBodyText(article, expectedText: "Or if boinga boinga, boinga out The New Boinga Boinga boinga.")
    }
    
    func assertArticleHasMartianTitleText(_ article: AnyObject, expectedText: String) {
        assertionFailure("Not yet implemented.")
    }
    
    func assertArticleHasMartianBodyText(_ article: AnyObject, expectedText: String) {
        assertionFailure("Not yet implemented.")
    }
}
