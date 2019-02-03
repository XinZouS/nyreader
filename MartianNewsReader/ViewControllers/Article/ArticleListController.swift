//
//  ArticleListController.swift
//  MartianNewsReader
//
//  Copyright © 2017 NYTimes. All rights reserved.
//

import UIKit

final class ArticleListController: UIViewController {
    
    fileprivate var articles: [Article] = ArticleListProvider.shared.allArticles()
    
    
    fileprivate let tableView = UITableView()
    fileprivate let cellId = "articleCellId"
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        ApiServers.shared.getArticleListData { [weak self] (dictionary) in
            print("-------------------------")
        }
    }
    
    private func setupTableView() {
        tableView.register(ArticleListCell.self, forCellReuseIdentifier: cellId)
        tableView.dataSource = self
        tableView.delegate = self
        view.addSubview(tableView)
        let vs = view.safeAreaLayoutGuide
        tableView.addConstraint(vs.leftAnchor, vs.topAnchor, vs.rightAnchor, vs.bottomAnchor)
    }
    
}

extension ArticleListController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as? ArticleListCell {
            
            return cell
        }
        return UITableViewCell(frame: .zero)
    }
    
}

extension ArticleListController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //
    }
    
}
