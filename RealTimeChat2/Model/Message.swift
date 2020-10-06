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
