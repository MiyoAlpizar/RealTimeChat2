//
//  ChatViewModel.swift
//  RealTimeChat2
//
//  Created by Miyo Alpízar on 06/10/20.
//  Copyright © 2020 Miyo Alpízar. All rights reserved.
//

import Foundation
import MessageKit

protocol ChatDelegate: class {
    func onChatChanged()
}

class ChatViewModel {
    
    public weak var delegate: ChatDelegate?
    
    public static var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .long
        formatter.locale = .current
        return formatter
    }()
    
    var chatWithUid: String = ""
    var chatWithName: String = ""
    var conversation_uid = ""
    let current = Sender(senderId: UserHelper.shared.user.uid, displayName: UserHelper.shared.user.fullName)
    var messages: [MessageType] = []


    private func getMessageId() -> String {
        let date = Self.dateFormatter.string(from: Date())
        return "\(chatWithUid)_\(UserHelper.shared.user.uid)_\(date)"
    }
    
    public func sendMessage(with Text: String, completion: @escaping(Bool) -> Void) {
        let message = Message(sender: current,
                              messageId: getMessageId(),
                              sentDate: Date(),
                              kind: MessageKind.text(Text))
        
        ChatHelper.shared.createNewChat(uid: conversation_uid, send_to_user_uid: chatWithUid, send_to_user_name: chatWithName, message: message) { (done, uid) in
            self.conversation_uid = uid
            completion(done)
        }
    }
    
    public func loadMessages() {
        if conversation_uid == "" {
            return
        }
        ChatHelper.shared.getMessages(with: conversation_uid) { (result) in
            switch result {
            case .success(let conversation):
                guard let conversation = conversation else {
                    return
                }
                self.HandleConversation(conversation: conversation)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func HandleConversation(conversation: Conversation) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE, dd MMM yyyy hh:mm:ss +zzzz"
        dateFormatter.locale = .current
        messages.removeAll()
        conversation.chats.forEach { (chat) in
            messages.append(Message(sender: Sender(senderId: chat.from_uid, displayName: chat.from_name), messageId: chat.uid, sentDate: dateFormatter.date(from: chat.date) ?? Date(), kind: MessageKind.text(chat.message)))
        }
        
        if let delegate = delegate {
            delegate.onChatChanged()
        }
    }
    
    
}

