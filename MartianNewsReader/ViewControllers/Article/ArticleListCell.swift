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
            setupArticle()
        }
    }
    
    let topImageView = UIImageView()
    let titleLabel = UILabel()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
        setupArticle()
    }
    
    private func setupUI() {
        let margin: CGFloat = 5
        topImageView.contentMode = .scaleAspectFill
        addSubview(topImageView)
        topImageView.anchor(leadingAnchor, topAnchor, nil, bottomAnchor, lead: 0, top: margin, trail: 0, bottom: margin, width: 70, height: 0)
        
        titleLabel.textAlignment = .natural
        titleLabel.font = UIFont.boldSystemFont(ofSize: 16)
        addSubview(titleLabel)
        titleLabel.anchor(topImageView.trailingAnchor, topAnchor, trailingAnchor, bottomAnchor, lead: 10, top: margin, trail: margin, bottom: margin, width: 0, height: 0)
    }
    
    private func setupArticle() {
        if let title = article?.title {
            titleLabel.text = title
        }
        article?.getTitleImage(completion: { [weak self] (image) in
            if let img = image {
                DispatchQueue.main.async {
                    self?.imageView?.image = img
                }
            }
        })
    }

}
