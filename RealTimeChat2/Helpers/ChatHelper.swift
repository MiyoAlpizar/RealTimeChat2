//
//  ChatHelper.swift
//  RealTimeChat2
//
//  Created by Miyo Alpízar on 06/10/20.
//  Copyright © 2020 Miyo Alpízar. All rights reserved.
//

import Foundation

class ChatHelper {
    
    private static let _shared = ChatHelper()
    
    public static var shared: ChatHelper {
        return _shared
    }
    
    ///Initalize new conversation with fisrt message
    public func createNewChat(with uid: String, message: Message, done: @escaping(Bool) -> Void) {
        
    }
    
    ///Sends Message to conversation
    public func sendMessage(to converation:String, message: Message, done: @escaping(Bool) -> Void) {
        
    }
    
    ///Returns all conversation with current  user
    public func getAllConversation(done: @escaping(Result<String, Error>) -> Void) {
        
    }
    
    ///Returns all messages with user conversation
    public func getMessages(with uid: String, done: @escaping(Result<String, Error>) -> Void) {
        
    }
    
}
