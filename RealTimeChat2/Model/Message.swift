//
//  Message.swift
//  RealTimeChat2
//
//  Created by Miyo Alpízar on 06/10/20.
//  Copyright © 2020 Miyo Alpízar. All rights reserved.
//

import Foundation
import MessageKit

struct Sender: SenderType {
    var senderId: String
    var displayName: String
}

struct Message: MessageType {
    var sender: SenderType
    var messageId: String
    var sentDate: Date
    var kind: MessageKind
}

struct Conversation: Codable {
    let uid: String
    let sender_uid: String
    let chat_with_uid: String
    var latest_message: LastMessage
    var chats: [Chat]
}

struct Chat: Codable {
    let uid: String
    let date: String
    let message: String
    let read: Bool
    let from_uid: String
    let from_name: String
}

struct LastMessage: Codable {
    var date: String
    var message: String
    var read: Bool
}

struct ConversationUser: Codable {
    let uid: String
    let date: String
    let sender_uid: String
    let chat_with_uid: String
    var latest_message: LastMessage
    var from: String
}
