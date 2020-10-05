//
//  StartViewController.swift
//  RealTimeChat2
//
//  Created by Miyo Alpízar on 05/10/20.
//  Copyright © 2020 Miyo Alpízar. All rights reserved.
//

import UIKit
import SnapKit

class StartViewController: UIViewController {

    var yConstraint: Constraint!
    var topConstraint: Constraint!
    var viewmodel = StartViewModel()
    
    let logo: UIImageView = {
        let logo = UIImageView()
        logo.contentMode = .scaleAspectFit
        logo.image = #imageLiteral(resourceName: "logo")
        return logo
    }()
    
    let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.asPrimary()
        button.alpha = 0
        button.setTitle("Log In", for: UIControl.State.normal)
        return button
    }()
    
    let registerButton: UIButton = {
        let button = UIButton(type: .system)
        button.asDefault()
        button.alpha = 0
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: UIFont.Weight.light)
        button.setTitle("Create Account", for: UIControl.State.normal)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addViews()
        autoLayOut()
        setTargets()
        viewmodel.validateCurrentUser {[weak self] (isIn) in
            guard let `self` = self else { return }
                if isIn {
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    appDelegate.window!.rootViewController = MainTabViewController()
                }else {
                    self.animateLogo()
                }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
}

//MARK: ViewsAndLayout
extension StartViewController {
    
    private func animateLogo() {
        self.delayWithSeconds(0.6) { [weak self] in
            guard let `self` = self else { return }
            UIView.animate(withDuration: 0.3) { [weak self] in
                guard let `self` = self else { return }
                self.yConstraint.deactivate()
                self.topConstraint.activate()
                self.registerButton.alpha = 1.0
                self.loginButton.alpha = 1.0
                self.view.layoutIfNeeded()
            }
        }
    }
    
    private func addViews() {
        view.backgroundColor = UIColor.background
        view.addSubview(logo)
        view.addSubview(registerButton)
        view.addSubview(loginButton)
    }
    
    private func autoLayOut() {
        logo.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            yConstraint = make.centerY.equalToSuperview().constraint
            make.width.equalTo(120)
            make.height.equalTo(120)
        }
        
        logo.snp.prepareConstraints { (prepare) in
            topConstraint = prepare.top.equalToSuperview().offset(self.windowInsets.top + 60).constraint
        }
        
        registerButton.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-(self.windowInsets.bottom + 60))
            make.height.equalTo(52)
        }
        
        loginButton.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.8)
            make.bottom.equalTo(registerButton.snp.top).offset(-20)
            make.height.equalTo(52)
        }
    }
    
    private func setTargets() {
        registerButton.addTarget(self, action: #selector(onCreateAccount), for: UIControl.Event.touchUpInside)
        loginButton.addTarget(self, action: #selector(onLogin), for: UIControl.Event.touchUpInside)
    }
    
    @objc private func onLogin() {
        let account = LoginViewController()
        self.presentOnNavigationController(controller: account)
    }
    
    @objc private func onCreateAccount() {
        let account = CreateAccountViewController()
        self.presentOnNavigationController(controller: account)
    }
    
}
