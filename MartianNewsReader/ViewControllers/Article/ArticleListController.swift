//
//  ArticleListController.swift
//  MartianNewsReader
//
//  Copyright © 2017 NYTimes. All rights reserved.
//

import UIKit

final class ArticleListController: UIViewController {
    
    fileprivate var articles: [Article] = []
    
    fileprivate let toggleView = TranslateToggleView(title: L("article.ui.toggle.title"))
    fileprivate let refresher = UIRefreshControl()
    fileprivate let tableView = UITableView()
    fileprivate let cellId = "articleCellId"
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = L("article.ui.title.news")
        view.backgroundColor = .white
        
        setupNavigationItems()
        setupToggleView()
        setupTableView()
        
        NotificationCenter.default.addObserver(forName: Notification.Name.ArticleListProvider.ListUpdated, object: nil, queue: nil) { [unowned self] _ in
            let getArticles = ArticleListProvider.shared.allArticles()
            self.articles.removeAll()
            self.articles.append(contentsOf: getArticles)
            self.refreshTable()
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func setupNavigationItems() {
        var buttonTitle = ""
        switch UserDefaults.getAppLanguage() {
        case .martian:
            buttonTitle = L("article.change-language.martian.short")
        default: // English
            buttonTitle = L("article.change-language.english.short")
        }
        let changeLanguageButton = UIBarButtonItem(title: buttonTitle,
                                            style: .plain,
                                            target: self,
                                            action: #selector(changeLanguageButtonTapped))
        navigationItem.rightBarButtonItem = changeLanguageButton
    }
    
    private func setupToggleView() {
        view.addSubview(toggleView)
        let vs = view.safeAreaLayoutGuide
        toggleView.anchor(vs.leadingAnchor, vs.topAnchor, vs.trailingAnchor, nil, lead: 0, top: 0, trail: 0, bottom: 0, width: 0, height: 40)
        toggleView.layer.zPosition = 99 // toggleView on top of all layers
        toggleView.setToggleOn(UserDefaults.getReadingLanguage() == ReadingLanguage.martian)
        toggleView.delegate = self
    }
    
    private func setupTableView() {
        tableView.register(ArticleListCell.self, forCellReuseIdentifier: cellId)
        tableView.dataSource = self
        tableView.delegate = self
        view.addSubview(tableView)
        let vs = view.safeAreaLayoutGuide
        tableView.addConstraint(vs.leftAnchor, toggleView.bottomAnchor, vs.rightAnchor, vs.bottomAnchor)
        tableView.tableFooterView = UIView()
        
        refresher.attributedTitle = NSAttributedString(string: L("article.ui.table-refresher.title"))
        refresher.addTarget(self, action: #selector(refreshTable), for: .valueChanged)
        tableView.addSubview(refresher)
    }
    
    @objc private func changeLanguageButtonTapped() {
        let languageSelectVC = LanguageSelectorViewController()
        navigationController?.pushViewController(languageSelectVC, animated: true)
    }
    
    @objc private func refreshTable() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.refresher.endRefreshing()
        }
    }
}

extension ArticleListController: TranslateToggleDelegate {
    
    func toggleDidChanged(isOn: Bool) {
        let newReadingLanguage: ReadingLanguage = toggleView.isToggleOn() ? .martian : .english
        UserDefaults.setReadingLanguage(newReadingLanguage)
        tableView.reloadData()
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
        if indexPath.row < articles.count {
            let articleVC = ArticleViewController(article: articles[indexPath.row])
            navigationController?.pushViewController(articleVC, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}
