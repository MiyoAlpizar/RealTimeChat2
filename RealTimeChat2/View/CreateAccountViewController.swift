//
//  CreateAccountViewController.swift
//  RealTimeChat2
//
//  Created by Miyo Alpízar on 05/10/20.
//  Copyright © 2020 Miyo Alpízar. All rights reserved.
//

import UIKit
import SVProgressHUD

class CreateAccountViewController: ScrollViewController {
    
    
    let logo: UIImageView = {
        let logo = UIImageView()
        logo.contentMode = .scaleAspectFit
        logo.image = #imageLiteral(resourceName: "logo")
        return logo
    }()
    
    private let txtName: UITextField = {
        let txt = UITextField()
        txt.borderStyle = .roundedRect
        txt.returnKeyType = .next
        txt.placeholder = "Name"
        return txt
    }()
    
    private let txtLastName: UITextField = {
        let txt = UITextField()
        txt.borderStyle = .roundedRect
        txt.returnKeyType = .next
        txt.placeholder = "Last Name"
        return txt
    }()
    
    private let txtEmail: UITextField = {
        let txt = UITextField()
        txt.borderStyle = .roundedRect
        txt.returnKeyType = .next
        txt.autocapitalizationType = .none
        txt.keyboardType = .emailAddress
        txt.placeholder = "Email"
        return txt
    }()
    
    private let txtPhone: UITextField = {
        let txt = UITextField()
        txt.borderStyle = .roundedRect
        txt.returnKeyType = .next
        txt.autocapitalizationType = .none
        txt.keyboardType = .phonePad
        txt.placeholder = "Phone Number"
        return txt
    }()
    
    private let txtPwd: UITextField = {
        let txt = UITextField()
        txt.borderStyle = .roundedRect
        txt.returnKeyType = .done
        txt.placeholder = "Password"
        txt.isSecureTextEntry = true
        return txt
    }()
    
    private let btnRegister: UIButton = {
        let btn = UIButton(type: UIButton.ButtonType.system)
        btn.setTitle("Register", for: UIControl.State.normal)
        btn.asPrimary()
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setInit()
    }
    
    func setInit() {
        title = "Create Account"
        addViews()
        layoutViews()
        addTargets()
        delayWithSeconds(0.3) { [weak self] in
            guard let `self` = self else { return }
            self.txtName.becomeFirstResponder()
        }
    }
    
    private func addTargets() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel",
                                                           style: UIBarButtonItem.Style.plain,
                                                           target: self,
                                                           action: #selector(close))
        btnRegister.addTarget(self, action: #selector(validateLogin), for: UIControl.Event.touchUpInside)
    }
    
    @objc func close() {
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    @objc func validateLogin() {
        
        view.endEditing(true)
        
        if txtName.isLessThan(count: 3) {
            alert(message: "You must enter a valid name") { [weak self] in
                guard let `self` = self else { return }
                self.txtName.becomeFirstResponder()
            }
            return
        }
        
        if txtLastName.isLessThan(count: 3) {
            alert(message: "You must enter a valid Last Name") { [weak self] in
                guard let `self` = self else { return }
                self.txtLastName.becomeFirstResponder()
            }
            return
        }
        
        if !txtPhone.isNumber() {
            alert(message: "You must enter a valid Phone Number") { [weak self] in
                guard let `self` = self else { return }
                self.txtPhone.becomeFirstResponder()
            }
            return
        }
        
        if !txtEmail.isValidEmail() {
            alert(message: "You must enter a valid E-mail") { [weak self] in
                guard let `self` = self else { return }
                self.txtEmail.becomeFirstResponder()
            }
            return
        }
        
        if txtPwd.isLessThan(count: 6) {
            alert(message: "You must enter a password with 6 characters min") { [weak self] in
                guard let `self` = self else { return }
                self.txtPwd.becomeFirstResponder()
            }
            return
        }
        
        SVProgressHUD.show()
        UserHelper.shared.registerUser(email: txtEmail.text!,
                                       name: txtName.text!,
                                       lastName: txtLastName.text!,
                                       phone: txtPhone.text!,
                                       pwd: txtPwd.text!) { [weak self] (result)  in
                                        SVProgressHUD.dismiss()
                                        guard let `self` = self else { return }
                                        switch result {
                                        case .success(let uid):
                                            print(uid)
                                            let appDelegate = UIApplication.shared.delegate as! AppDelegate
                                            appDelegate.window!.rootViewController = MainTabViewController()
                                            break
                                        case .failure(let error):
                                            self.alert(message: error.localizedDescription)
                                            break
                                        }
                                        
        }
    }
    
}

//MARK:- ViewsAndLayouts
extension CreateAccountViewController {
    
    private func addViews() {
        scrollView.keyboardDismissMode = .none
        contentView.addSubview(logo)
        contentView.addSubview(txtName)
        contentView.addSubview(txtLastName)
        contentView.addSubview(txtPhone)
        contentView.addSubview(txtEmail)
        contentView.addSubview(txtPwd)
        contentView.addSubview(btnRegister)
        txtName.delegate = self
        txtLastName.delegate = self
        txtEmail.delegate = self
        txtPwd.delegate = self
    }
    
    private func layoutViews() {
        let height: CGFloat = 44
        let widthBy: CGFloat = 0.86
        
        
        logo.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(self.windowInsets.top + 20)
            make.width.equalTo(120)
            make.height.equalTo(120)
        }
        
        txtName.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(widthBy)
            make.top.equalTo(logo.snp.bottom).offset(40)
            make.height.equalTo(height)
        }
        
        txtLastName.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(widthBy)
            make.top.equalTo(txtName.snp.bottom).offset(12)
            make.height.equalTo(height)
        }
        
        txtPhone.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(widthBy)
            make.top.equalTo(txtLastName.snp.bottom).offset(12)
            make.height.equalTo(height)
        }
        
        txtEmail.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(widthBy)
            make.top.equalTo(txtPhone.snp.bottom).offset(12)
            make.height.equalTo(height)
        }
        
        txtPwd.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(widthBy)
            make.top.equalTo(txtEmail.snp.bottom).offset(12)
            make.height.equalTo(height)
        }
        
        btnRegister.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(widthBy)
            make.top.equalTo(txtPwd.snp.bottom).offset(36)
            make.height.equalTo(54)
        }
    }
    
}


//MARK:- Delegates
extension CreateAccountViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case txtName:
            txtLastName.becomeFirstResponder()
        case txtLastName:
            txtPhone.becomeFirstResponder()
        case txtPhone:
            txtEmail.becomeFirstResponder()
        case txtEmail:
            txtPwd.becomeFirstResponder()
        default:
            validateLogin()
        }
        return true
    }
}
