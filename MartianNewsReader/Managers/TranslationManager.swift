//
//  TranslationManager.swift
//  MartianNewsReader
//
//  Created by Xin Zou on 2/5/19.
//  Copyright © 2019 NYTimes. All rights reserved.
//

import Foundation

final class TranslationManager: NSObject {
    
    static let shared = TranslationManager()
    
    private override init() {
        super.init()
    }
    
    fileprivate let martianArticleCache = NSCache<NSString, Article>()
    
}

extension TranslationManager {
    
    /**
     * All words greater than 3 characters should be translated to the word "boinga"
     * Capitalization must be maintained
     * Punctuation within words (e.g. we'll) can be discarded, all other punctuation must be maintained.
     */
    func toMartianArticle(_ article: Article, completion: @escaping(Article) -> Void) {
        DispatchQueue.global(qos: .background).async { [unowned self] in
            let id = article.id
            let newTitle = self.toMartian(article.title)
            let newBody = self.toMartian(article.body)
            let martianArticle = Article(title: newTitle, images: [], body: newBody, id: id)
            self.martianArticleCache.setObject(martianArticle, forKey: NSString(string: id))
            
            completion(martianArticle)
        }
    }
    
    func toMartian(_ englishStr: String) -> String {
        let words = englishStr.words()
        print(words)
        return ""
    }
    
}
