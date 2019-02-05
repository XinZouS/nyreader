//
//  ArticleViewController.swift
//  MartianNewsReader
//
//  Copyright © 2017 NYTimes. All rights reserved.
//

import UIKit

final class ArticleViewController: UIViewController {
    
    fileprivate let article: Article?
    
    fileprivate let toggle = UISwitch()
    fileprivate let toggleContainerView = UIView()
    fileprivate let toggleContainerViewHeigh: CGFloat = 40
    fileprivate var toggleContainerTopConstraint: NSLayoutConstraint?
    fileprivate let imageView = UIImageView()
    fileprivate var imageViewTopConstraint: NSLayoutConstraint?
    fileprivate let titleLabel = UILabel()
    fileprivate let textView = UITextView()
    
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
        setupTextView()
        setupTitleViews()
        setupToggleView()
    }
    
    private func setupTextView() {
        textView.delegate = self
        textView.isEditable = false
        textView.text = article?.body ?? ""
        textView.font = UIFont.systemFont(ofSize: 14)
        view.addSubview(textView)
        let vs = view.safeAreaLayoutGuide
        textView.anchor(vs.leadingAnchor, vs.topAnchor, vs.trailingAnchor, vs.bottomAnchor, lead: 0, top: toggleContainerViewHeigh, trail: 0, bottom: 0)
    }
    
    private func setupTitleViews() {
        imageView.contentMode = .scaleAspectFit
        let vs = view.safeAreaLayoutGuide
        view.addSubview(imageView)
        var imgViewH: CGFloat = 160
        if let img = article?.getTitleImage()  {
            imgViewH = (img.height / img.width) * view.bounds.width
        }
        imageView.addConstraint(vs.leftAnchor, nil, vs.rightAnchor, nil, left: 0, top: 0, right: 0, bottom: 0, width: 0, height: imgViewH)
        imageViewTopConstraint = imageView.topAnchor.constraint(equalTo: vs.topAnchor, constant: toggleContainerViewHeigh)
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
        let lbH = titleLabel.intrinsicContentSize.height + titleMargin
        titleLabel.anchor(vs.leadingAnchor, imageView.bottomAnchor, vs.trailingAnchor, nil, lead: titleMargin, top: 0, trail: titleMargin, bottom: 0, width: 0, height: lbH)
        
        // set text offset to fit title contents
        let articleMargin: CGFloat = 10
        let topOffset: CGFloat = imgViewH  + lbH
        self.textView.contentInset = UIEdgeInsets(top: topOffset, left: articleMargin, bottom: articleMargin, right: articleMargin)
        self.textView.setContentOffset(CGPoint(x: 0, y: -topOffset), animated: false)
    }
    
    private func setupToggleView() {
        toggleContainerView.backgroundColor = .white
        view.addSubview(toggleContainerView)
        let vs = view.safeAreaLayoutGuide
        toggleContainerView.anchor(vs.leadingAnchor, vs.topAnchor, vs.trailingAnchor, nil, lead: 0, top: 0, trail: 0, bottom: 0, width: 0, height: toggleContainerViewHeigh)
        
        let margin: CGFloat = 5
        toggle.isOn = (UserDefaults.getReadingLanguage() == ReadingLanguage.martian) // turnOn: translate to Martian
        toggleContainerView.addSubview(toggle)
        toggle.anchor(nil, toggleContainerView.topAnchor, toggleContainerView.trailingAnchor, nil, lead: 0, top: margin, trail: margin * 4, bottom: 0, width: 0, height: 0)
        toggle.addTarget(self, action: #selector(toggleValueChanged), for: .valueChanged)
        
        let martianLabel = UILabel()
        martianLabel.font = UIFont.systemFont(ofSize: 14)
        martianLabel.text = L("article.ui.toggle.title")
        toggleContainerView.addSubview(martianLabel)
        martianLabel.anchor(nil, nil, toggle.leadingAnchor, nil, lead: 0, top: 0, trail: margin, bottom: 0)
        martianLabel.centerYAnchor.constraint(equalTo: toggle.centerYAnchor).isActive = true
    }
    
    @objc private func toggleValueChanged() {
        let newReadingLanguage: ReadingLanguage = toggle.isOn ? .martian : .english
        UserDefaults.setReadingLanguage(newReadingLanguage)
        
        if let text = article?.body {
            
        }
    }
    
}

extension ArticleViewController: UITextViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let a = scrollView.contentOffset.y
        print("testView offset: \(a)")
        
    }
    
}
