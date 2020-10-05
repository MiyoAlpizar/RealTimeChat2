//
//  LoginViewModel.swift
//  RealTimeChat2
//
//  Created by Miyo Alpízar on 05/10/20.
//  Copyright © 2020 Miyo Alpízar. All rights reserved.
//

import Foundation

class LoginViewModel {
    
    func SendEmailToRecoveryPassword(email: String, completion: @escaping(Bool,String) -> Void) {
        UserHelper.shared.sendEmailToRecoveryPassword(with: email) {(result) in
            switch result {
            case .success(_):
                completion(true,"Link to recovery password was succesful send to " + email)
            case .failure(let error):
                completion(false,error.localizedDescription)
            }
        }
    }
    
    func Login(email: String, pwd: String, comletion: @escaping(Bool, String?) -> Void) {
        UserHelper.shared.login(email: email, pwd: pwd) { (result) in
            switch result {
            case .success(_):
                comletion(true,nil)
            case .failure(let error):
                comletion(false, error.localizedDescription)
            }
        }
    }
    
}
