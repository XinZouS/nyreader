//
//  ArticleListController.swift
//  MartianNewsReader
//
//  Copyright © 2017 NYTimes. All rights reserved.
//

import UIKit

final class ArticleListController: UIViewController {
    
    let targetUrl = "http://mobile.public.ec2.nytimes.com.s3-website-us-east-1.amazonaws.com/candidates/content/v1/articles.plist"
    fileprivate var articles: [Article] = ArticleListProvider.shared.allArticles()
    
    
    fileprivate let tableView = UITableView()
    fileprivate let cellId = "articleCellId"
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        ApiServers.shared.getArticleListData(route: targetUrl) { [weak self] (pList) in
            if let list = pList {
                for item in list {
                    self?.articles.append(Article(item))
                }
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            }
        }
    }
    
    private func setupTableView() {
        tableView.register(ArticleListCell.self, forCellReuseIdentifier: cellId)
        tableView.dataSource = self
        tableView.delegate = self
        view.addSubview(tableView)
        let vs = view.safeAreaLayoutGuide
        tableView.addConstraint(vs.leftAnchor, vs.topAnchor, vs.rightAnchor, vs.bottomAnchor)
        tableView.tableFooterView = UIView()
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
            cell.article = articles[indexPath.row]
            cell.selectionStyle = .none
            return cell
        }
        return UITableViewCell(frame: .zero)
    }
    
}

extension ArticleListController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}
