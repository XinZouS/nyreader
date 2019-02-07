//
//  ArticleListProviderTests.swift
//  MartianNewsReader
//
//  Copyright © 2017 NYTimes. All rights reserved.
//

import XCTest
@testable import MartianNewsReader

class ArticleListProviderTest: XCTestCase {
    
    func testArticleDataIsTranslated() {
        let articles = [["title": "Welcome to the Test!", "body": "Or if you'd rather, check out The New York Times online.", "images": []]]
        let newArticle = Article(articles.first!, index: 0)
        ArticleListProvider.shared.addArticles([newArticle])
        guard let article = ArticleListProvider.shared.articleAtIndex(0) else { XCTFail("Article provider should return an article."); return }
        
        assertArticleHasMartianTitleText(article, expectedText: "Boinga to the Boinga!")
        assertArticleHasMartianBodyText(article, expectedText: "Or if boinga boinga, boinga out The New Boinga Boinga boinga.")
    }
    
    func testPunctuation() {
        let articles = [["title": "Facebook plans to raise $10.6 billion in mega IPO", "body": "I'll buy that for a dollar!", "images": []]]
        let newArticle = Article(articles.first!, index: 0)
        ArticleListProvider.shared.addArticles([newArticle])
        guard let article = ArticleListProvider.shared.articleAtIndex(0) else { XCTFail("Article provider should return an article."); return }
        
        assertArticleHasMartianTitleText(article, expectedText: "Boinga boinga to boinga $boinga boinga in boinga IPO")
        assertArticleHasMartianBodyText(article, expectedText: "Boinga buy boinga for a boinga!")
    }
    
    func testCapitalization() {
        let articles = [["title": "New DARPA report on the internet", "body": "", "images": []]]
        let newArticle = Article(articles.first!, index: 0)
        ArticleListProvider.shared.addArticles([newArticle])
        guard let article = ArticleListProvider.shared.articleAtIndex(0) else { XCTFail("Article provider should return an article."); return }
        
        assertArticleHasMartianTitleText(article, expectedText: "New BOINGA boinga on the boinga")
        assertArticleHasMartianBodyText(article, expectedText: "")
    }
    
    func assertArticleHasMartianTitleText(_ article: Article, expectedText: String) {
        XCTAssertEqual(article.title, expectedText)
    }
    
    func assertArticleHasMartianBodyText(_ article: Article, expectedText: String) {
        XCTAssertEqual(article.body, expectedText)
    }
    
}
