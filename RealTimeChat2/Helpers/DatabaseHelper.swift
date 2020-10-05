//
//  DatabaseHelper.swift
//  RealTimeChat
//
//  Created by Miyo Alpízar on 15/09/20.
//  Copyright © 2020 Miyo Alpízar. All rights reserved.
//

import FirebaseDatabase

final class DatabaseHelper {
    static let shared = DatabaseHelper()
    public let database = Database.database().reference()
    
    public let users = "users"
    
    public let userData = Database.database().reference(withPath: "users")
    
}
