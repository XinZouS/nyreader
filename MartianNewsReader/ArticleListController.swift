//
//  ArticleListController.swift
//  MartianNewsReader
//
//  Copyright © 2016 NYTimes. All rights reserved.
//

import UIKit

final class ArticleListController: UITableViewController {
    private let CellIdentifier = "Cell"

    private let articleListProvider: ArticleListProvider
    
    override init(style: UITableViewStyle) {
        self.articleListProvider = ArticleListProvider()
        
        super.init(style:style)
    }
    
    required init?(coder: NSCoder) {
        self.articleListProvider = ArticleListProvider()
        
        super.init(coder: coder)
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articleListProvider.articleCount()
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(CellIdentifier, forIndexPath: indexPath)
        
        let _ = articleListProvider.articleAtIndex(indexPath.row)
        
        assertionFailure("Not yet implemented.")
        
        return cell
    }
}
