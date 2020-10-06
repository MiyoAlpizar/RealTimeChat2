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
    public func createNewChat(uid: String,send_to_user: AppUser, message: Message, done: @escaping(Bool, String) -> Void) {
        var messageText = ""
        
        switch message.kind {
        case .text(let msg):
            messageText = msg
        default:
            break
        }
        
        let date = DateFormatter.localizedString(from: Date(), dateStyle: DateFormatter.Style.short, timeStyle: DateFormatter.Style.long)
        let ref : DatabaseReference
        if uid == "" {
            ref = DatabaseHelper.shared.conversationsData.childByAutoId()
        }else {
            ref = DatabaseHelper.shared.conversationsData.child(uid)
        }
        
        
        ref.observeSingleEvent(of: DataEventType.value) { (snap) in
            var conversation = Conversation(uid: "", sender_uid: UserHelper.shared.user.uid, chat_with_uid: send_to_user.uid, latest_message: LastMessage(date: date, message: messageText, read: false), chats: [])
           
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
                    done(true, ref.key!)
                } catch let error {
                    print(error)
                }
            }else {
                let chat = Chat(uid: "", date: date, message: messageText, read: false)
                conversation.chats.append(chat)
                let docChat = try? FirebaseEncoder().encode(conversation)
                ref.setValue(docChat)
                done(true, ref.key!)
            }
            let cu = ConversationUser(uid: ref.key!, date: date, sender_uid: UserHelper.shared.user.uid, chat_with_uid: send_to_user.uid , latest_message: LastMessage(date: date, message: messageText, read: false), from: UserHelper.shared.user.fullName)
            let cuDoc = try? FirebaseEncoder().encode(cu)
            DatabaseHelper.shared.usersConversationsData.child(send_to_user.uid).child(ref.key!).setValue(cuDoc)
            
            let cu2 = ConversationUser(uid: ref.key!, date: date, sender_uid: send_to_user.uid, chat_with_uid: UserHelper.shared.user.uid , latest_message: LastMessage(date: date, message: messageText, read: false), from: send_to_user.fullName)
            let cuDoc2 = try? FirebaseEncoder().encode(cu2)
            
            DatabaseHelper.shared.usersConversationsData.child(UserHelper.shared.user.uid).child(ref.key!).setValue(cuDoc2)
            
            
            
        }
    }
    
    ///Sends Message to conversation
    public func sendMessage(to converation:String, message: Message, done: @escaping(Bool) -> Void) {
        
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
    public func getMessages(with uid: String, done: @escaping(Result<String, Error>) -> Void) {
        
    }
    
}
