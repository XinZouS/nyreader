//
//  ArticleListProviderTests.swift
//  MartianNewsReader
//
//  Copyright © 2017 NYTimes. All rights reserved.
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
    
    func testPunctuation() {
        let articles = [["title": "Facebook plans to raise $10.6 billion in mega IPO", "body": "I'll buy that for a dollar!", "images": []]]

        let articleListProvider = ArticleListProvider(articles: articles as [AnyObject])
        
        guard let article = articleListProvider.articleAtIndex(0) else { XCTFail("Article provider should return an article."); return }

        assertArticleHasMartianTitleText(article, expectedText: "Boinga boinga to boinga $boinga boinga in boinga IPO")
        assertArticleHasMartianBodyText(article, expectedText: "Boinga buy boinga for a boinga!")
    }
    
    func testCapitalization() {
        let articles = [["title": "New DARPA report on the internet", "body": "", "images": []]]
        
        let articleListProvider = ArticleListProvider(articles: articles as [AnyObject])
        
        guard let article = articleListProvider.articleAtIndex(0) else { XCTFail("Article provider should return an article."); return }
        
        assertArticleHasMartianTitleText(article, expectedText: "New BOINGA boinga on the boinga")
        assertArticleHasMartianBodyText(article, expectedText: "")
    }
    
    func assertArticleHasMartianTitleText(_ article: AnyObject, expectedText: String) {
        assertionFailure("Not yet implemented.")
    }
    
    func assertArticleHasMartianBodyText(_ article: AnyObject, expectedText: String) {
        assertionFailure("Not yet implemented.")
    }
}
