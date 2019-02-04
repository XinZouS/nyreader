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
    
    func getTitleImage(completion: @escaping(UIImage?) -> Void) {
        let topImages = images.filter { (image) -> Bool in
            return image.isTopImage
        }
        if topImages.count > 0, let url = topImages.first?.getUrl() {
            ApiServers.shared.getImageWith(url: url) { (getImage) in
                completion(getImage)
            }
        } else {
            DLog("[ERROR] there is no topImage in the article [\(title)], images: \(images)")
            completion(nil)
        }
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
        self.isTopImage = (dictionary[ApiServers.ServerKey.topImage.rawValue] as? String)?.toBool() ?? false
        self.height = dictionary[ApiServers.ServerKey.height.rawValue] as? CGFloat ?? 0
        self.width = dictionary[ApiServers.ServerKey.width.rawValue] as? CGFloat ?? 0
    }
    
    func getUrl() -> URL? {
        return URL(string: urlString)
    }
}
