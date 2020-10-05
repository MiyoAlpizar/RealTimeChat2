//
//  ScrollViewController.swift
//  RealTimeChat
//
//  Created by Miyo Alpízar on 14/09/20.
//  Copyright © 2020 Miyo Alpízar. All rights reserved.
//

import UIKit
import SnapKit

/// A simple UIViewController with ScrollView with AutoLayout, just addSubviews to contentView property
class ScrollViewController: UIViewController, KeyBoardDelegate {
    
    var keyBoardHelper: KeyBoardHelper!
    
    func heightChanged(height: CGFloat, duration: TimeInterval, isUp: Bool) {
        var contentInset:UIEdgeInsets = self.scrollView.contentInset
        contentInset.bottom = height + 20
        scrollView.contentInset = contentInset
    }
    

    let scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.alwaysBounceVertical = true
        scroll.keyboardDismissMode = .onDrag
        scroll.showsVerticalScrollIndicator = false
        scroll.showsHorizontalScrollIndicator = false
        return scroll
    }()
    
    /// AddSubviews here
    let contentView: UIView = {
        let view = UIView()
        return view
    }()
    
    var insets: UIEdgeInsets = UIEdgeInsets(top: 64, left: 0, bottom: 49, right: 0)
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        keyBoardHelper = KeyBoardHelper()
        keyBoardHelper.delegate = self
    }
    
    private func setupViews() {
        self.view.hideKeyboardWhenTappedAround()
        self.view.backgroundColor = UIColor.background
        self.view.addSubview(scrollView)
        self.scrollView.addSubview(contentView)
        
        scrollView.snp.makeConstraints { (make) in
            make.trailing.equalToSuperview()
            make.leading.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        contentView.snp.makeConstraints { (make) in
            make.width.equalToSuperview()
            make.height.equalToSuperview().offset(-(insets.top + insets.bottom  +  self.view.safeAreaInsets.bottom + self.view.safeAreaInsets.top)).priority(ConstraintPriority.low)
            make.trailing.equalToSuperview()
            make.leading.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: insets.bottom +  self.view.safeAreaInsets.bottom, right: 0)
    }
}
