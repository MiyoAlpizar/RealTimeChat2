//
//  ChatHelper.swift
//  RealTimeChat2
//
//  Created by Miyo Alpízar on 06/10/20.
//  Copyright © 2020 Miyo Alpízar. All rights reserved.
//

import Foundation
import Firebase
import CodableFirebase

class ChatHelper {
    
    private static let _shared = ChatHelper()
    
    public static var shared: ChatHelper {
        return _shared
    }
    
    ///Initalize new conversation with fisrt message
    public func createNewChat(with uid: String, message: Message, done: @escaping(Bool) -> Void) {
        var messageText = ""
        
        switch message.kind {
        case .text(let msg):
            messageText = msg
        default:
            break
        }
        
        let date = DateFormatter.localizedString(from: Date(), dateStyle: DateFormatter.Style.short, timeStyle: DateFormatter.Style.long)
        
        
        let ref = DatabaseHelper.shared.conversationsData.child(UserHelper.shared.user.uid).child(uid)
        
        
        ref.observeSingleEvent(of: DataEventType.value) { (snap) in
            var conversation = Conversation(uid: "", chat_with_uid: uid, latest_message: LastMessage(date: date, message: messageText, read: false), chats: [])
           
            if snap.exists() {
                do {
                    guard let value = snap.value as? [String: Any] else {
                        return
                    }
                    conversation = try FirebaseDecoder().decode(Conversation.self, from: value)
                    conversation.latest_message.date = date
                    conversation.latest_message.message = messageText
                    conversation.latest_message.read = false
                    
                    let chat = Chat(uid: "", date: date, message: messageText, read: false)
                    conversation.chats.append(chat)
                    let docChat = try? FirebaseEncoder().encode(conversation)
                    
                    ref.setValue(docChat)
                    
                } catch let error {
                    print(error)
                }
            }else {
                let chat = Chat(uid: "", date: date, message: messageText, read: false)
                conversation.chats.append(chat)
                let docChat = try? FirebaseEncoder().encode(conversation)
                ref.setValue(docChat)
            }
            
        }
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
