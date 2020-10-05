//
//  UIViewExtensions.swift
//  RealTimeChat
//
//  Created by Miyo Alpízar on 14/09/20.
//  Copyright © 2020 Miyo Alpízar. All rights reserved.
//

import UIKit

extension UIView {
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIView.dismissKeyboard))
        tap.cancelsTouchesInView = true
        self.addGestureRecognizer(tap)
    }
    
    @objc private func dismissKeyboard() {
        self.endEditing(true)
    }
    
    func makeCornerRadius(cornerRadius: CGFloat = 6)  {
        self.layer.cornerRadius = cornerRadius
        self.layer.masksToBounds = true
    }
    
    func makeShadow() {
        self.layer.shadowColor = UIColor.lightGray.cgColor
        self.layer.shadowOpacity = 0.6
        self.layer.shadowOffset = CGSize.zero
        self.layer.shadowRadius = 6.0
    }
    
    func makeCornerRadius(cornerRadius: CGFloat = 6, color: UIColor? = nil, width: CGFloat = 1)  {
        self.layer.cornerRadius = cornerRadius
        self.layer.masksToBounds = true
        if let color = color {
            self.layer.borderColor = color.cgColor
            self.layer.borderWidth = width
        }
    }
    
}

extension UITableView {
    
    func layoutTableHeaderView() {
        guard let headerView = self.tableHeaderView else { return }
        headerView.setNeedsLayout()
        headerView.layoutIfNeeded()
        headerView.layoutSubviews()
    }
    
    func deselectAllRows() {
      let rows = self.indexPathsForVisibleRows
        rows?.forEach({ (row) in
            self.deselectRow(at: row, animated: true)
        })
    }
    
}
