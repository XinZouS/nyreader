//
//  ArticleListController.swift
//  MartianNewsReader
//
//  Copyright © 2017 NYTimes. All rights reserved.
//

import UIKit

final class ArticleListController: UIViewController {
    
    fileprivate let CellIdentifier = "Cell"

    fileprivate let articleListProvider: ArticleListProvider
    
    
    override init() {
        super.init()
        self.articleListProvider = ArticleListProvider()
    }
    
    required init?(coder: NSCoder) {
        self.articleListProvider = ArticleListProvider()
        
        super.init(coder: coder)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articleListProvider.articleCount()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier, for: indexPath)
        
        let _ = articleListProvider.articleAtIndex(indexPath.row)
        
        assertionFailure("Not yet implemented.")
        
        return cell
    }
}
