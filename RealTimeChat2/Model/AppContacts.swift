//
//  Contacts.swift
//  RealTimeChat2
//
//  Created by Miyo Alpízar on 05/10/20.
//  Copyright © 2020 Miyo Alpízar. All rights reserved.
//

import Foundation

struct AppContacts {
    var InList: Array<AppUser>
    var NotInList: Array<AppUser>
    
    init() {
        InList = []
        NotInList = []	
    }
    
}

struct Contacts {
    var uid: String
    var users: [String]?
    var contacts: [String] {
        if users != nil {
            return users!
        }
        return []
    }
}
