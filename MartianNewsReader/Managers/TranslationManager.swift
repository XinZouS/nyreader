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
    
    fileprivate let martainLowerCased = "boinga"
    fileprivate let martainCapitalized = "Boinga"
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
        let scalars: [UnicodeScalar] = Array(englishStr.unicodeScalars)
        var fast = 0
        var slow = 0
        var result = ""
        
        while slow <= fast, fast < scalars.count, slow < scalars.count {
            
            // 1. finding words and jump over ' inside words
            if CharacterSet.alphanumerics.contains(scalars[fast]) {
                slow = fast
                while (fast < scalars.count && CharacterSet.alphanumerics.contains(scalars[fast]))
                    || (fast < scalars.count && scalars[fast] == "'" && fast + 1 < scalars.count && CharacterSet.alphanumerics.contains(scalars[fast + 1])) {
                        fast += 1
                }
                if fast - slow > 3 {
                    if slow < scalars.count && CharacterSet.uppercaseLetters.contains(scalars[slow]) {
                        result.append(martainCapitalized)
                    } else {
                        result.append(martainLowerCased)
                    }
                    if fast < scalars.count {
                        result.append("\(scalars[fast])")
                    }
                    slow = fast + 1
                    
                } else {
                    while slow < scalars.count && slow <= fast {
                        result.unicodeScalars.append(scalars[slow])
                        slow += 1
                    }
                }
            // 2. finding punctuations: , . ; ! ? + - ( ) ...
            } else {
                while slow < scalars.count && slow <= fast {
                    result.unicodeScalars.append(scalars[slow])
                    slow += 1
                }
            }
            fast += 1
        }
        
        return result
    }
    
}
