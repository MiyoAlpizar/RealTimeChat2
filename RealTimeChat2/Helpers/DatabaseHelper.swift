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
    
    public let contacts = "contacts"
    
    public let contactsData = Database.database().reference(withPath: "contacts")
    
    public let conversations = "conversations"
    
    public let conversationsData = Database.database().reference(withPath: "conversations")

    public let usersConversationsData = Database.database().reference(withPath: "users_conversations")
    
    
}
