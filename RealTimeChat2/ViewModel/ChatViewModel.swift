//
//  ChatViewModel.swift
//  RealTimeChat2
//
//  Created by Miyo Alpízar on 06/10/20.
//  Copyright © 2020 Miyo Alpízar. All rights reserved.
//

import Foundation
import MessageKit

class ChatViewModel {
    
    public static var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .long
        formatter.locale = .current
        return formatter
    }()
    
    var chatWith: AppUser!
    let isNewChat: Bool = false
    let current = Sender(senderId: UserHelper.shared.user.uid, displayName: UserHelper.shared.user.fullName)
    let messages: [MessageType] = []


    private func getMessageId() -> String {
        let date = Self.dateFormatter.string(from: Date())
        return "\(chatWith.uid)_\(UserHelper.shared.user.uid)_\(date)"
    }
    
    public func sendMessage(with Text: String) {
        if isNewChat {
            let message = Message(sender: current,
                                  messageId: getMessageId(),
                                  sentDate: Date(),
                                  kind: MessageKind.text(Text))
            
            ChatHelper.shared.createNewChat(with: chatWith.uid, message: message) { (done) in
                if (done) {
                    print("OK")
                }else {
                    print("Error")
                }
            }
        }
    }
    
    
}

