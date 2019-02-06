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
    
    fileprivate let toggleView = TranslateToggleView(title: L("article.ui.toggle.title"))
    fileprivate let tableView = UITableView()
    fileprivate let cellId = "articleCellId"
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = L("article.ui.title.news")
        view.backgroundColor = .white
        
        setupNavigationItems()
        setupToggleView()
        setupTableView()
        ApiServers.shared.getArticleListData(route: targetUrl) { [weak self] (pList) in
            if let list = pList {
                for (idx, item) in list.enumerated() {
                    self?.articles.append(Article(item, index: idx))
                }
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            }
        }
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
    }
    
    @objc private func changeLanguageButtonTapped() {
        let languageSelectVC = LanguageSelectorViewController()
        navigationController?.pushViewController(languageSelectVC, animated: true)
    }
}

extension ArticleListController: TranslateToggleDelegate {
    
    func toggleDidChanged(isOn: Bool) {
        let newReadingLanguage: ReadingLanguage = toggleView.isToggleOn() ? .martian : .english
        UserDefaults.setReadingLanguage(newReadingLanguage)
        
        print("--- should set all cells title translate text!!!")
        
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
