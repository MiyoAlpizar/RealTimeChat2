//
//  StartViewModel.swift
//  RealTimeChat2
//
//  Created by Miyo Alpízar on 05/10/20.
//  Copyright © 2020 Miyo Alpízar. All rights reserved.
//

import Foundation
import UIKit

class  StartViewModel {
    
    func validateCurrentUser(completion: @escaping(Bool) -> Void) {
        UserHelper.shared.currentUser { (isIn) in
            completion(isIn)
        }
    }
    
}
