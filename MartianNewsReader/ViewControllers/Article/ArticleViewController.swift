//
//  ArticleViewController.swift
//  MartianNewsReader
//
//  Copyright © 2017 NYTimes. All rights reserved.
//

import UIKit

final class ArticleViewController: UIViewController {
    
    fileprivate let article: Article?
    
    fileprivate let toggleContainerView = TranslateToggleView(title: L("article.ui.toggle.title"))
    fileprivate let toggleContainerViewHeigh: CGFloat = 40
    fileprivate var toggleContainerTopConstraint: NSLayoutConstraint?
    fileprivate let imageView = UIImageView()
    fileprivate var imageViewTopConstraint: NSLayoutConstraint?
    fileprivate var imageViewHeighConstraint: NSLayoutConstraint?
    fileprivate var imageViewHeigh: CGFloat = 360
    fileprivate let titleLabel = UILabel()
    fileprivate var titleLabelHeigh: CGFloat = 40
    fileprivate let textView = UITextView()
    fileprivate var textViewContentOffsetY: CGFloat = 0
    
    init(article: Article) {
        self.article = article
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        self.article = nil
        super.init(coder: coder)
    }
    
    
    // MARK: - view cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupToggleView()
        setupTextView()
        setupTitleViews()
        displayArticle()
    }
    
    private func setupToggleView() {
        view.addSubview(toggleContainerView)
        let vs = view.safeAreaLayoutGuide
        toggleContainerView.anchor(vs.leadingAnchor, vs.topAnchor, vs.trailingAnchor, nil, lead: 0, top: 0, trail: 0, bottom: 0, width: 0, height: toggleContainerViewHeigh)
        toggleContainerView.layer.zPosition = 99 // toggleView on top of all layers
        toggleContainerView.setToggleOn(UserDefaults.getReadingLanguage() == ReadingLanguage.martian)
        toggleContainerView.delegate = self
    }
    
    private func setupTextView() {
        textView.delegate = self
        textView.isEditable = false
        textView.text = article?.body ?? ""
        textView.font = UIFont.systemFont(ofSize: 14)
        view.addSubview(textView)
        let vs = view.safeAreaLayoutGuide
        textView.anchor(vs.leadingAnchor, toggleContainerView.bottomAnchor, vs.trailingAnchor, vs.bottomAnchor, lead: 0, top: 0, trail: 0, bottom: 0)
    }
    
    private func setupTitleViews() {
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        let vs = view.safeAreaLayoutGuide
        view.addSubview(imageView)
        if let img = article?.getTitleImage()  {
            imageViewHeigh = (img.height / img.width) * view.bounds.width
        }
        imageView.addConstraint(vs.leftAnchor, nil, vs.rightAnchor, nil, left: 0, top: 0, right: 0, bottom: 0)
        imageViewHeighConstraint = imageView.heightAnchor.constraint(equalToConstant: imageViewHeigh)
        imageViewHeighConstraint?.isActive = true
        imageViewTopConstraint = imageView.topAnchor.constraint(equalTo: toggleContainerView.bottomAnchor, constant: 0)
        imageViewTopConstraint?.isActive = true
        
        if let url = article?.getTitleImage()?.getUrl() {
            ApiServers.shared.getImageWith(url: url) { [weak self] (image) in
                DispatchQueue.main.async {
                    self?.imageView.image = image
                }
            }
        }
        
        let titleMargin: CGFloat = 20
        titleLabel.backgroundColor = .white
        titleLabel.text = article?.title ?? ""
        titleLabel.font = UIFont.boldSystemFont(ofSize: 16)
        titleLabel.numberOfLines = 0
        view.addSubview(titleLabel)
        titleLabelHeigh = titleLabel.intrinsicContentSize.height + titleMargin * 2
        titleLabel.anchor(vs.leadingAnchor, imageView.bottomAnchor, vs.trailingAnchor, nil, lead: titleMargin, top: 0, trail: titleMargin, bottom: 0, width: 0, height: titleLabelHeigh)
        
        // set text offset to fit title contents
        let articleMargin: CGFloat = 10
        textViewContentOffsetY = imageViewHeigh  + titleLabelHeigh
        self.textView.contentInset = UIEdgeInsets(top: textViewContentOffsetY, left: articleMargin, bottom: articleMargin, right: articleMargin)
        self.textView.setContentOffset(CGPoint(x: 0, y: -textViewContentOffsetY), animated: false)
    }
    
    fileprivate func displayArticle() {
        guard let article = self.article else { return }
        
        let readingLanguage: ReadingLanguage = toggleContainerView.isToggleOn() ? .martian : .english
        if readingLanguage == .english {
            titleLabel.text = article.title
            textView.text = article.body
        } else {
            TranslationManager.shared.toMartianArticle(article) { [weak self] (martianArticle) in
                DispatchQueue.main.async {
                    self?.titleLabel.text = martianArticle.title
                    self?.textView.text = martianArticle.body
                }
            }
        }
    }
}

extension ArticleViewController: TranslateToggleDelegate {
    
    func toggleDidChanged(isOn: Bool) {
        let newReadingLanguage: ReadingLanguage = toggleContainerView.isToggleOn() ? .martian : .english
        UserDefaults.setReadingLanguage(newReadingLanguage)
        displayArticle()
    }
    
}

extension ArticleViewController: UITextViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        animateUpdateTitleContents(scrollView)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        animateUpdateTitleContents(scrollView)
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        animateUpdateTitleContents(scrollView)
    }
    
    private func animateUpdateTitleContents(_ scrollView: UIScrollView) {
        let y = scrollView.contentOffset.y
        if y < -textViewContentOffsetY { // enlarge title image
            imageViewHeighConstraint?.constant = max(imageViewHeigh, abs(y + titleLabelHeigh))
            
        } else if y <= titleLabelHeigh { // move up title image
            imageViewTopConstraint?.constant = -y - textViewContentOffsetY
            
        } else if y <= titleLabelHeigh + imageViewHeigh {
            imageViewTopConstraint?.constant = -(imageViewHeigh + titleLabelHeigh + toggleContainerViewHeigh)
        }
    }
}
