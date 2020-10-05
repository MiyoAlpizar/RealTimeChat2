//
//  ProfileHeaderView.swift
//  RealTimeChat2
//
//  Created by Miyo Alpízar on 05/10/20.
//  Copyright © 2020 Miyo Alpízar. All rights reserved.
//

import UIKit

class ProfileHeaderView: UIView {
    
    let circleInitailsView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.primary
        return view
    }()
    
    let labelInitials: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.text = "MA"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 36, weight: UIFont.Weight.regular)
        return label
    }()
    
    let labelName: UILabel = {
        let label = UILabel()
        //label.textColor = UIColor.white
        label.text = "Miyo Alpizar"
        label.font = UIFont.systemFont(ofSize: 20, weight: UIFont.Weight.light)
        return label
    }()
    
    
    
    override func didMoveToSuperview() {
        if superview == nil { return }
        setupViews()
    }
    
    private func setupViews() {
        self.addSubview(circleInitailsView)
        circleInitailsView.addSubview(labelInitials)
        self.addSubview(labelName)
        
        self.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.width.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalTo(labelName.snp.bottom).offset(20)
        }
        
        circleInitailsView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(16)
            make.width.equalTo(90)
            make.height.equalTo(90)
        }
        circleInitailsView.makeCornerRadius(cornerRadius: 90/2)
        
        labelInitials.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        labelName.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(circleInitailsView.snp.bottom).offset(12)
        }
        
        labelInitials.text = UserHelper.shared.user.name.substring(toIndex: 1).uppercased() + UserHelper.shared.user.lastName.substring(toIndex: 1).uppercased()
        
        labelName.text = UserHelper.shared.user.name + " " + UserHelper.shared.user.lastName
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
