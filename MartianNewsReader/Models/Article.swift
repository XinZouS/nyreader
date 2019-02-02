//
//  Article.swift
//  MartianNewsReader
//
//  Created by Xin Zou on 2/2/19.
//  Copyright © 2019 NYTimes. All rights reserved.
//

import Foundation
import UIKit

struct Article {
    
    let title: String
    let titleImageUrlStr: String
    let content: String
    
    init(title: String, titleImageUrlStr: String, content: String) {
        self.title = title
        self.titleImageUrlStr = titleImageUrlStr
        self.content = content
    }
    
    func getTitleImage() -> UIImage? {
        // TODO: fetch image
        return UIImage()
    }
    
}
