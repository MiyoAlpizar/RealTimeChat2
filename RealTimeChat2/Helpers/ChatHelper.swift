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
    
    ///Sends a message
    public func sendMessageChat(uid: String,send_to_user_uid: String,send_to_user_name: String, message: Message, done: @escaping(Bool, String) -> Void) {
        var messageText = ""
        
        switch message.kind {
        case .text(let msg):
            messageText = msg
        default:
            break
        }
        
        let date = DateFormatter.localizedString(from: Date(), dateStyle: DateFormatter.Style.short, timeStyle: DateFormatter.Style.long)
        
        
        lookForConversation(with: send_to_user_uid, current_uid: uid) { (conversation_uid) in
            let ref : DatabaseReference
            
            if conversation_uid == "" {
                ref = DatabaseHelper.shared.conversationsData.childByAutoId()
            }else {
                ref = DatabaseHelper.shared.conversationsData.child(conversation_uid)
            }
            
            
            ref.observeSingleEvent(of: DataEventType.value) { (snap) in
                var conversation = Conversation(uid: "", sender_uid: UserHelper.shared.user.uid, chat_with_uid: send_to_user_uid, latest_message: LastMessage(date: date, message: messageText, read: false), chats: [])
               
                if snap.exists() {
                    do {
                        guard let value = snap.value as? [String: Any] else {
                            return
                        }
                        conversation = try FirebaseDecoder().decode(Conversation.self, from: value)
                        conversation.latest_message.date = date
                        conversation.latest_message.message = messageText
                        conversation.latest_message.read = false
                        
                        let chat = Chat(uid: "", date: date, message: messageText, read: false, from_uid: UserHelper.shared.user.uid, from_name: UserHelper.shared.user.fullName)
                        conversation.chats.append(chat)
                        let docChat = try? FirebaseEncoder().encode(conversation)
                        
                        ref.setValue(docChat)
                        done(true, ref.key!)
                    } catch let error {
                        print(error)
                    }
                }else {
                    let chat = Chat(uid: "", date: date, message: messageText, read: false, from_uid: UserHelper.shared.user.uid, from_name: UserHelper.shared.user.fullName)
                    conversation.chats.append(chat)
                    let docChat = try? FirebaseEncoder().encode(conversation)
                    ref.setValue(docChat)
                    done(true, ref.key!)
                }
                let cu = ConversationUser(uid: ref.key!, date: date, sender_uid: UserHelper.shared.user.uid, chat_with_uid: UserHelper.shared.user.uid , latest_message: LastMessage(date: date, message: messageText, read: false), from: UserHelper.shared.user.fullName)
                let cuDoc = try? FirebaseEncoder().encode(cu)
                DatabaseHelper.shared.usersConversationsData.child(send_to_user_uid).child(ref.key!).setValue(cuDoc)
                
                let cu2 = ConversationUser(uid: ref.key!, date: date, sender_uid: send_to_user_uid, chat_with_uid: send_to_user_uid , latest_message: LastMessage(date: date, message: messageText, read: false), from: send_to_user_name)
                let cuDoc2 = try? FirebaseEncoder().encode(cu2)
                
                DatabaseHelper.shared.usersConversationsData.child(UserHelper.shared.user.uid).child(ref.key!).setValue(cuDoc2)
                
                
                
            }
            
        }
    }
    
    public func lookForConversation(with: String,current_uid: String, done: @escaping(String) -> Void) {
        
        if current_uid != "" {
            done(current_uid)
            return
        }
        
        DatabaseHelper.shared.usersConversationsData.child(UserHelper.shared.user.uid).observeSingleEvent(of: DataEventType.value) { (snap) in
            
            if !snap.exists() {
                done("")
                return
            }
            var new_uid = ""
            snap.children.forEach { (child) in
                do {
                guard let snap = child as? DataSnapshot
                else {
                    return
                }
                guard let value = snap.value as? [String: Any] else {
                    return
                }
                
                let chat = try FirebaseDecoder().decode(ConversationUser.self, from: value)
                    if chat.chat_with_uid == with {
                        new_uid = chat.uid
                        return
                    }
                } catch let error {
                    print(error)
                }
            }
            done(new_uid)
        }
        
    }
  
    
    ///Returns all conversation with current  user
    public func getAllConversation(done: @escaping(Result<Array<ConversationUser>, Error>) -> Void) {
        DatabaseHelper.shared.usersConversationsData.child(UserHelper.shared.user.uid).observe(DataEventType.value) { (snap) in
            
            var  chats: Array<ConversationUser> = []
                
            if !snap.exists() {
                done(.success([]))
                return
            }
            
            snap.children.forEach { (child) in
                do {
                    guard let snap = child as? DataSnapshot
                    else {
                        return
                    }
                    guard let value = snap.value as? [String: Any] else {
                        return
                    }
                    let chat = try FirebaseDecoder().decode(ConversationUser.self, from: value)
                    chats.append(chat)
                    
                } catch let error {
                    print(error)
                }
            }
            done(.success(chats))
            
        }
    }
    
    ///Returns all messages with user conversation
    public func getMessages(with uid: String, done: @escaping(Result<Conversation?, Error>) -> Void) {
        DatabaseHelper.shared.conversationsData.child(uid).observe(DataEventType.value) { (snap) in
            var  conversation: Conversation?
                
            if !snap.exists() {
                done(.success(conversation))
                return
            }
            
            guard let value = snap.value as? [String: Any] else {
                done(.success(conversation))
                return
            }
            
            do {
                conversation = try FirebaseDecoder().decode(Conversation.self, from: value)
                done(.success(conversation))
            } catch let error {
                print(error)
            }
        }
    }
    
}
