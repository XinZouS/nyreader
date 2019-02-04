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
        let margin: CGFloat = 5
        topImageView.contentMode = .scaleAspectFill
        addSubview(topImageView)
        topImageView.anchor(leadingAnchor, topAnchor, nil, bottomAnchor, lead: 0, top: margin, trail: 0, bottom: margin, width: 90, height: 0)
        
        titleLabel.contentMode = .topLeft
        titleLabel.textAlignment = .natural
        titleLabel.numberOfLines = 2
        titleLabel.font = UIFont.boldSystemFont(ofSize: 14)
        addSubview(titleLabel)
        titleLabel.anchor(topImageView.trailingAnchor, topAnchor, trailingAnchor, bottomAnchor, lead: 10, top: margin, trail: margin, bottom: margin, width: 0, height: 0)
    }
    
    private func updateArticleUI() {
        if let title = article?.title {
            titleLabel.text = title
        }
        if let url = article?.getTitleImageURL() {
            print("geetttt url = \(url.absoluteString)")
            ApiServers.shared.getImageWith(url: url) { (image) in
                if let img = image {
                    DispatchQueue.main.async {
                        self.topImageView.image = img
                    }
                }
            }
        }
    }

}
