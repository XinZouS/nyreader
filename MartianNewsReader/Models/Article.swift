//
//  Article.swift
//  MartianNewsReader
//
//  Created by Xin Zou on 2/2/19.
//  Copyright © 2019 NYTimes. All rights reserved.
//

import Foundation
import UIKit

class Article {
    
    let title: String
    let images: [ArticleImage]
    let body: String
    
    init(title: String, images: [ArticleImage], body: String) {
        self.title = title
        self.images = images
        self.body = body
    }
    
    init(_ dictionary: [String: Any]) {
        self.title = dictionary[ApiServers.ServerKey.title.rawValue] as? String ?? ""
        self.body  = dictionary[ApiServers.ServerKey.body.rawValue] as? String ?? ""
        
        var imgs: [ArticleImage] = []
        let getImgArray = dictionary[ApiServers.ServerKey.images.rawValue] as? [[String:Any]] ?? []
        for getImg in getImgArray {
            imgs.append(ArticleImage(getImg))
        }
        self.images = imgs
    }
        
    func getTitleImage() -> ArticleImage? {
        for img in images {
            if img.isTopImage {
                return img
            }
        }
        return nil
    }
    
    /**
     * All words greater than 3 characters should be translated to the word "boinga"
     * Capitalization must be maintained
     * Punctuation within words (e.g. we'll) can be discarded, all other punctuation must be maintained.
     */
    func getMartian() -> String {
        
    }
}

struct ArticleImage {
    let urlString: String
    let isTopImage: Bool
    let height: CGFloat
    let width: CGFloat
    
    init(url: String, isTop: Bool, height: CGFloat, width: CGFloat) {
        self.urlString = url
        self.isTopImage = isTop
        self.height = height
        self.width = width
    }
    
    init(_ dictionary: [String: Any]) {
        self.urlString = dictionary[ApiServers.ServerKey.url.rawValue] as? String ?? ""
        if let isTop = dictionary[ApiServers.ServerKey.topImage.rawValue] as? Int {
            self.isTopImage = String(isTop).isTrue()
        } else {
            self.isTopImage = false
        }
        self.height = dictionary[ApiServers.ServerKey.height.rawValue] as? CGFloat ?? 0
        self.width = dictionary[ApiServers.ServerKey.width.rawValue] as? CGFloat ?? 0
    }
    
    func getUrl() -> URL? {
        return URL(string: urlString)
    }
}
