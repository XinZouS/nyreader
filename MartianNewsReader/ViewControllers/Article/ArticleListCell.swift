//
//  ArticleListCell.swift
//  MartianNewsReader
//
//  Created by Xin Zou on 2/2/19.
//  Copyright © 2019 NYTimes. All rights reserved.
//

import UIKit

class ArticleListCell: UITableViewCell {
    
    var article: Article? {
        didSet{
            updateArticleUI()
        }
    }
    
    let margin: CGFloat = 5
    let topImageView = UIImageView()
    let titleLabel = UILabel()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        updateArticleUI()
    }
    
    private func setupUI() {
        topImageView.contentMode = .scaleAspectFill
        topImageView.layer.masksToBounds = true
        addSubview(topImageView)
        topImageView.anchor(leadingAnchor, topAnchor, nil, bottomAnchor, lead: margin, top: margin, trail: 0, bottom: margin, width: 90, height: 0)
        
        titleLabel.numberOfLines = 3
        titleLabel.contentMode = .topLeft
        titleLabel.textAlignment = .natural
        titleLabel.font = UIFont.boldSystemFont(ofSize: 14)
        addSubview(titleLabel)
        titleLabel.anchor(topImageView.trailingAnchor, topAnchor, trailingAnchor, bottomAnchor, lead: margin * 2, top: margin, trail: margin * 2, bottom: margin, width: 0, height: 0)
    }
    
    private func updateArticleUI() {
        guard let article = article else { return }
        titleLabel.text = article.title
        
        if let url = article.getTitleImageURL() {
            ApiServers.shared.getImageWith(url: url) { [weak self] (image) in
                if let img = image {
                    DispatchQueue.main.async {
                        self?.topImageView.image = img
                    }
                }
            }
        }
    }

}
